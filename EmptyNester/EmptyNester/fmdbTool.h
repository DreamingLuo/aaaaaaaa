//
//  fmdbTool.h
//  FMDB_DEMO
//
//  Created by 上官惠阳 on 16/4/7.
//  Copyright © 2016年 上官惠阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "HYModel.h"

@interface fmdbTool : NSObject
//归档
+(NSData *)encodeModel:(HYModel *)model;
//接档
+(HYModel *)decodeModelData:(NSData *)modelData;

/** 插入模型数据*/
+ (BOOL)insertModel:(HYModel *)model;

/** 查询数据 modelId为空时获取所有*/
+ (NSArray *)queryDataWithId:(NSString *)modelId;

/** 删除数据 */
+ (BOOL)deleteDataWithId:(NSString *)modelId;

/** 修改数据 */
+ (BOOL)modifyDataWithId:(NSString *)modelId andModel:(HYModel *)model;

@end
