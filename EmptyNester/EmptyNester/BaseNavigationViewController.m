//
//  BaseNavigationViewController.m
//  EmptyNester
//
//  Created by shao on 16/5/12.
//  Copyright © 2016年 曹少帅. All rights reserved.
//

#import "BaseNavigationViewController.h"

@interface BaseNavigationViewController ()

@end

@implementation BaseNavigationViewController
- (UIStatusBarStyle)preferredStatusBarStyle
{
    //改变 状态栏的颜色为白色
    //return UIStatusBarStyleLightContent;
    //改变状态栏的颜色为黑色
    return UIStatusBarStyleDefault;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏字体颜色为白色
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];//设置左右item颜色为白色
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
