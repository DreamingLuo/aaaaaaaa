//
//  fmdbTool.m
//  FMDB_DEMO
//
//  Created by 上官惠阳 on 16/4/7.
//  Copyright © 2016年 上官惠阳. All rights reserved.
//

#import "fmdbTool.h"

#define LVSQLITE_NAME @"modelData.sqlite"
#define kArchivingDataKey @"modelData"

@implementation fmdbTool
static FMDatabase *_fmdb;

//这个调用的时间发生在你的类接收到消息之前
+ (void)initialize {
    // 执行打开数据库和创建表操作
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:LVSQLITE_NAME];
    _fmdb = [FMDatabase databaseWithPath:filePath];

    [_fmdb open];

#warning 必须先打开数据库才能创建表。。。否则提示数据库没有打开
    [_fmdb executeUpdate:@"CREATE TABLE IF NOT EXISTS t_model(modelId TEXT,modelData TEXT);"];
}

+(NSData *)encodeModel:(HYModel *)model
{
    NSMutableData *archivingData = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:archivingData];

    [archiver encodeObject:model forKey:kArchivingDataKey]; // archivingDate的encodeWithCoder
    [archiver finishEncoding];

    return archivingData;
}

+(HYModel *)decodeModelData:(NSData *)modelData
{
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:modelData];

    //获得类
    HYModel *model = [unarchiver decodeObjectForKey:kArchivingDataKey];// initWithCoder方法被调用
    [unarchiver finishDecoding];

    return model;
}

/** 插入模型数据*/
+ (BOOL)insertModel:(HYModel *)model
{
    NSData *modelData = [fmdbTool encodeModel:model];
    //把data转string
    NSString *dataStr = [modelData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];

    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO t_model(modelData, modelId) VALUES ('%@', '%@');", dataStr, model.modelId];
    return [_fmdb executeUpdate:insertSql];
}

/** 查询数据 modelId为空时获取所有*/
+ (NSArray *)queryDataWithId:(NSString *)modelId
{
    NSString *querySql;
    if (modelId) {
        querySql = [NSString stringWithFormat:@"SELECT * FROM t_model WHERE modelId LIKE '%@'", modelId];
    }else{
        querySql = @"SELECT * FROM t_model";
    }


    NSMutableArray *arrM = [NSMutableArray array];
    FMResultSet *set = [_fmdb executeQuery:querySql];

    while ([set next]) {

        NSString *dataStr = [set stringForColumn:@"modelData"];
        //把string转data
        NSData *modelData = [[NSData alloc]initWithBase64EncodedString:dataStr options:NSDataBase64DecodingIgnoreUnknownCharacters];

        HYModel *model = [fmdbTool decodeModelData:modelData];
        [arrM addObject:model];
        
        



    }
    return arrM;
}

/** 删除数据 */
+ (BOOL)deleteDataWithId:(NSString *)modelId
{
     NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM t_model WHERE modelId = '%@'",modelId];
    return [_fmdb executeUpdate:deleteSql];
}

/** 修改数据 */
+ (BOOL)modifyDataWithId:(NSString *)modelId andModel:(HYModel *)model
{
    NSData *modelData = [fmdbTool encodeModel:model];
    //把data转string
    NSString *dataStr = [modelData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSString *modifySql = [NSString stringWithFormat:@"UPDATE t_model SET modelData = '%@' WHERE modelId = '%@'",dataStr,modelId];
    return [_fmdb executeUpdate:modifySql];
}
@end
