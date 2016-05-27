//
//  GCDSemaphore.h
//  GCD_使用
//
//  Created by 黄世平 on 16/4/21.
//  Copyright © 2016年 黄世平. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCDSemaphore : NSObject

@property (strong, readonly, nonatomic) dispatch_semaphore_t dispatchSemaphore;

#pragma 初始化
- (instancetype)init;
- (instancetype)initWithValue:(long)value;

#pragma mark - 用法
- (BOOL)signal; /**<信号*/
- (void)wait; /**<等待*/
- (BOOL)wait:(int64_t)delta;/**<等待多久*/

@end

