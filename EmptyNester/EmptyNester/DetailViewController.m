//
//  DetailViewController.m
//  EmptyNester
//
//  Created by liman on 16/5/24.
//  Copyright © 2016年 曹少帅. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+WebCache.h"

#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height
@interface DetailViewController ()
{
    NSString* titleStr;
    NSString* imageStr;
    NSString* text;
}
@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title=@"详细信息";
    _image=[[UIImageView alloc]initWithFrame:CGRectMake(0, 44, screen_width, screen_height/3)];
    
    [_image sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"download01.gif"]];
    
    [self.view addSubview:_image];
    
//    NSString *jsString = [[NSString alloc] initWithFormat:@"document.body.style.fontSize=%f;document.body.style.color=%@",20.0,[UIColor blackColor]];
//    [_webView stringByEvaluatingJavaScriptFromString:jsString];
    //富文本显示(带有html标签的文本)
    _webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 44+_image.frame.size.height, screen_width, (screen_height/3)*2)];
    [self.webView loadHTMLString:titleStr baseURL:nil];
    
    [self.view addSubview:_webView];
    
    
    text=[self filterHTML:titleStr];
    NSLog(@"%@",text);
    
    
}
-(void)setValue:(NSString*) message AndImage:(NSString*)image
{
    titleStr=message;
    imageStr=image;
   // NSLog(@"%@",titleStr);
   
}
-(void)viewWillDisappear:(BOOL)animated
{
    imageStr=nil;
    titleStr=nil;
}
#pragma mark - html文本转换成纯文本
-(NSString *)filterHTML:(NSString *)str
{
    NSScanner * scanner = [NSScanner scannerWithString:str];
    NSString * texts = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&texts];
        //替换字符
        str  =  [str  stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",texts] withString:@""];
    }
    
    return str;
}
@end
