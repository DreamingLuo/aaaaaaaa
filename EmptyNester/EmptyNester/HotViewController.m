//
//  HotViewController.m
//  EmptyNester
//
//  Created by shao on 16/5/13.
//  Copyright © 2016年 曹少帅. All rights reserved.
//

#import "HotViewController.h"

static const int  K_NNGOV_WEBSITE_LABEL_URL;
static const int  K_NNWEIBO_LABEL_URL;

@interface HotViewController ()

@end

@implementation HotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.044 green:0.391 blue:0.379 alpha:1.000];
    self.navigationItem.title = @"热能";
    UILabel* label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 370, 600)];
    [label1 setText:@"       随着年龄的不断增长，老年人的活动量逐渐减少，能量消耗降低，机体内脂肪组织增加，而肌肉组织和脏器功能减退，机体代谢过程明显减慢，基础代谢一般要比青壮年时期降低约10～15%，75岁以上老人可降低20%以上。因此，老年人每天应适当控制热量摄入。老年人热能供给量是否合适，可通过观察体重变化来衡量。一般可用下列公式粗略计算：男性老人体重标准值(公斤)=[身高(厘米)-100]×0.9          女性老人体重标准值(公斤)=[身高(厘米)-105]×0.92         实测体重在上述标准值±5%以内属正常体重，超过10%为超重，超过20%为肥胖，低于10%为减重，低于20%为消瘦，在±5%～±10%范围内为偏高或偏低。流行病学调查资料表明，体重超常或减重、消瘦的老年人各种疾病的发病率明显高于体重正常者。因此老年人应设法调整热量摄入，控制体重在标准范围内，以减少疾病发生。"];
    label1.numberOfLines = 100;
    [label1 setTextColor:[UIColor colorWithRed:0.872 green:0.825 blue:0.666 alpha:1.000]];
    
    [self.view addSubview:label1];
    UILabel *labelGovUrl = [[UILabel alloc] initWithFrame:CGRectMake(173.0, 550.0, 180.0, 40.0)];
    labelGovUrl.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    labelGovUrl.text = @"点击链接 >";
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
        url = @"http://weibo.com/u/5210026281?refer_flag=1005055014_&is_hot=1";
    }
    if(tag == K_NNGOV_WEBSITE_LABEL_URL){
        url = @"http://blog.sina.com.cn/s/blog_14f5b89e30102w0mb.html";
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
