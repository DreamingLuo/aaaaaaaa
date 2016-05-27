//
//  CSModelTool.h
//  Note
//
//  Created by shao on 16/5/24.
//  Copyright © 2016年 曹少帅. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
@class MemorandumModel;
@interface CSModelTool : NSObject

//插入模型数据
+(BOOL)insertModel:(MemorandumModel*)model;

//查询数据，如果传空，默认会查询表中所有数据
+(NSArray*)queryData:(NSString*)querySql;

//删除数据，如果传空 默认会删除表中所有数据
+(BOOL)deleteData:(MemorandumModel*)deleteModel;
//修改数据
+(BOOL)modifyData:(MemorandumModel*)modifyModel;
@end
