//
//  BaseTabBarController.m
//  EmptyNester
//
//  Created by shao on 16/5/12.
//  Copyright © 2016年 曹少帅. All rights reserved.
//

#import "BaseTabBarController.h"
#import "BaseNavigationViewController.h"

#define RGB(r, g, b)    [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

#define WIDTH [UIScreen mainScreen].bounds.size.width

#define HEIGHT [UIScreen mainScreen].bounds.size.height

#define TABBAR 49
@interface BaseTabBarController ()
{
    UIImageView *_selectImage;
}
@end

@implementation BaseTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _createViewController];
    
    [self _createTabBarButton];
    
}
#pragma mark - 创建视图
-(void)_createViewController
{
    NSArray* array = @[@"Home",@"Person",@"Life",@"Play",@"Health"];
    NSMutableArray* arr = [NSMutableArray arrayWithCapacity:array.count];
    for (int i = 0; i < array.count; i++)
    {
        NSString* str = array[i];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:str bundle:nil];
        UINavigationController* view = [storyboard instantiateInitialViewController];
        [arr addObject:view];
        self.viewControllers = arr;
    }
    
}
#pragma mark - 创建标签栏按钮
-(void)_createTabBarButton
{
    NSArray* normalName = @[@"icon1_c_footer@3x.png",@"icon2_c_footer.png",@"tabbar-discover",@"icon3_c_footer@3x.png",@"tabbar-me"];
    NSArray *selectedName = @[@"icon1_s_footer",@"icon2_s_footer",@"tabbar-discover-selected",@"icon3_s_footer@3x.png",@"tabbar-me-selected"];
    NSArray *tabBarName = @[@"首页",@"图书",@"发现",@"提醒",@"我的"];
    for(UIView* view in self.tabBar.subviews)
    {
        [view removeFromSuperview];
    }
    UIImageView* tabView = [[UIImageView alloc]initWithFrame:self.tabBar.bounds];
    tabView.backgroundColor =RGB(247, 247, 247);
    tabView.userInteractionEnabled = YES;
    tabView.alpha = 0.9;
    [self.tabBar addSubview:tabView];
    
    CGFloat butWidth = WIDTH/normalName.count;
    for (int i = 0; i < normalName.count; i++)
    {
        UIButton* but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(butWidth * i, 0, butWidth, TABBAR);
        but.tag = 100 + i;
        [but setImage:[UIImage imageNamed:normalName[i]] forState:UIControlStateNormal];
        [but setImage:[UIImage imageNamed:selectedName[i]] forState:UIControlStateSelected];
        CGFloat left = (butWidth - 35)/2;
        
        [but setImageEdgeInsets:UIEdgeInsetsMake(4, left, TABBAR - 2 - 25, left)];
        UILabel * tabLabel = [[UILabel alloc]initWithFrame:CGRectMake(butWidth * i + left + 4.0, TABBAR - 25, butWidth - left - 10, 23)];
        tabLabel.tag = 200 + i;
        tabLabel.text = tabBarName[i];
        tabLabel.font = [UIFont systemFontOfSize:11];
        tabLabel.textColor = [UIColor lightGrayColor];
        tabLabel.textAlignment = NSTextAlignmentLeft;
        [self.tabBar addSubview:tabLabel];
        
        [but addTarget:self action:@selector(butAction:) forControlEvents:UIControlEventTouchUpInside];
        if (but.tag == 100)
        {
            but.selected = YES;
            [but setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            tabLabel.textColor = [UIColor redColor];
        }
        [self.tabBar addSubview:but];
    }
    
}


#pragma mark - 选中按钮响应事件
-(void)butAction:(UIButton *)sender
{
    self.selectedIndex = sender.tag - 100;
    
    sender.selected = !sender.selected;
    
    for (int i = 100;  i < 103; i ++)
    {
        UIButton *button = (UIButton *)[self.tabBar viewWithTag:i];
        button.selected = NO;
        if (button.selected == NO)
        {
            UILabel *label = (UILabel *)[self.tabBar viewWithTag:100 + button.tag];
            label.textColor = [UIColor lightGrayColor];
        }
    }
    sender.selected = YES;
    if (sender.selected == YES)
    {
        UILabel *label = (UILabel *)[self.tabBar viewWithTag:sender.tag + 100];
        label.textColor = [UIColor redColor];
    }
}
@end
