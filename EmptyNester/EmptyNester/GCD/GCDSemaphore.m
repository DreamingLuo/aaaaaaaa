//
//  GCDSemaphore.m
//  GCD_使用
//
//  Created by 黄世平 on 16/4/21.
//  Copyright © 2016年 黄世平. All rights reserved.
//

#import "GCDSemaphore.h"

@interface GCDSemaphore ()

@property (strong, readwrite, nonatomic) dispatch_semaphore_t dispatchSemaphore;

@end

@implementation GCDSemaphore

- (instancetype)init
{
    
    self = [super init];
    
    if (self)
    {
        
        self.dispatchSemaphore = dispatch_semaphore_create(0);
    }
    
    return self;
}

- (instancetype)initWithValue:(long)value {
    
    self = [super init];
    
    if (self)
    {
        
        self.dispatchSemaphore = dispatch_semaphore_create(value);
    }
    
    return self;
}

- (BOOL)signal
{
    
    return dispatch_semaphore_signal(self.dispatchSemaphore) != 0;
}

- (void)wait
{
    
    dispatch_semaphore_wait(self.dispatchSemaphore, DISPATCH_TIME_FOREVER);
}

- (BOOL)wait:(int64_t)delta
{
    
    return dispatch_semaphore_wait(self.dispatchSemaphore, dispatch_time(DISPATCH_TIME_NOW, delta)) == 0;
}

@end
