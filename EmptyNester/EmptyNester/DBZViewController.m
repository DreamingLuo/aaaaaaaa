//
//  DBZViewController.m
//  EmptyNester
//
//  Created by shao on 16/5/13.
//  Copyright © 2016年 曹少帅. All rights reserved.
//

#import "DBZViewController.h"

static const int  K_NNGOV_WEBSITE_LABEL_URL;
static const int  K_NNWEIBO_LABEL_URL;

@interface DBZViewController ()

@end

@implementation DBZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.044 green:0.391 blue:0.379 alpha:1.000];
    self.navigationItem.title = @"蛋白质";
    UILabel* label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 370, 600)];
    [label1 setText:@"       老年人体内的分解代谢增加，合成代谢减少，所以老年人要适当多吃一些富含蛋白质的食品，至少应当和成年期吃得一样多，每天每公斤体重为1克-1.5克；到70岁以后可适当减少。蛋白质代谢后会产生一些有毒物质，老年人的肝、肾功能已经减弱，清除这些毒物的能力较差，如果蛋白质吃得太多，其代谢后的有毒产物不能及时排出，反而会影响身体健康。另外，老年人对蛋白质的利用率下降，维持机体氮平衡所需要的蛋白质数量要高于青壮年时期，而且老年人对蛋氨酸、赖氨酸的需求量也高于青壮年。因此，老年人补充足够蛋白质极为重要，蛋白质对于维持老年人机体正常代谢，补偿组织蛋白消耗，增强机体抵抗力，均具有重要作用。我国规定老年人每日蛋白质供给量一般不低于青壮年时期，依据劳动强度不同，60～69岁老年人，男性每日供给70～80克，女性60～70克;70～79岁老年人，男性65～70克，女性55～60克;"];
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
        url = @"http://weibo.com/u/5210026281?refer_flag=1005055014_&is_hot=1";
    }
    if(tag == K_NNGOV_WEBSITE_LABEL_URL){
        url = @"http://weibo.com/p/23041814f00375a0102wj73";
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
