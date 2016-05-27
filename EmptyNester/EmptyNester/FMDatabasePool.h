//
//  FMDatabasePool.h
//  fmdb
//
//  Created by August Mueller on 6/22/11.
//  Copyright 2011 Flying Meat Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@class FMDatabase;



@interface FMDatabasePool : NSObject {
    NSString            *_path;
    
    dispatch_queue_t    _lockQueue;
    
    NSMutableArray      *_databaseInPool;
    NSMutableArray      *_databaseOutPool;
    
    __unsafe_unretained id _delegate;
    
    NSUInteger          _maximumNumberOfDatabasesToCreate;
    int                 _openFlags;
}

/** Database path */

@property (atomic, retain) NSString *path;

/** Delegate object */

@property (atomic, assign) id delegate;

/** Maximum number of databases to create */

@property (atomic, assign) NSUInteger maximumNumberOfDatabasesToCreate;

/** Open flags */

@property (atomic, readonly) int openFlags;




+ (instancetype)databasePoolWithPath:(NSString*)aPath;



+ (instancetype)databasePoolWithPath:(NSString*)aPath flags:(int)openFlags;



- (instancetype)initWithPath:(NSString*)aPath;



- (instancetype)initWithPath:(NSString*)aPath flags:(int)openFlags;



- (NSUInteger)countOfCheckedInDatabases;

/** Number of checked-out databases in pool

 @returns Number of databases
 */

- (NSUInteger)countOfCheckedOutDatabases;

/** Total number of databases in pool

 @returns Number of databases
 */

- (NSUInteger)countOfOpenDatabases;

/** Release all databases in pool */

- (void)releaseAllDatabases;



- (void)inDatabase:(void (^)(FMDatabase *db))block;

/** Synchronously perform database operations in pool using transaction.

 @param block The code to be run on the `FMDatabasePool` pool.
 */

- (void)inTransaction:(void (^)(FMDatabase *db, BOOL *rollback))block;

/** Synchronously perform database operations in pool using deferred transaction.

 @param block The code to be run on the `FMDatabasePool` pool.
 */

- (void)inDeferredTransaction:(void (^)(FMDatabase *db, BOOL *rollback))block;

#if SQLITE_VERSION_NUMBER >= 3007000

/** Synchronously perform database operations in pool using save point.

 @param block The code to be run on the `FMDatabasePool` pool.
 
 @return `NSError` object if error; `nil` if successful.

 @warning You can not nest these, since calling it will pull another database out of the pool and you'll get a deadlock. If you need to nest, use `<[FMDatabase startSavePointWithName:error:]>` instead.
*/

- (NSError*)inSavePoint:(void (^)(FMDatabase *db, BOOL *rollback))block;
#endif

@end


/** FMDatabasePool delegate category
 
 This is a category that defines the protocol for the FMDatabasePool delegate
 */

@interface NSObject (FMDatabasePoolDelegate)

/** Asks the delegate whether database should be added to the pool. 
 
 @param pool     The `FMDatabasePool` object.
 @param database The `FMDatabase` object.
 
 @return `YES` if it should add database to pool; `NO` if not.
 
 */

- (BOOL)databasePool:(FMDatabasePool*)pool shouldAddDatabaseToPool:(FMDatabase*)database;

/** Tells the delegate that database was added to the pool.
 
 @param pool     The `FMDatabasePool` object.
 @param database The `FMDatabase` object.

 */

- (void)databasePool:(FMDatabasePool*)pool didAddDatabase:(FMDatabase*)database;

@end

