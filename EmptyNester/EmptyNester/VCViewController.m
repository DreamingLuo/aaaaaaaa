//
//  VCViewController.m
//  EmptyNester
//
//  Created by shao on 16/5/13.
//  Copyright © 2016年 曹少帅. All rights reserved.
//

#import "VCViewController.h"

static const int  K_NNGOV_WEBSITE_LABEL_URL;
static const int  K_NNWEIBO_LABEL_URL;

@interface VCViewController ()

@end

@implementation VCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.044 green:0.391 blue:0.379 alpha:1.000];
    self.navigationItem.title = @"维生素";
    UILabel* label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 370, 600)];
    [label1 setText:@"       　老年人对各种维生素的需要量有所减少。但是，由于吸收不良或排泄增加等原因，老年人往往有维生素缺乏的现象。老年人应该注意摄取的维生素有A、Bl、B2、C、E。这些维生素主要存在于绿色或黄色蔬菜；各种水果、粗粮及植物油中。"];
    label1.numberOfLines = 100;
    [label1 setTextColor:[UIColor colorWithRed:0.872 green:0.825 blue:0.666 alpha:1.000]];
    
    [self.view addSubview:label1];

    UILabel *labelGovUrl = [[UILabel alloc] initWithFrame:CGRectMake(173.0, 550.0, 180.0, 40.0)];
    labelGovUrl.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    labelGovUrl.text = @"维生素 >";
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
        url = @"http://weibo.com/p/1001603978258730336217";
    }
    if(tag == K_NNGOV_WEBSITE_LABEL_URL){
        url = @"http://weibo.com/ttarticle/p/show?id=2309403977694797788747";
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
