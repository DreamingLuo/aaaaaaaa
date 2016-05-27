//
//  MemorandumModel.h
//  Note
//
//  Created by shao on 16/5/24.
//  Copyright © 2016年 曹少帅. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemorandumModel : NSObject

@property(nonatomic,assign)NSInteger NoteID;// 备忘录编号
@property(nonatomic,copy)NSString* NoteContent;
@property(nonatomic,copy)NSString* NoteTime;

+(instancetype)modelWith:(NSInteger)NoteID content:(NSString*)NoteContent time:(NSString*)NoteTime;
@end
