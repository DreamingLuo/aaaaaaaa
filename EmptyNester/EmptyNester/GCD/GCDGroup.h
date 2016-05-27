//
//  GCDGroup.h
//  GCD_使用
//
//  Created by 黄世平 on 16/4/21.
//  Copyright © 2016年 黄世平. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCDGroup : NSObject

@property (strong, nonatomic, readonly) dispatch_group_t dispatchGroup;

#pragma 初始化
- (instancetype)init;

#pragma mark - 用法
- (void)enter; /**<任务进入组中*/
- (void)leave;/**<任务离开组*/
- (void)wait;/**<等待组中的任务完成*/
- (BOOL)wait:(int64_t)delta;/**<等待多长时间*/
@end
