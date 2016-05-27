//
//  LoginViewController.m
//  EmptyNester
//
//  Created by liman on 16/5/19.
//  Copyright © 2016年 曹少帅. All rights reserved.
//

#import "LoginViewController.h"
#import "AuthcodeView.h"
#import <BmobSDK/Bmob.h>
#import <RESideMenu.h>
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=@"登录";
    
    UIBarButtonItem* leftButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"tabbar-me"] style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController:)];
    self.navigationItem.leftBarButtonItem=leftButton;
    
    _userName.placeholder=@"请输入用户名";
    _password.placeholder=@"请输入密码";
    _authcode.placeholder=@"请输入验证码";

}


- (IBAction)Login:(UIButton *)sender
{
    //挂起三个textField
    [_userName resignFirstResponder];
    [_password resignFirstResponder];
    [_authcode resignFirstResponder];
    //判断用户名、密码是否为空
    if ([_userName.text isEqual:@""]||[_password.text isEqual:@""])
    {
        UIAlertController* alert1=[UIAlertController alertControllerWithTitle:@"提示" message:@"用户名或密码不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* sure1=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
        UIAlertAction* cancel1=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
        
        [alert1 addAction:sure1];
        [alert1 addAction:cancel1];
        [self presentViewController:alert1 animated:YES completion:^{}];
    }else
    {
        //验证验证码是否正确
        if (![_authcode.text isEqualToString: _authcodeView.authCodeStr])
        {
            //NSLog(@"%@",authCodeView.authCodeStr);
            UIAlertController* alert2=[UIAlertController alertControllerWithTitle:@"提示" message:@"验证码不正确" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* sure2=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                //[_authcodeView getAuthcode];
                //[_authcodeView setNeedsDisplay];
                _authcode.text=nil;
            }];
            UIAlertAction* cancel2=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
            
            [alert2 addAction:sure2];
            [alert2 addAction:cancel2];
            [self presentViewController:alert2 animated:YES completion:^{}];
            
        }else
        {
            //使用Bmob库
            BmobQuery* query=[BmobUser query];
            [query whereKey:@"username" equalTo:_userName.text];
            [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                if (!error)
                {
                    for (BmobUser* user in array)
                    {
                        if ([user.username isEqual:_userName.text])
                        {
                            NSLog(@"登录成功");
                           [self dismissViewControllerAnimated:YES completion:^{
                               
                           }];
                        }else
                        {
                            //用户不存在
                            UIAlertController* alert3=[UIAlertController alertControllerWithTitle:@"提示" message:@"该用户不存在,请注册" preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction* sure3=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                
                                [self dismissViewControllerAnimated:YES completion:^{
                                    
                                }];
                                
                            }];
                            UIAlertAction* cancel3=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
                            
                            [alert3 addAction:sure3];
                            [alert3 addAction:cancel3];
                            [self presentViewController:alert3 animated:YES completion:^{}];
                        }
                    }
                }else
                {
                    NSLog(@"连接不成功:%@",error);
                }
                
            }];
            
        }
    }
    

}

- (IBAction)Cancel:(UIButton *)sender
{
    
    _password.text=nil;
    _userName.text=nil;
    _authcode.text=nil;
}
@end
