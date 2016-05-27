//
//  QueViewController.h
//  EmptyNester
//
//  Created by shao on 16/5/27.
//  Copyright © 2016年 曹少帅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WJYViewController.h"
@protocol PassValueViewDelegate;
@interface QueViewController : UIViewController<PassValueViewDelegate>

@property (strong, nonatomic)UIWebView *webView;
@end
