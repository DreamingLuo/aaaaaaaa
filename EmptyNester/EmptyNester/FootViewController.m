//
//  FootViewController.m
//  EmptyNester
//
//  Created by shao on 16/5/15.
//  Copyright © 2016年 曹少帅. All rights reserved.
//

#import "FootViewController.h"
#import "Masonry.h"
#import "stepView.h"
#import <CoreMotion/CoreMotion.h>
@interface FootViewController ()<UIScrollViewDelegate>
{
    stepView* view1;
    UIButton* btn2;
    // 计步器实例化对象
    CMPedometer *stepCounter;
    // 计步器走的步数；
    int i;
    int v;
    UIScrollView  *indicators;
    NSMutableArray *arry1;
    NSString *rday;
    float k;
    UILabel *footlaber;
}
@end

@implementation FootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    indicators =  [[UIScrollView alloc] init];
    indicators.delegate = self;
    [self.view addSubview:indicators];
    
    [indicators mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.width.equalTo(@([UIScreen mainScreen].bounds.size.width));
        make.height.equalTo(@([UIScreen mainScreen].bounds.size.height));
    }];
    indicators.contentSize=CGSizeMake([UIScreen mainScreen].bounds.size.width, 1000);
    view1  =[[stepView alloc]initWithFrame:CGRectMake(0,0, APPW-10*2,APPW-30)];
    view1.backgroundColor = [UIColor whiteColor];
    view1.num = v;
    [indicators addSubview:view1];
    
    UIImageView *footview = [[UIImageView alloc] init];
    footview.image = [UIImage imageNamed:@"102-walk.png"];
    [indicators addSubview:footview];
    [footview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(indicators.mas_top).offset(APPW-30);
        make.centerX.equalTo(indicators.mas_centerX).offset(0);
        make.width.equalTo(@(30));
        make.height.equalTo(@(30));
    }];
    
    
    btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.backgroundColor = [[UIColor alloc]initWithRed:255.0/255.0 green:153.0/255.0 blue:18.0/255.0 alpha:1];
    btn2.layer.cornerRadius=15;
    btn2.layer.masksToBounds=YES;
    btn2.selected = YES;
    [btn2 setTitle:@"开始" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(click1) forControlEvents:UIControlEventTouchUpInside];
    [indicators  addSubview:btn2];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(indicators.mas_top).offset(APPW+30);
        make.left.equalTo(indicators.mas_left).offset(20);
        make.width.equalTo(@(130));
        make.height.equalTo(@(50));
    }];
    
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.backgroundColor = [[UIColor alloc]initWithRed:0.0/255.0 green:201.0/255.0 blue:87.0/255.0 alpha:1];
    btn3.layer.cornerRadius=15;
    btn3.layer.masksToBounds=YES;
    [btn3 setTitle:@"停止" forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(click2) forControlEvents:UIControlEventTouchUpInside];
    [indicators  addSubview:btn3];
    [btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(indicators.mas_top).offset(APPW+30);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.width.equalTo(@(130));
        make.height.equalTo(@(50));
    }];
    
    
    UILabel *hot = [[UILabel alloc] init];
    hot.text =@"最近一周热量消耗";
    hot.font = [UIFont systemFontOfSize:12];
    [indicators addSubview:hot];
    [hot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(indicators.mas_top).offset(APPW+90);
        make.left.equalTo(indicators.mas_left).offset(30);
        make.width.equalTo(@(120));
        make.height.equalTo(@(30));
    }];
    
    UILabel *unit = [[UILabel alloc] init];
    unit.text =@"单位 ： 卡 (Kal)";
    unit.font = [UIFont systemFontOfSize:12];
    [indicators addSubview:unit];
    [unit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(indicators.mas_top).offset(APPW+90);
        make.right.equalTo(self.view.mas_right).offset(-30);
        make.width.equalTo(@(120));
        make.height.equalTo(@(30));
    }];
    
    
    
    
}
-(void)click1{
    
    if (btn2.selected == YES) {
        
        
        if (![CMPedometer isStepCountingAvailable]) return;
        
        // 2.创建计步器对象
        stepCounter   = [[CMPedometer alloc] init];
        
        // 3.开始计步(走多少步之后调用一次该方法)
        
        [stepCounter startPedometerUpdatesFromDate:[NSDate date] withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
            NSString *str1 = [NSString stringWithFormat:@"%ld",(long)pedometerData.numberOfSteps];
            i = [str1 intValue];
            v = i+v;
            view1.num = v;
           // NSLog(@"%d",v);
           
        }];
        
    }
    btn2.selected =NO;
    
    
    
}
-(void)click2{
    
    k  = v*0.05/1000;
    footlaber.text = [NSString stringWithFormat:@"您走了%.2f公里",k];
    
    [stepCounter stopPedometerUpdates];
    
    btn2.selected = YES;
    
}

    


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
