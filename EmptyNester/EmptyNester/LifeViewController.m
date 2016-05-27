//
//  LifeViewController.m
//  EmptyNester
//
//  Created by shao on 16/5/12.
//  Copyright © 2016年 曹少帅. All rights reserved.
//

#import "LifeViewController.h"
#define APIKEY @"3a2c4597b662f33f4c8057d4806b9598"
@interface LifeViewController ()
{
    NSMutableArray *_listarr;
    //定义一个存放数据的容器。
    
    NSDictionary *dic;
    
    NSArray *list;
}
@end

@implementation LifeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    
    
    [self.view addSubview:_tableView];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    NSString *httpUrl = @"http://apis.baidu.com/txapi/health/health";
    NSString *httpArg = @"num=10&page=1";
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, httpArg];
        NSURL *url = [NSURL URLWithString: urlStr];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
        
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
                    list = [dic objectForKey:@"newslist"];
                    
                    _listarr = [[NSMutableArray alloc]init];
                    
                    
                    for (int i = 0; i <[list count]; i++)
                    {
                        NSDictionary* listdic = [list objectAtIndex:i];
                        
                        
                        
                        //NSString *teamname = (NSString *)[listdic objectForKey:@"picUrl"];
                        
                        //将获取的value值放到数组容器中
                        [_listarr addObject:listdic];
                        
                    }
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //回调或者说是通知主线程刷新，
                        
                        [_tableView reloadData];
                        
                        
                    });
                }
            }
            
        }];
        
        [dataTask resume];
        
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //必须返回与数据容器一样的数量，否则会报数据越界错
    return [_listarr count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    dic = [_listarr objectAtIndex:indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"title"];
    cell.detailTextLabel.text = [dic objectForKey:@"ctime"];
    
    NSString* url=[_listarr[indexPath.row] objectForKey:@"picUrl"];
    
    cell.imageView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* path = [_listarr[indexPath.row]objectForKey:@"url"];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:path]];
    
}

@end
