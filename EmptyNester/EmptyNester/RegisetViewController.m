//
//  RegisetViewController.m
//  EmptyNester
//
//  Created by liman on 16/5/19.
//  Copyright © 2016年 曹少帅. All rights reserved.
//

#import "RegisetViewController.h"
#import <BmobSDK/Bmob.h>
#import <RESideMenu.h>
@interface RegisetViewController ()

@end

@implementation RegisetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=@"注册";
    
    UIBarButtonItem* leftButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"tabbar-me"] style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController:)];
    self.navigationItem.leftBarButtonItem=leftButton;
    _registe.backgroundColor=[UIColor greenColor];
    _bake.backgroundColor=[UIColor grayColor];
}

#pragma mark -- 提交注册
- (IBAction)regiset:(UIButton *)sender
{
    //挂起
    [_username resignFirstResponder];
    [_password resignFirstResponder];
    if ([_username.text isEqual:@""]||[_password.text isEqual:@""]||[_email.text isEqual:@""])
    {
        UIAlertController* alert1=[UIAlertController alertControllerWithTitle:@"提示" message:@"用户名或密码或邮箱不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* sure1=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
        //UIAlertAction* cancel1=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
        
        [alert1 addAction:sure1];
        //[alert1 addAction:cancel1];
        [self presentViewController:alert1 animated:YES completion:^{}];
    }else
    {
        //邮箱验证
        BmobUser* bUser=[[BmobUser alloc]init];
        bUser.username=_username.text;
        bUser.email=_email.text;
        [bUser setPassword:_password.text];
        [bUser signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error)
         {
             if (!error)
             {
                 NSLog(@"注册成功");

                 
             }else
             {
                 NSLog(@"注册失败，可能已有该用户:%@",error);
             }
         }];
        
    }
}

- (IBAction)back:(UIButton *)sender
{
    _username.text=nil;
    _password.text=nil;
    _email.text=nil;
}
@end
