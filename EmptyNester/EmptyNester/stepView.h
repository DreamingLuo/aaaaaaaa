//
//  stepView.h
//  EmptyNester
//
//  Created by shao on 16/5/15.
//  Copyright © 2016年 曹少帅. All rights reserved.
//

#import <UIKit/UIKit.h>

#define APPW [[UIScreen mainScreen] bounds].size.width

#define APPH [[UIScreen mainScreen] bounds].size.height
@interface stepView : UIView

@property(nonatomic,assign)int num;

@property(nonatomic,strong)UILabel *numLabel;

@property(nonatomic,strong)NSTimer *timer;

@end
