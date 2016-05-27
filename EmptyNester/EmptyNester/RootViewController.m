//
//  RootViewController.m
//  EmptyNester
//
//  Created by liman on 16/5/19.
//  Copyright © 2016年 曹少帅. All rights reserved.
//

#import "RootViewController.h"
#import "HomeViewController.h"
@interface RootViewController ()

@end

@implementation RootViewController
/**
 *  从XIB文件加载成功之后
 */
- (void)awakeFromNib
{
    self.parallaxEnabled = NO;
    self.scaleContentView = YES;
    self.contentViewScaleValue = 0.9;
    self.scaleMenuView = NO;
    self.contentViewShadowEnabled = YES;
    self.contentViewShadowRadius = 4.5;
    
    //加载内容ViewController
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BaseTabBarController"];
    
    //加载左侧的Menu界面
    self.leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LeftMenuViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
