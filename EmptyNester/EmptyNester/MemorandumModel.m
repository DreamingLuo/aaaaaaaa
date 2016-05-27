//
//  MemorandumModel.m
//  Note
//
//  Created by shao on 16/5/24.
//  Copyright © 2016年 曹少帅. All rights reserved.
//

#import "MemorandumModel.h"

@implementation MemorandumModel
+(instancetype)modelWith:(NSInteger)NoteID content:(NSString*)NoteContent time:(NSString*)NoteTime
{
    MemorandumModel* model = [[MemorandumModel alloc]init];
    model.NoteID = NoteID;
    model.NoteContent = NoteContent;
    model.NoteTime = NoteTime;
    return model;
}
@end
