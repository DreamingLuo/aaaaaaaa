//
//  QueViewController.m
//  EmptyNester
//
//  Created by shao on 16/5/27.
//  Copyright © 2016年 曹少帅. All rights reserved.
//

#import "QueViewController.h"
#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height
@interface QueViewController ()
{
    NSString* contentsStr;
}
@end


@implementation QueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"内容详情";
    
    _webView= [[UIWebView alloc]initWithFrame:CGRectMake(0, 10, screen_width, screen_height)];
    [self.webView loadHTMLString:contentsStr baseURL:nil];
    [self.view addSubview:_webView];
}
-(void)setValue:(NSString *)message
{
    contentsStr = message;
}
-(void)viewWillDisappear:(BOOL)animated
{
    contentsStr = nil;
}


@end
