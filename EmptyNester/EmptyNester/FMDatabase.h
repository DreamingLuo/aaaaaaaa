#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "FMResultSet.h"
#import "FMDatabasePool.h"


#if ! __has_feature(objc_arc)
    #define FMDBAutorelease(__v) ([__v autorelease]);
    #define FMDBReturnAutoreleased FMDBAutorelease

    #define FMDBRetain(__v) ([__v retain]);
    #define FMDBReturnRetained FMDBRetain

    #define FMDBRelease(__v) ([__v release]);

    #define FMDBDispatchQueueRelease(__v) (dispatch_release(__v));
#else
    // -fobjc-arc
    #define FMDBAutorelease(__v)
    #define FMDBReturnAutoreleased(__v) (__v)

    #define FMDBRetain(__v)
    #define FMDBReturnRetained(__v) (__v)

    #define FMDBRelease(__v)

// If OS_OBJECT_USE_OBJC=1, then the dispatch objects will be treated like ObjC objects
// and will participate in ARC.
// See the section on "Dispatch Queues and Automatic Reference Counting" in "Grand Central Dispatch (GCD) Reference" for details. 
    #if OS_OBJECT_USE_OBJC
        #define FMDBDispatchQueueRelease(__v)
    #else
        #define FMDBDispatchQueueRelease(__v) (dispatch_release(__v));
    #endif
#endif

#if !__has_feature(objc_instancetype)
    #define instancetype id
#endif


typedef int(^FMDBExecuteStatementsCallbackBlock)(NSDictionary *resultsDictionary);


/** A SQLite ([http://sqlite.org/](http://sqlite.org/)) Objective-C wrapper.
 
 ### Usage
 The three main classes in FMDB are:

 - `FMDatabase` - Represents a single SQLite database.  Used for executing SQL statements.
 - `<FMResultSet>` - Represents the results of executing a query on an `FMDatabase`.
 - `<FMDatabaseQueue>` - If you want to perform queries and updates on multiple threads, you'll want to use this class.

 ### See also
 
 - `<FMDatabasePool>` - A pool of `FMDatabase` objects.
 - `<FMStatement>` - A wrapper for `sqlite_stmt`.
 
 ### External links
 
 - [FMDB on GitHub](https://github.com/ccgus/fmdb) including introductory documentation
 - [SQLite web site](http://sqlite.org/)
 - [FMDB mailing list](http://groups.google.com/group/fmdb)
 - [SQLite FAQ](http://www.sqlite.org/faq.html)
 
 @warning Do not instantiate a single `FMDatabase` object and use it across multiple threads. Instead, use `<FMDatabaseQueue>`.

 */

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-interface-ivars"


@interface FMDatabase : NSObject  {
    
    sqlite3*            _db;
    NSString*           _databasePath;
    BOOL                _logsErrors;
    BOOL                _crashOnErrors;
    BOOL                _traceExecution;
    BOOL                _checkedOut;
    BOOL                _shouldCacheStatements;
    BOOL                _isExecutingStatement;
    BOOL                _inTransaction;
    NSTimeInterval      _maxBusyRetryTimeInterval;
    NSTimeInterval      _startBusyRetryTime;
    
    NSMutableDictionary *_cachedStatements;
    NSMutableSet        *_openResultSets;
    NSMutableSet        *_openFunctions;

    NSDateFormatter     *_dateFormat;
}

///-----------------
/// @name Properties
///-----------------

/** Whether should trace execution */

@property (atomic, assign) BOOL traceExecution;

/** Whether checked out or not */

@property (atomic, assign) BOOL checkedOut;

/** Crash on errors */

@property (atomic, assign) BOOL crashOnErrors;

/** Logs errors */

@property (atomic, assign) BOOL logsErrors;

/** Dictionary of cached statements */

@property (atomic, retain) NSMutableDictionary *cachedStatements;

///---------------------
/// @name Initialization
///---------------------

/** Create a `FMDatabase` object.
 
 An `FMDatabase` is created with a path to a SQLite database file.  This path can be one of these three:

 1. A file system path.  The file does not have to exist on disk.  If it does not exist, it is created for you.
 2. An empty string (`@""`).  An empty database is created at a temporary location.  This database is deleted with the `FMDatabase` connection is closed.
 3. `nil`.  An in-memory database is created.  This database will be destroyed with the `FMDatabase` connection is closed.

 For example, to create/open a database in your Mac OS X `tmp` folder:

    FMDatabase *db = [FMDatabase databaseWithPath:@"/tmp/tmp.db"];

 Or, in iOS, you might open a database in the app's `Documents` directory:

    NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbPath   = [docsPath stringByAppendingPathComponent:@"test.db"];
    FMDatabase *db     = [FMDatabase databaseWithPath:dbPath];

 (For more information on temporary and in-memory databases, read the sqlite documentation on the subject: [http://www.sqlite.org/inmemorydb.html](http://www.sqlite.org/inmemorydb.html))

 @param inPath Path of database file

 @return `FMDatabase` object if successful; `nil` if failure.

 */

+ (instancetype)databaseWithPath:(NSString*)inPath;

/** Initialize a `FMDatabase` object.
 
 An `FMDatabase` is created with a path to a SQLite database file.  This path can be one of these three:

 1. A file system path.  The file does not have to exist on disk.  If it does not exist, it is created for you.
 2. An empty string (`@""`).  An empty database is created at a temporary location.  This database is deleted with the `FMDatabase` connection is closed.
 3. `nil`.  An in-memory database is created.  This database will be destroyed with the `FMDatabase` connection is closed.

 For example, to create/open a database in your Mac OS X `tmp` folder:

    FMDatabase *db = [FMDatabase databaseWithPath:@"/tmp/tmp.db"];

 Or, in iOS, you might open a database in the app's `Documents` directory:

    NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbPath   = [docsPath stringByAppendingPathComponent:@"test.db"];
    FMDatabase *db     = [FMDatabase databaseWithPath:dbPath];

 (For more information on temporary and in-memory databases, read the sqlite documentation on the subject: [http://www.sqlite.org/inmemorydb.html](http://www.sqlite.org/inmemorydb.html))

 @param inPath Path of database file
 
 @return `FMDatabase` object if successful; `nil` if failure.

 */

- (instancetype)initWithPath:(NSString*)inPath;


///-----------------------------------
/// @name Opening and closing database
///-----------------------------------

/** Opening a new database connection
 
 The database is opened for reading and writing, and is created if it does not already exist.

 @return `YES` if successful, `NO` on error.

 @see [sqlite3_open()](http://sqlite.org/c3ref/open.html)
 @see openWithFlags:
 @see close
 */

- (BOOL)open;

/** Opening a new database connection with flags

 @param flags one of the following three values, optionally combined with the `SQLITE_OPEN_NOMUTEX`, `SQLITE_OPEN_FULLMUTEX`, `SQLITE_OPEN_SHAREDCACHE`, `SQLITE_OPEN_PRIVATECACHE`, and/or `SQLITE_OPEN_URI` flags:

 `SQLITE_OPEN_READONLY`

 The database is opened in read-only mode. If the database does not already exist, an error is returned.
 
 `SQLITE_OPEN_READWRITE`
 
 The database is opened for reading and writing if possible, or reading only if the file is write protected by the operating system. In either case the database must already exist, otherwise an error is returned.
 
 `SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE`
 
 The database is opened for reading and writing, and is created if it does not already exist. This is the behavior that is always used for `open` method.
 
 @return `YES` if successful, `NO` on error.

 @see [sqlite3_open_v2()](http://sqlite.org/c3ref/open.html)
 @see open
 @see close
 */

#if SQLITE_VERSION_NUMBER >= 3005000
- (BOOL)openWithFlags:(int)flags;
#endif

/** Closing a database connection
 
 @return `YES` if success, `NO` on error.
 
 @see [sqlite3_close()](http://sqlite.org/c3ref/close.html)
 @see open
 @see openWithFlags:
 */

- (BOOL)close;

/** Test to see if we have a good connection to the database.
 
 This will confirm whether:
 
 - is database open
 - if open, it will try a simple SELECT statement and confirm that it succeeds.

 @return `YES` if everything succeeds, `NO` on failure.
 */

- (BOOL)goodConnection;


///----------------------
/// @name Perform updates
///----------------------

/** Execute single update statement
 
 This method executes a single SQL update statement (i.e. any SQL that does not return results, such as `UPDATE`, `INSERT`, or `DELETE`. This method employs [`sqlite3_prepare_v2`](http://sqlite.org/c3ref/prepare.html), [`sqlite3_bind`](http://sqlite.org/c3ref/bind_blob.html) to bind values to `?` placeholders in the SQL with the optional list of parameters, and [`sqlite_step`](http://sqlite.org/c3ref/step.html) to perform the update.

 The optional values provided to this method should be objects (e.g. `NSString`, `NSNumber`, `NSNull`, `NSDate`, and `NSData` objects), not fundamental data types (e.g. `int`, `long`, `NSInteger`, etc.). This method automatically handles the aforementioned object types, and all other object types will be interpreted as text values using the object's `description` method.

 @param sql The SQL to be performed, with optional `?` placeholders.
 
 @param outErr A reference to the `NSError` pointer to be updated with an auto released `NSError` object if an error if an error occurs. If `nil`, no `NSError` object will be returned.
 
 @param ... Optional parameters to bind to `?` placeholders in the SQL statement. These should be Objective-C objects (e.g. `NSString`, `NSNumber`, etc.), not fundamental C data types (e.g. `int`, `char *`, etc.).

 @return `YES` upon success; `NO` upon failure. If failed, you can call `<lastError>`, `<lastErrorCode>`, or `<lastErrorMessage>` for diagnostic information regarding the failure.

 @see lastError
 @see lastErrorCode
 @see lastErrorMessage
 @see [`sqlite3_bind`](http://sqlite.org/c3ref/bind_blob.html)
 */

- (BOOL)executeUpdate:(NSString*)sql withErrorAndBindings:(NSError**)outErr, ...;

/** Execute single update statement
 
 @see executeUpdate:withErrorAndBindings:
 
 @warning **Deprecated**: Please use `<executeUpdate:withErrorAndBindings>` instead.
 */

- (BOOL)update:(NSString*)sql withErrorAndBindings:(NSError**)outErr, ... __attribute__ ((deprecated));

/** Execute single update statement

 This method executes a single SQL update statement (i.e. any SQL that does not return results, such as `UPDATE`, `INSERT`, or `DELETE`. This method employs [`sqlite3_prepare_v2`](http://sqlite.org/c3ref/prepare.html), [`sqlite3_bind`](http://sqlite.org/c3ref/bind_blob.html) to bind values to `?` placeholders in the SQL with the optional list of parameters, and [`sqlite_step`](http://sqlite.org/c3ref/step.html) to perform the update.

 The optional values provided to this method should be objects (e.g. `NSString`, `NSNumber`, `NSNull`, `NSDate`, and `NSData` objects), not fundamental data types (e.g. `int`, `long`, `NSInteger`, etc.). This method automatically handles the aforementioned object types, and all other object types will be interpreted as text values using the object's `description` method.
 
 @param sql The SQL to be performed, with optional `?` placeholders.

 @param ... Optional parameters to bind to `?` placeholders in the SQL statement. These should be Objective-C objects (e.g. `NSString`, `NSNumber`, etc.), not fundamental C data types (e.g. `int`, `char *`, etc.).

 @return `YES` upon success; `NO` upon failure. If failed, you can call `<lastError>`, `<lastErrorCode>`, or `<lastErrorMessage>` for diagnostic information regarding the failure.
 
 @see lastError
 @see lastErrorCode
 @see lastErrorMessage
 @see [`sqlite3_bind`](http://sqlite.org/c3ref/bind_blob.html)
 
 @note This technique supports the use of `?` placeholders in the SQL, automatically binding any supplied value parameters to those placeholders. This approach is more robust than techniques that entail using `stringWithFormat` to manually build SQL statements, which can be problematic if the values happened to include any characters that needed to be quoted.
 
 @note If you want to use this from Swift, please note that you must include `FMDatabaseVariadic.swift` in your project. Without that, you cannot use this method directly, and instead have to use methods such as `<executeUpdate:withArgumentsInArray:>`.
 */

- (BOOL)executeUpdate:(NSString*)sql, ...;



- (BOOL)executeUpdateWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);



- (BOOL)executeUpdate:(NSString*)sql withArgumentsInArray:(NSArray *)arguments;


- (BOOL)executeUpdate:(NSString*)sql withParameterDictionary:(NSDictionary *)arguments;



- (BOOL)executeUpdate:(NSString*)sql withVAList: (va_list)args;



- (BOOL)executeStatements:(NSString *)sql;


- (BOOL)executeStatements:(NSString *)sql withResultBlock:(FMDBExecuteStatementsCallbackBlock)block;


- (sqlite_int64)lastInsertRowId;



- (int)changes;



- (FMResultSet *)executeQuery:(NSString*)sql, ...;



- (FMResultSet *)executeQueryWithFormat:(NSString*)format, ... NS_FORMAT_FUNCTION(1,2);


- (FMResultSet *)executeQuery:(NSString *)sql withArgumentsInArray:(NSArray *)arguments;


- (FMResultSet *)executeQuery:(NSString *)sql withParameterDictionary:(NSDictionary *)arguments;


// Documentation forthcoming.
- (FMResultSet *)executeQuery:(NSString*)sql withVAList: (va_list)args;


- (BOOL)beginTransaction;



- (BOOL)beginDeferredTransaction;


- (BOOL)commit;



- (BOOL)rollback;



- (BOOL)inTransaction;




- (void)clearCachedStatements;

/** Close all open result sets */

- (void)closeOpenResultSets;

/** Whether database has any open result sets
 
 @return `YES` if there are open result sets; `NO` if not.
 */

- (BOOL)hasOpenResultSets;

/** Return whether should cache statements or not
 
 @return `YES` if should cache statements; `NO` if not.
 */

- (BOOL)shouldCacheStatements;

/** Set whether should cache statements or not
 
 @param value `YES` if should cache statements; `NO` if not.
 */

- (void)setShouldCacheStatements:(BOOL)value;


- (BOOL)setKey:(NSString*)key;



- (BOOL)rekey:(NSString*)key;



- (BOOL)setKeyWithData:(NSData *)keyData;


- (BOOL)rekeyWithData:(NSData *)keyData;




- (NSString *)databasePath;


- (sqlite3*)sqliteHandle;




- (NSString*)lastErrorMessage;



- (int)lastErrorCode;



- (BOOL)hadError;



- (NSError*)lastError;


// description forthcoming
- (void)setMaxBusyRetryTimeInterval:(NSTimeInterval)timeoutInSeconds;
- (NSTimeInterval)maxBusyRetryTimeInterval;


#if SQLITE_VERSION_NUMBER >= 3007000



- (BOOL)startSavePointWithName:(NSString*)name error:(NSError**)outErr;



- (BOOL)releaseSavePointWithName:(NSString*)name error:(NSError**)outErr;



- (BOOL)rollbackToSavePointWithName:(NSString*)name error:(NSError**)outErr;



- (NSError*)inSavePoint:(void (^)(BOOL *rollback))block;

#endif



+ (BOOL)isSQLiteThreadSafe;


+ (NSString*)sqliteLibVersion;


+ (NSString*)FMDBUserVersion;

+ (SInt32)FMDBVersion;


///------------------------
/// @name Make SQL function
///------------------------

/** Adds SQL functions or aggregates or to redefine the behavior of existing SQL functions or aggregates.
 
 For example:
 
    [queue inDatabase:^(FMDatabase *adb) {

        [adb executeUpdate:@"create table ftest (foo text)"];
        [adb executeUpdate:@"insert into ftest values ('hello')"];
        [adb executeUpdate:@"insert into ftest values ('hi')"];
        [adb executeUpdate:@"insert into ftest values ('not h!')"];
        [adb executeUpdate:@"insert into ftest values ('definitely not h!')"];

        [adb makeFunctionNamed:@"StringStartsWithH" maximumArguments:1 withBlock:^(sqlite3_context *context, int aargc, sqlite3_value **aargv) {
            if (sqlite3_value_type(aargv[0]) == SQLITE_TEXT) {
                @autoreleasepool {
                    const char *c = (const char *)sqlite3_value_text(aargv[0]);
                    NSString *s = [NSString stringWithUTF8String:c];
                    sqlite3_result_int(context, [s hasPrefix:@"h"]);
                }
            }
            else {
                NSLog(@"Unknown formart for StringStartsWithH (%d) %s:%d", sqlite3_value_type(aargv[0]), __FUNCTION__, __LINE__);
                sqlite3_result_null(context);
            }
        }];

        int rowCount = 0;
        FMResultSet *ars = [adb executeQuery:@"select * from ftest where StringStartsWithH(foo)"];
        while ([ars next]) {
            rowCount++;
            NSLog(@"Does %@ start with 'h'?", [rs stringForColumnIndex:0]);
        }
        FMDBQuickCheck(rowCount == 2);
    }];

 @param name Name of function

 @param count Maximum number of parameters

 @param block The block of code for the function

 @see [sqlite3_create_function()](http://sqlite.org/c3ref/create_function.html)
 */

- (void)makeFunctionNamed:(NSString*)name maximumArguments:(int)count withBlock:(void (^)(sqlite3_context *context, int argc, sqlite3_value **argv))block;


///---------------------
/// @name Date formatter
///---------------------

/** Generate an `NSDateFormatter` that won't be broken by permutations of timezones or locales.
 
 Use this method to generate values to set the dateFormat property.
 
 Example:

    myDB.dateFormat = [FMDatabase storeableDateFormat:@"yyyy-MM-dd HH:mm:ss"];

 @param format A valid NSDateFormatter format string.
 
 @return A `NSDateFormatter` that can be used for converting dates to strings and vice versa.
 
 @see hasDateFormatter
 @see setDateFormat:
 @see dateFromString:
 @see stringFromDate:
 @see storeableDateFormat:

 @warning Note that `NSDateFormatter` is not thread-safe, so the formatter generated by this method should be assigned to only one FMDB instance and should not be used for other purposes.

 */

+ (NSDateFormatter *)storeableDateFormat:(NSString *)format;

/** Test whether the database has a date formatter assigned.
 
 @return `YES` if there is a date formatter; `NO` if not.
 
 @see hasDateFormatter
 @see setDateFormat:
 @see dateFromString:
 @see stringFromDate:
 @see storeableDateFormat:
 */

- (BOOL)hasDateFormatter;

/** Set to a date formatter to use string dates with sqlite instead of the default UNIX timestamps.
 
 @param format Set to nil to use UNIX timestamps. Defaults to nil. Should be set using a formatter generated using FMDatabase::storeableDateFormat.
 
 @see hasDateFormatter
 @see setDateFormat:
 @see dateFromString:
 @see stringFromDate:
 @see storeableDateFormat:
 
 @warning Note there is no direct getter for the `NSDateFormatter`, and you should not use the formatter you pass to FMDB for other purposes, as `NSDateFormatter` is not thread-safe.
 */

- (void)setDateFormat:(NSDateFormatter *)format;

/** Convert the supplied NSString to NSDate, using the current database formatter.
 
 @param s `NSString` to convert to `NSDate`.
 
 @return The `NSDate` object; or `nil` if no formatter is set.
 
 @see hasDateFormatter
 @see setDateFormat:
 @see dateFromString:
 @see stringFromDate:
 @see storeableDateFormat:
 */

- (NSDate *)dateFromString:(NSString *)s;

/** Convert the supplied NSDate to NSString, using the current database formatter.
 
 @param date `NSDate` of date to convert to `NSString`.

 @return The `NSString` representation of the date; `nil` if no formatter is set.
 
 @see hasDateFormatter
 @see setDateFormat:
 @see dateFromString:
 @see stringFromDate:
 @see storeableDateFormat:
 */

- (NSString *)stringFromDate:(NSDate *)date;

@end


/** Objective-C wrapper for `sqlite3_stmt`
 
 This is a wrapper for a SQLite `sqlite3_stmt`. Generally when using FMDB you will not need to interact directly with `FMStatement`, but rather with `<FMDatabase>` and `<FMResultSet>` only.
 
 ### See also
 
 - `<FMDatabase>`
 - `<FMResultSet>`
 - [`sqlite3_stmt`](http://www.sqlite.org/c3ref/stmt.html)
 */

@interface FMStatement : NSObject {
    sqlite3_stmt *_statement;
    NSString *_query;
    long _useCount;
    BOOL _inUse;
}

///-----------------
/// @name Properties
///-----------------

/** Usage count */

@property (atomic, assign) long useCount;

/** SQL statement */

@property (atomic, retain) NSString *query;

/** SQLite sqlite3_stmt
 
 @see [`sqlite3_stmt`](http://www.sqlite.org/c3ref/stmt.html)
 */

@property (atomic, assign) sqlite3_stmt *statement;

/** Indication of whether the statement is in use */

@property (atomic, assign) BOOL inUse;

///----------------------------
/// @name Closing and Resetting
///----------------------------

/** Close statement */

- (void)close;

/** Reset statement */

- (void)reset;

@end

#pragma clang diagnostic pop

