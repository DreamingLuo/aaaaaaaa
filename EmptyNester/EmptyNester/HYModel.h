//
//  HYModel.h
//  FMDB_DEMO
//
//  Created by 上官惠阳 on 16/4/7.
//  Copyright © 2016年 上官惠阳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYModel : NSObject<NSCoding>

@property (strong,nonatomic)NSString *modelId;
@property (strong,nonatomic)NSString *attribute1;//属性1
@property (strong,nonatomic)NSString *attribute2;
@property (strong,nonatomic)NSString *attribute3;
@property (strong,nonatomic)NSString *attribute4;
@end
