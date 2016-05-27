//
//  TLViewController.m
//  EmptyNester
//
//  Created by shao on 16/5/13.
//  Copyright © 2016年 曹少帅. All rights reserved.
//

#import "TLViewController.h"

static const int  K_NNGOV_WEBSITE_LABEL_URL;
static const int  K_NNWEIBO_LABEL_URL;

@interface TLViewController ()

@end

@implementation TLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.044 green:0.391 blue:0.379 alpha:1.000];
    self.navigationItem.title = @"糖类";
    UILabel* label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 370, 600)];
    [label1 setText:@"       实验表明，老年人对糖类（淀粉类食物）的需要量是很严格的：老年人对糖分过多、过少的适应能力减弱。因此，不少老年人都有患轻度糖尿病的趋势。但是，水果和蜂蜜中所含的果糖，既容易消化吸收；又不容易在体内转化成脂肪，是老年人理想的糖源。"];
    label1.numberOfLines = 100;
    [label1 setTextColor:[UIColor colorWithRed:0.872 green:0.825 blue:0.666 alpha:1.000]];
    
    [self.view addSubview:label1];
    
    UILabel *labelGovUrl = [[UILabel alloc] initWithFrame:CGRectMake(173.0, 550.0, 180.0, 40.0)];
    labelGovUrl.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    labelGovUrl.text = @"进入链接 >";
    labelGovUrl.backgroundColor = [UIColor clearColor];
    labelGovUrl.textColor = [UIColor whiteColor];
    labelGovUrl.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    labelGovUrl.userInteractionEnabled = YES;
    labelGovUrl.tag = K_NNGOV_WEBSITE_LABEL_URL;
    
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openURL:)];
    [labelGovUrl addGestureRecognizer:tapGesture];
    [self.view addSubview:labelGovUrl];
}
-(void)openURL:(UITapGestureRecognizer *)gesture{
    NSInteger tag = gesture.view.tag;
    NSString *url = nil;
    if (tag == K_NNWEIBO_LABEL_URL) {
        url = @"http://www.familydoctor.com.cn/mouth/a/201603/956684.html";
    }
    if(tag == K_NNGOV_WEBSITE_LABEL_URL){
        url = @"http://mp.weixin.qq.com/s?__biz=MzAwODAxMTc3OA==&mid=2651184415&idx=3&sn=b85d1b444c4e393eb0905da33b4941df";
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
