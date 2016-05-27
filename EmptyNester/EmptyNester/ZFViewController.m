//
//  ZFViewController.m
//  EmptyNester
//
//  Created by shao on 16/5/13.
//  Copyright © 2016年 曹少帅. All rights reserved.
//

#import "ZFViewController.h"

static const int  K_NNGOV_WEBSITE_LABEL_URL;
static const int  K_NNWEIBO_LABEL_URL;

@interface ZFViewController ()

@end

@implementation ZFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.044 green:0.391 blue:0.379 alpha:1.000];
    self.navigationItem.title = @"脂肪";
    UILabel* label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 370, 600)];
    [label1 setText:@"       老年人胰脂肪酶分泌减少，对脂肪的消化能力减弱，所以应当少吃一些脂肪，适量吃一点植物油对身体还是有好处的。老年人脂肪摄入量一般以不超过总热能的25%为宜。适量的脂肪供给可改善菜肴风味，促进脂溶性维生素的吸收，供给机体必需脂肪酸，为机体提供热量，是人体不可缺少的营养素。但脂肪摄入过多，尤其是动物性脂肪摄入过多，可引起肥胖、高脂血症、动脉粥样硬化、冠心病等。故老年人脂肪摄入量一般应控制在每日每公斤体重1克以下，除了各种食物中所含脂肪外，食用油的选择应尽量少用动物油脂，而食用豆油、葵花子油、花生油等植物油。"];
    label1.numberOfLines = 100;
    [label1 setTextColor:[UIColor colorWithRed:0.872 green:0.825 blue:0.666 alpha:1.000]];
    
    [self.view addSubview:label1];
    
    UILabel *labelGovUrl = [[UILabel alloc] initWithFrame:CGRectMake(173.0, 550.0, 180.0, 40.0)];
    labelGovUrl.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    labelGovUrl.text = @"相关链接 >";
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
        url = @"http://weibo.com/ttarticle/p/show?id=2309403949604692476132";
    }
    if(tag == K_NNGOV_WEBSITE_LABEL_URL){
        url = @"http://info.food.hc360.com/2016/05/261644962988.shtml";
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
