//
//  LoginViewController.h
//  EmptyNester
//
//  Created by liman on 16/5/19.
//  Copyright © 2016年 曹少帅. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AuthcodeView;
@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *authcode;
- (IBAction)Login:(UIButton *)sender;
- (IBAction)Cancel:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet AuthcodeView *authcodeView;/**<验证码*/

@end
