//
//  WJYViewController.m
//  EmptyNester
//
//  Created by shao on 16/5/13.
//  Copyright © 2016年 曹少帅. All rights reserved.
//

#import "WJYViewController.h"
#import "QueViewController.h"
@interface WJYViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_listarr;
    //定义一个存放数据的容器。
    
    NSDictionary *dic;
    
    NSArray *list;
}


@end

@implementation WJYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.backgroundColor = [UIColor colorWithRed:0.044 green:0.391 blue:0.379 alpha:1.000];
    
    self.navigationItem.title = @"健康一问";
    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
    
    NSString *httpUrl = @"http://apis.baidu.com/tngou/ask/news";
    NSString *httpArg = @"id=0&rows=20&classify=0";
    
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
                    list = [dic objectForKey:@"list"];
                    
                    _listarr = [[NSMutableArray alloc]init];
                    
                    for (int i = 0; i <[list count]; i++)
                    {
                        NSDictionary* listdic = [list objectAtIndex:i];
                        
                        //将获取的value值放到数组容器中
                        [_listarr addObject:listdic];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_tableView reloadData];
                        
                    });
                }
            }
            
        }];
        
        [dataTask resume];
        
    });
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
    cell.detailTextLabel.text = [dic objectForKey:@"keywords"];
    
    NSString* url = [NSString stringWithFormat:@"http://tnfs.tngou.net/img%@",[dic objectForKey:@"img"]];
    cell.imageView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString* Contents = [_listarr[indexPath.row]objectForKey:@"message"];
    
    QueViewController* view = [QueViewController new];
    
    self.delegate = view;
    
    [self.delegate setValue:Contents];
    
    [self.navigationController pushViewController:view animated:YES];
    
}





@end
