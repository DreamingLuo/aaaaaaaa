//
//  AddNote.m
//  Note
//
//  Created by shao on 16/5/24.
//  Copyright © 2016年 曹少帅. All rights reserved.
//

#import "AddNote.h"
#import "MemorandumModel.h"
#import "CSModelTool.h"

#define LVSQLITE_NAME @"modals.sqlite"
#define kWindowWidth ([UIScreen mainScreen].bounds.size.width)
#define kWindowHeight ([UIScreen mainScreen].bounds.size.height)
#define RGB(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define shitYellow RGB(253, 178, 50)

@interface AddNote ()
{
    UITextView *noteTextView;
    NSInteger NoteIdentifier;
}
@end

@implementation AddNote

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *completeBtn=[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(CompleteClick)];
    self.navigationController.navigationBar.tintColor = shitYellow;
    self.navigationItem.rightBarButtonItem=completeBtn;
    
    [self setNoteTextView];
}
- (void)setNoteTextView
{
    noteTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kWindowWidth, kWindowHeight)];
    noteTextView.tintColor = shitYellow;
    noteTextView.textColor = shitYellow;
    [noteTextView setFont:[UIFont systemFontOfSize:15]];
    [self.view addSubview:noteTextView];
    
    NSNumber *defaultID = [[NSUserDefaults standardUserDefaults]objectForKey:@"NoteIdentifier"];
    NoteIdentifier = [defaultID integerValue] + 1;
}
- (NSString *)getTodayDate
{
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY/MM/dd HH:mm:ss";
    NSString *nowStr = [dateFormatter stringFromDate:now];
    return nowStr;
}

// 完成
- (void)CompleteClick
{
    if(noteTextView.text.length > 0){
        MemorandumModel *model = [MemorandumModel modelWith:NoteIdentifier content:noteTextView.text time:[self getTodayDate]];
        BOOL isInsert = [CSModelTool insertModel:model];
        
        if (isInsert) {
            NSLog(@"插入数据成功");
            NSNumber *newNoteIdentifier = [NSNumber numberWithInteger:NoteIdentifier];
            [[NSUserDefaults standardUserDefaults] setValue:newNoteIdentifier forKey:@"NoteIdentifier"];
            
        } else {
            NSLog(@"插入数据失败");
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告" message:@"您还没有输入任何信息!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消了...");
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"确定了...");
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
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
