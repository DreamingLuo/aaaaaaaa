//
//  DetailViewController.h
//  EmptyNester
//
//  Created by liman on 16/5/24.
//  Copyright © 2016年 曹少帅. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetailVCDelegate<NSObject>
@optional
-(void)setValue:(NSString*) message AndImage:(NSString*)image;
@end

@interface DetailViewController : UIViewController<DetailVCDelegate>

@property(nonatomic,strong)UIImageView* image;



@property(nonatomic,strong)UIWebView* webView;

@end
