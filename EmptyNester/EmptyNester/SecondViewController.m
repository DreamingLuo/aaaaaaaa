//
//  SecondViewController.m
//  EmptyNester
//
//  Created by shao on 16/5/27.
//  Copyright © 2016年 曹少帅. All rights reserved.
//

#import "SecondViewController.h"
#import <CoreData/CoreData.h>
@interface SecondViewController ()
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
- (IBAction)saveBtn:(UIButton *)sender;
- (IBAction)changeBtn:(UIButton *)sender;
- (IBAction)delBtn:(UIButton *)sender;


@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickEnd)];
    [self.view addGestureRecognizer:tap];
    
    [self loadUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) loadUI
{
    if (_type == ADD) {
        _changeBtn.hidden = YES;
        _delBtn.hidden = YES;
    }
    if (_type == CHANGE) {
        _saveBtn.hidden = YES;
        
        _tfName.text = _user.name;
        _tfSex.text = _user.sex;
        _tfAge.text = [NSString stringWithFormat:@"%d", _user.age.intValue];
        _tfAddress.text = _user.address;
        _tfLove.text = _user.love;
        _tfTelephone.text = [NSString stringWithFormat:@"%d", _user.telephone.intValue];
    }
}
- (void) clickEnd
{
    [self.view endEditing:YES];
}
- (IBAction)saveBtn:(UIButton *)sender
{
    if ([_tfName.text  isEqual: @""] || [_tfSex.text  isEqual: @""] || [_tfAge.text  isEqual: @""] ||[_tfAddress.text  isEqual: @""] || [_tfLove.text  isEqual: @""] || [_tfTelephone.text  isEqual: @""]) {
        [self showAlert];
        return;
    }
    
    _user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[CoreDataManager sharedCoreDataManager].managedObjContext];
    [_user setName:self.tfName.text];
    [_user setSex:self.tfSex.text];
    [_user setAge:@([self.tfAge.text integerValue])];
    [_user setAddress:self.tfAddress.text];
    [_user setLove:self.tfLove.text];
    [_user setTelephone:@([self.tfTelephone.text integerValue])];
    NSError *error = nil;
    
    //    托管对象准备好后，调用托管对象上下文的save方法将数据写入数据库
    BOOL isSaveSuccess = [[CoreDataManager sharedCoreDataManager].managedObjContext save:&error];
    if (!isSaveSuccess) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }else
    {
        NSLog(@"Save successFull");
    }
    

}

- (IBAction)delBtn:(UIButton *)sender
{
    
    [[CoreDataManager sharedCoreDataManager].managedObjContext deleteObject:_user];
    
    NSError *error = nil;
    
    //    托管对象准备好后，调用托管对象上下文的save方法将数据写入数据库
    BOOL isSaveSuccess = [[CoreDataManager sharedCoreDataManager].managedObjContext save:&error];
    if (!isSaveSuccess) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }else
    {
        NSLog(@"del successFull");
        
        _tfName.text = @"";
        _tfSex.text = @"";
        _tfAge.text = @"";
        _tfAddress.text = @"";
        _tfLove.text = @"";
        _tfTelephone.text = @"";
    }

}

- (IBAction)changeBtn:(UIButton *)sender
{
    if ([_tfName.text  isEqual: @""] || [_tfSex.text  isEqual: @""] || [_tfAge.text  isEqual: @""] ||[_tfAddress.text  isEqual: @""] || [_tfLove.text  isEqual: @""] || [_tfTelephone.text  isEqual: @""]) {
        [self showAlert];
        return;
    }
    //    对同一个实体做数据改变
    [_user setName:self.tfName.text];
    [_user setSex:self.tfSex.text];
    [_user setAge:@([self.tfAge.text integerValue])];
    [_user setAddress:self.tfAddress.text];
    [_user setLove:self.tfLove.text];
    [_user setTelephone:@([self.tfTelephone.text integerValue])];
    
    NSError *error = nil;
    
    //    托管对象准备好后，调用托管对象上下文的save方法将数据写入数据库
    BOOL isSaveSuccess = [[CoreDataManager sharedCoreDataManager].managedObjContext save:&error];
    if (!isSaveSuccess) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }else
    {
        NSLog(@"Change successFull");
    }
}
- (void) showAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请填满" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

@end
