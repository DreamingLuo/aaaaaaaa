//
//  NoteCell.h
//  EmptyNester
//
//  Created by shao on 16/5/27.
//  Copyright © 2016年 曹少帅. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MemorandumModel;
@interface NoteCell : UITableViewCell
- (void)setNoteData:(MemorandumModel *)model;
@end
