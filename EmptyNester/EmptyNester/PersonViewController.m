//
//  PersonViewController.m
//  EmptyNester
//
//  Created by shao on 16/5/12.
//  Copyright © 2016年 曹少帅. All rights reserved.
//

#import "PersonViewController.h"
#import "UIImageView+WebCache.h"
#import "HGCD.h"
#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height
#define URLSTRING(r) [NSString stringWithFormat:@"http://tnfs.tngou.net/image%@",r]
#define APIKEY @"eeeabdbf5cc2ed8a6ece0399dbd00564"
#define hTTPURL @"http://apis.baidu.com/tngou/book/list"
#define HTTPARG @"id=0&page=1&rows=20"
@interface PersonViewController ()
{
    NSArray* list;/**<接口的数据*/
    //NSArray* list2;
    NSDictionary* dic;
    
    NSString* nameString;
    NSString* idString;
 
}
@property(nonatomic,strong)BookDetailViewController* bookDetail;
@end
static NSInteger bookId=1;
@implementation PersonViewController

@synthesize delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
 
    self.navigationItem.title=@"健康图书";
    
    UIBarButtonItem* rightButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(barButtonTap)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    _bookView=[[UITableView alloc]initWithFrame:CGRectMake(0, 20, screen_width, screen_height-44-20)];
    _bookView.dataSource=self;
    _bookView.delegate=self;
    [self.view addSubview:_bookView];
    
    _booksArray=[NSMutableArray array];
    
   // _booksArray2=[NSMutableArray array];
    
   // for (int i=0; i<5; i++)
    //{
      //  NSString* arg=[NSString stringWithFormat:@"id=%d",i+1];
        //[self request];
    //}
    //[self request:HTTPARG];
    
    [self request:HTTPARG];
    
    
    
}
-(void)barButtonTap
{
    NSLog(@"点击添加书籍");
    NSString* arg=[NSString stringWithFormat:@"id=%ld",(long)bookId];
    [self request:arg];
    bookId++;
}
#pragma maek - tableView  delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return _booksArray.count;
    return list.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellBook=@"cellBook";
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:cellBook];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellBook];
    }
    
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:URLSTRING([list[indexPath.row] objectForKey:@"img"])] placeholderImage:[UIImage imageNamed:@"download01.gif"]];
        cell.textLabel.text=[list[indexPath.row] objectForKey:@"name"];
        cell.textLabel.font=[UIFont systemFontOfSize:16];
        cell.detailTextLabel.text=[list[indexPath.row]objectForKey:@"author"];
        cell.detailTextLabel.font=[UIFont systemFontOfSize:16];

    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    nameString=[list[indexPath.row] objectForKey:@"name"];
    idString=[list[indexPath.row] objectForKey:@"id"];
    
    [self presentViewController:_bookDetail animated:YES completion:^{
       
        NSLog(@"图书界面已经推出");
    }];
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
                        
                        [_booksArray addObject:list];
                        [_bookView reloadData];
                        
                        
                       // NSLog(@"%lu",(unsigned long)_booksArray.count);
                        //NSLog(@"%@",_booksArray);
                    });
                }
            }
            
        }];
        
        [dataTask resume];
        
    });
}
//-(void)request
//{
//    NSString* ht=@"http://www.tngou.net/api/book/list";
//    NSString* hg=@"id=3&rows=10";
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", ht, hg];
//        NSURL *url = [NSURL URLWithString: urlStr];
//        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestReturnCacheDataElseLoad timeoutInterval: 10];
//        
//        [request setHTTPMethod: @"GET"];
//        
//        //[request addValue: APIKEY forHTTPHeaderField: @"apikey"];
//        
//        NSURLSession* session=[NSURLSession sharedSession];
//        
//        NSURLSessionDataTask* dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//            if (error)
//            {
//                NSLog(@"出错了:%@",error);
//            }else
//            {
//                
//                dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
//                if (error)
//                {
//                    NSLog(@"转换失败:%@",error);
//                }else
//                {
//                    list2 = [dic objectForKey:@"list"];
//                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        //回调或者说是通知主线程刷新，
//                        
//                        //[_booksArray addObject:dic];
//                        [_bookView reloadData];
//                        
//                        
//                        NSLog(@"%lu",(unsigned long)_booksArray.count);
//                        //NSLog(@"%@",_booksArray);
//                    });
//                }
//            }
//            
//        }];
//        
//        [dataTask resume];
//        
//    });
//

//}
-(void)viewWillAppear:(BOOL)animated
{
    _bookDetail=[BookDetailViewController new];
    self.delegate=_bookDetail;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.delegate setValue:nameString AndId:idString.intValue];
}
@end
