//
//  BookViewController.m
//  EmptyNester
//
//  Created by liman on 16/5/25.
//  Copyright © 2016年 曹少帅. All rights reserved.
//

#import "BookViewController.h"
#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height
#define URLSTRING(r) [NSString stringWithFormat:@"http://tnfs.tngou.net/image%@",r]
#define APIKEY @"eeeabdbf5cc2ed8a6ece0399dbd00564"
#define hTTPURL @"http://apis.baidu.com/tngou/book/show"
#define HTTPARG @"id=1"
@interface BookViewController ()
{
    NSArray* list;/**<接口的数据*/
    
    NSDictionary* dic;
}
@end

@implementation BookViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.navigationItem.title=@"健康图书";
    
    _backImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 44, screen_width, screen_height/4)];
    
    _backImage.image=[UIImage imageNamed:@"bookBackImage.jpg"];
    
    [self.view addSubview:_backImage];
    

    
    [self request:HTTPARG];
    
    
}

#pragma mark - request
-(void)request:(NSString*) arg
{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", hTTPURL, arg];
        NSURL *url = [NSURL URLWithString: urlStr];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestReturnCacheDataElseLoad timeoutInterval: 10];
        
        [request setHTTPMethod: @"GET"];
        
        [request addValue: APIKEY forHTTPHeaderField: @"apikey"];
        
        NSURLSession* session=[NSURLSession sharedSession];
        
        NSURLSessionDataTask* dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error)
            {
                NSLog(@"出错了:%@",error);
            }else
            {
                
                dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                if (error)
                {
                    NSLog(@"转换失败:%@",error);
                }else
                {
                    list = [dic objectForKey:@"list"];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //回调或者说是通知主线程刷新，
                        
                        
                        
                        
                    });
                }
            }
            
        }];
        
        [dataTask resume];
        
    });
}


@end
