//
//  EditNote.m
//  Note
//
//  Created by shao on 16/5/24.
//  Copyright © 2016年 曹少帅. All rights reserved.
//

#import "EditNote.h"
#import "MemorandumModel.h"
#import "CSModelTool.h"

#define kWindowWidth ([UIScreen mainScreen].bounds.size.width)
#define kWindowHeight ([UIScreen mainScreen].bounds.size.height)

@interface EditNote () <UITextViewDelegate>
{
    UITextView *noteTextView;
    NSInteger NoteIdentifier;
    UIBarButtonItem *completeBtn;
}

@end

@implementation EditNote

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    completeBtn=[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(CompleteClick)];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:1.000 green:1.000 blue:0.791 alpha:1.000];
    [self setNoteTextView];
    [self showNote];
}
- (NSString *)getTodayDate
{
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY/MM/dd HH:mm:ss";
    NSString *nowStr = [dateFormatter stringFromDate:now];
    return nowStr;
}

- (void)setNoteTextView
{
    noteTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight)];
    noteTextView.tintColor = [UIColor colorWithRed:1.000 green:1.000 blue:0.791 alpha:1.000];
    noteTextView.textColor = [UIColor colorWithRed:1.000 green:1.000 blue:0.791 alpha:1.000];
    noteTextView.delegate = self;
    [noteTextView setFont:[UIFont systemFontOfSize:15]];
    [self.view addSubview:noteTextView];
}

// 填充内容
- (void)showNote
{
    noteTextView.text = self.model.NoteContent;
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.navigationItem.rightBarButtonItem=completeBtn;
}


// 完成
- (void)CompleteClick
{
    MemorandumModel *modifyModel = self.model;
    modifyModel.NoteContent = noteTextView.text;
    modifyModel.NoteTime = [self getTodayDate];
    [CSModelTool modifyData:modifyModel];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
