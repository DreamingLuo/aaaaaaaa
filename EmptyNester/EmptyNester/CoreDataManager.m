//
//  CoreDataManager.m
//  EmptyNester
//
//  Created by shao on 16/5/27.
//  Copyright © 2016年 曹少帅. All rights reserved.
//

#import "CoreDataManager.h"

@implementation CoreDataManager
@synthesize managedObjContext = _managedObjContext;
@synthesize managedObjModel = _managedObjModel;
@synthesize perStoreCoordinator = _perStoreCoordinator;

static CoreDataManager *coredataManager;

+ (instancetype) sharedCoreDataManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        coredataManager = [[self alloc] init];
    });
    return coredataManager;
}
//被管理的对象模型
- (NSManagedObjectModel *)managedObjModel
{
    if (_managedObjModel != nil) {
        return _managedObjModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:ManagerObjectModelFileName withExtension:@"momd"];
    _managedObjModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjModel;
}

//被管理的上下文:操作实际内容
-(NSManagedObjectContext *)managedObjContext
{
    if (_managedObjContext != nil) {
        return _managedObjContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self perStoreCoordinator];
    if (coordinator != nil) {
        _managedObjContext = [[NSManagedObjectContext alloc] init];
        [_managedObjContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjContext;
}

//持久化存储助理:相当于数据库的连接器
-(NSPersistentStoreCoordinator *)perStoreCoordinator
{
    if (_perStoreCoordinator != nil) {
        return _perStoreCoordinator;
    }
    //CoreData是建立在SQLite之上的，数据库名称需与Xcdatamodel文件同名
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",ManagerObjectModelFileName]];
    
    NSLog(@"path = %@",storeURL.path);
    NSError *error = nil;
    _perStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjModel]];
    if (![_perStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = @"There was an error creating or loading the application's saved data.";
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"your error domain" code:999 userInfo:dict];
        
        NSLog(@"error: %@,%@",error,[error userInfo]);
        abort();
    }
    return _perStoreCoordinator;
}

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

//保存数据
- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


@end
