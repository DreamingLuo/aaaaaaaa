//
//  NoteCell.m
//  EmptyNester
//
//  Created by shao on 16/5/27.
//  Copyright © 2016年 曹少帅. All rights reserved.
//

#import "NoteCell.h"
#import "UIViewExt.h"
#import "MemorandumModel.h"
#define kWidthRatio kScreenWidth/iphone6_ScreenWidth
#define kHeightRatio kScreenHeight/iphone6_ScreenHeight
#define RGB(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define kWindowWidth ([UIScreen mainScreen].bounds.size.width)
#define kWindowHeight ([UIScreen mainScreen].bounds.size.height)
#define iphone6_ScreenWidth 375.0
#define iphone6_ScreenHeight 667.0
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
@interface NoteCell ()
{
    UILabel *title; // 标题
    UILabel *time; // 时间
    UILabel *attach; // 附加信息
    UIView *line;
}
@end
@implementation NoteCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        title = [[UILabel alloc] initWithFrame:CGRectZero];
        title.font = [UIFont fontWithName:@"Helvetica" size:15];
        //title.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:title];
        
        time = [[UILabel alloc] initWithFrame:CGRectZero];
        time.font = [UIFont systemFontOfSize:13];
        time.textColor = RGB(102, 102, 102);
        [self.contentView addSubview:time];
        
        attach = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:attach];
        
        line = [[UIView alloc] initWithFrame:CGRectZero];
        line.backgroundColor = RGB(199.0,199.0,199.0);
        [self.contentView addSubview:line];
        
        [self setSubViews];
        [self enumerateFonts];
    }
    return self;
}

- (void)enumerateFonts{
    for(NSString *familyName in [UIFont familyNames]){
        NSLog(@"Font FamilyName = %@",familyName); //*输出字体族科名字
        
    }
}

- (void)setSubViews
{
    title.frame = CGRectMake(10 * kWidthRatio, 10 * kHeightRatio, kWindowWidth - 30 * kWidthRatio, 17);
    time.frame = CGRectMake(10 * kWidthRatio, title.bottom + 5 * kHeightRatio, 100 * kWidthRatio, 17);
    attach.frame = CGRectMake(time.right + 10 * kWidthRatio, time.top, kWindowWidth - time.right - 10 * kWidthRatio, 17);
    line.frame = CGRectMake(10 * kWidthRatio, time.bottom + 10 * kHeightRatio, kWindowWidth - 10 * kWidthRatio, 0.5);
    
}

- (NSString *)getTodayDate
{
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY/MM/dd";
    NSString *nowStr = [dateFormatter stringFromDate:now];
    return nowStr;
}

- (void)setNoteData:(MemorandumModel *)model
{
    NSString *timeStr = [model.NoteTime substringToIndex:10];
    if(![timeStr isEqualToString:[self getTodayDate]]){ // 昨天及之前的日期
        time.text = timeStr;
    }
    else{ // 今日编辑
        NSString *todayTime = [model.NoteTime substringWithRange:NSMakeRange(11, 5)];
        time.text = todayTime;
    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:time.text];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Courier-Oblique" size:16.0] range:NSMakeRange(0, time.text.length)];
    time.attributedText = str;
    
    title.text = model.NoteContent;
    
    
    /*
     NSMutableArray *stringArr = [self stringContains:model.NoteContent];
     NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:model.NoteContent];
     for(NSInteger i = 0; i < stringArr.count; i ++){
     
     NSNumber *startNum = [stringArr[i] firstObject];
     NSInteger start = [startNum integerValue];
     NSNumber *endNum = [stringArr[i] lastObject];
     NSInteger end = [endNum integerValue];
     NSRange rang = NSMakeRange(start, end);
     [str1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"AppleGothic" size:15.0] range:rang];
     
     }
     title.attributedText = str1;
     */
}

- (NSMutableArray *)stringContains:(NSString *)string
{
    __block BOOL returnValue = NO;
    __block NSMutableArray *rangArr = [NSMutableArray arrayWithCapacity:1];
    __block NSInteger index = -1;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
     {
         index += 1;
         const unichar hs = [substring characterAtIndex:0];
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
                 else{
                     NSArray *tempArr = @[@(index),@1];
                     [rangArr addObject:tempArr];
                 }
             }
         }
         else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             else{
                 NSArray *tempArr = @[@(index),@1];
                 [rangArr addObject:tempArr];
             }
         }
         else {
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             }
             else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             }
             else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             }
             else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             }
             else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
             else{
                 NSArray *tempArr = @[@(index),@1];
                 [rangArr addObject:tempArr];
             }
         }
     }];
    
    return rangArr;
}







/**
 *	@brief	是否含有Emoji表情
 */
- (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
     {
         const unichar hs = [substring characterAtIndex:0];
         if([substring isEqualToString:@"哥"])
             substring = @"屎";
         
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
         } else {
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    return returnValue;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
