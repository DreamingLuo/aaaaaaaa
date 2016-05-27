//
//  WJYViewController.h
//  EmptyNester
//
//  Created by shao on 16/5/13.
//  Copyright © 2016年 曹少帅. All rights reserved.
//

#import <UIKit/UIKit.h>
#define APIKEY @"3a2c4597b662f33f4c8057d4806b9598"
@protocol PassValueViewDelegate;

@protocol PassValueViewDelegate <NSObject>

-(void)setValue:(NSString*)message;
@end
@interface WJYViewController : UIViewController
@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,weak)id<PassValueViewDelegate>delegate;
@end
