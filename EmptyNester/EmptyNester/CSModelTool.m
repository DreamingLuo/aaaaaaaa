//
//  CSModelTool.m
//  Note
//
//  Created by shao on 16/5/24.
//  Copyright © 2016年 曹少帅. All rights reserved.
//

#import "CSModelTool.h"
#import "MemorandumModel.h"

#define BQLSQLITE_NAME @"modals.sqlite"
@implementation CSModelTool

static FMDatabase* _fmdb;
+(void)initialize
{
    // 执行打开数据库和创建表操作
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:BQLSQLITE_NAME];
    _fmdb = [FMDatabase databaseWithPath:filePath];
    
    [_fmdb open];
    
#warning 必须先打开数据库才能创建表。。。否则提示数据库没有打开
    [_fmdb executeUpdate:@"CREATE TABLE IF NOT EXISTS t_modals(id INTEGER PRIMARY KEY, NoteID INTEGER NOT NULL, NoteContent TEXT NOT NULL, NoteTime TEXT NOT NULL);"];
}
+(BOOL)insertModel:(MemorandumModel *)model
{
    return [_fmdb executeUpdate:@"INSERT INTO t_modals(NoteID, NoteContent, NoteTime) VALUES (?,?,?)",[NSString stringWithFormat:@"%ld",model.NoteID],[NSString stringWithFormat:@"%@",model.NoteContent],[NSString stringWithFormat:@"%@",model.NoteTime]];
}
+(NSArray*)queryData:(NSString *)querySql
{
    if (querySql == nil)
    {
        querySql = @"select* from t_modals";
    }
    NSMutableArray* arrM = [NSMutableArray array];
    FMResultSet* set = [_fmdb executeQuery:querySql];
    
    while ([set next])
    {
        NSString *NoteID = [set stringForColumn:@"NoteID"];
        NSString *NoteContent = [set stringForColumn:@"NoteContent"];
        NSString *NoteTime = [set stringForColumn:@"NoteTime"];
        
        MemorandumModel* model = [MemorandumModel modelWith:NoteID.intValue content:NoteContent time:NoteTime];
        [arrM addObject:model];
    }
    return arrM;
}
+(BOOL)deleteData:(MemorandumModel *)deleteModel
{
    return [_fmdb executeUpdate:@"DELETE FROM t_modals WHERE NoteID = ?",[NSString stringWithFormat:@"%ld",deleteModel.NoteID]];
    /*
     if (deleteSql == nil) {
     deleteSql = @"DELETE FROM t_modals";
     }
     return [_fmdb executeUpdate:deleteSql];
     */
}
+ (BOOL)modifyData:(MemorandumModel *)modifyModel {
    
    return [_fmdb executeUpdate:@"UPDATE t_modals SET NoteContent = ? , NoteTime = ? WHERE NoteID = ?",[NSString stringWithFormat:@"%@",modifyModel.NoteContent],[NSString stringWithFormat:@"%@",modifyModel.NoteTime],[NSString stringWithFormat:@"%ld",modifyModel.NoteID]];
    
}


@end
