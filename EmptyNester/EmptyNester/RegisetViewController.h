//
//  RegisetViewController.h
//  EmptyNester
//
//  Created by liman on 16/5/19.
//  Copyright © 2016年 曹少帅. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisetViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *email;/**<邮箱*/
@property (weak, nonatomic) IBOutlet UIButton *registe;
@property (weak, nonatomic) IBOutlet UIButton *bake;
- (IBAction)regiset:(UIButton *)sender;/**<注册事件*/
- (IBAction)back:(UIButton *)sender;/**<取消事件*/

@end
