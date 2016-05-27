//
//  CoreDataManager.h
//  EmptyNester
//
//  Created by shao on 16/5/27.
//  Copyright © 2016年 曹少帅. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#define ManagerObjectModelFileName @"UserModel"
@interface CoreDataManager : NSObject
@property(readonly,strong,nonatomic)NSManagedObjectContext* managedObjContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *perStoreCoordinator;
+ (instancetype) sharedCoreDataManager;

- (void)saveContext;

@end
