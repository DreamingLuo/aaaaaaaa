//
//  PopViewController.h
//  EmptyNester
//
//  Created by shao on 16/5/27.
//  Copyright © 2016年 曹少帅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWViewController.h"
@protocol PassValueDelegate;
@interface PopViewController : UIViewController<PassValueDelegate>
@property (strong, nonatomic)UIWebView *webView;
@end
