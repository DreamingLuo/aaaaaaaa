//
//  GCDQueue.h
//  GCD_使用
//
//  Created by 黄世平 on 16/4/21.
//  Copyright © 2016年 黄世平. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCDGroup;

@interface GCDQueue : NSObject

@property (strong, readonly, nonatomic) dispatch_queue_t dispatchQueue;

+ (GCDQueue *)mainQueue;/**<主队列*/
+ (GCDQueue *)globalQueue;/**<全局队列*/
+ (GCDQueue *)highPriorityGlobalQueue;/**<高优先级队列*/
+ (GCDQueue *)lowPriorityGlobalQueue;/**<低优先级队列*/
+ (GCDQueue *)backgroundPriorityGlobalQueue;/**<后台队列*/

#pragma mark - 便利的构造方法
+ (void)executeInMainQueue:(dispatch_block_t)block; /**<在主队列里添加任务*/
+ (void)executeInGlobalQueue:(dispatch_block_t)block;/**<在全局队列里添加任务*/
+ (void)executeInHighPriorityGlobalQueue:(dispatch_block_t)block;/**<在高优先级全局队列里添加任务*/
+ (void)executeInLowPriorityGlobalQueue:(dispatch_block_t)block;/**<在低优先级全局队列里添加任务*/
+ (void)executeInBackgroundPriorityGlobalQueue:(dispatch_block_t)block;/**<在后台队列里添加任务*/
+ (void)executeInMainQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec;/**<延迟几秒后在主队列里添加任务*/
+ (void)executeInGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec;/**<延迟几秒后在全局队列里添加任务*/
+ (void)executeInHighPriorityGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec;/**<延迟几秒后在高优先级全局队列里添加任务*/
+ (void)executeInLowPriorityGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec;/**<延迟几秒后在低优先级全局队列里添加任务*/
+ (void)executeInBackgroundPriorityGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec;/**<延迟几秒后在后台队列里添加任务*/

#pragma 初始化
- (instancetype)init;/**<初始化队列*/
- (instancetype)initSerial;/**<初始化串行队列*/
- (instancetype)initSerialWithLabel:(NSString *)label;/**<初始化串行队列具有标签*/
- (instancetype)initConcurrent;/**<初始化并行队列*/
- (instancetype)initConcurrentWithLabel:(NSString *)label;/**<初始化并行队列具有标签*/

#pragma mark - 用法
- (void)execute:(dispatch_block_t)block;/**<执行任务*/
- (void)execute:(dispatch_block_t)block afterDelay:(int64_t)delta;/**<延迟几秒后执行任务*/
- (void)execute:(dispatch_block_t)block afterDelaySecs:(float)delta;/**<延迟几秒后执行任务*/
- (void)waitExecute:(dispatch_block_t)block;/**<等待任务执行*/
- (void)barrierExecute:(dispatch_block_t)block;/**<执行阻塞任务*/
- (void)waitBarrierExecute:(dispatch_block_t)block;/**<等待阻塞任务执行*/
- (void)suspend;/**<挂起队列*/
- (void)resume;/**<重用*/

#pragma mark - 与GCDGroup相关
- (void)execute:(dispatch_block_t)block inGroup:(GCDGroup *)group; /**<在组线程里执行一个任务*/
- (void)notify:(dispatch_block_t)block inGroup:(GCDGroup *)group;

@end