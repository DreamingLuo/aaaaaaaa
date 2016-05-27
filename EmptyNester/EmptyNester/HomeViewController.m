//
//  HomeViewController.m
//  EmptyNester
//
//  Created by shao on 16/5/12.
//  Copyright © 2016年 曹少帅. All rights reserved.
//

#import "HomeViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <RESideMenu.h>
#import "ZDBtnView.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "MJChiBaoZiHeader.h"
#import "BookViewController.h"
#import "CookBookViewController.h"
#define APIKEY @"eeeabdbf5cc2ed8a6ece0399dbd00564"
#define hTTPURL @"http://apis.baidu.com/tngou/info/news"
#define HTTPARG @"id=0&classify=0&rows=20"

#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height

#define URLSTRING(r) [NSString stringWithFormat:@"http://tnfs.tngou.net/image%@",r]

@interface HomeViewController ()
{
    
    CLLocationManager *_locationManager;
    
    MKMapView *_mapView;
    
    NSArray* list;/**<接口的数据*/
    
    NSDictionary* dic;
    
    NSArray* menuArray;
    NSArray* imageArray;
    
    CGFloat imageH;
    CGFloat imageW;
    CGFloat imageX;
    CGFloat imageY;
    
    NSString* imageString;
    NSString* titleString;
    
    
}
@property(nonatomic,strong)DetailViewController* detail;
@property(nonatomic,strong)BookViewController* book;
@property(nonatomic,strong)CookBookViewController* cookBook;
@end
static const CGFloat MJDuration = 2.0;
static NSInteger messageIdCount = 1;
@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;

    
    self.navigationItem.title=@"首页";
    
    UIBarButtonItem* rightButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(barButtonTap)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    UIBarButtonItem* leftButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"tabbar-me"] style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController:)];
    self.navigationItem.leftBarButtonItem=leftButton;

    [self initData];
    
    //1 设置 image
    //图片位置
    imageH = self.scrollView.frame.size.height;
    imageW = self.scrollView.frame.size.width;
    imageX = 0;
    imageY = 0;
    
    //2 设置 scrollView
    //隐藏进度条
    self.scrollView.showsHorizontalScrollIndicator=YES;
    
    //设置拖拽范围
    CGFloat sizeW = self.imageTotal*imageW;
    self.scrollView.contentSize =CGSizeMake(sizeW, 0);
    
    //设置分页
    self.scrollView.pagingEnabled=YES;
    
    
    //监听scrollView 滚动
    self.scrollView.delegate=self;
    
    
    
    //3 设置 pageControl
    //设置共用多少页
    self.pageControl.numberOfPages= self.imageTotal;
    
    //设置其他页码颜色 绿色
    self.pageControl.pageIndicatorTintColor = [UIColor cyanColor];
    
    //设置当前页码颜色 红色
    self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    
    
    
    //4.添加定时器
    [self addTimer];
    UIView* bView1=[[UIView alloc]initWithFrame:CGRectMake(0, self.scrollView.frame.size.height+self.scrollView.frame.origin.y, screen_width, 8)];
    [bView1 setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:bView1];
    //
    UIView* backView=[[UIView alloc]initWithFrame:CGRectMake(0, bView1.frame.size.height+bView1.frame.origin.y, self.view.frame.size.width, 80)];
    backView.backgroundColor=[UIColor whiteColor];
    
    for (int i=0; i<4; i++)
    {
        //if (i<4)
        //{
            CGRect frame=CGRectMake(i*screen_width/4, 0, screen_width/4, 60);
            NSString* title=[menuArray objectAtIndex:i];
            NSString* imageStr=imageArray[i];
            
            ZDBtnView* btnView=[[ZDBtnView alloc]initWithFrame:frame title:title imageStr:imageStr];
            btnView.backgroundColor=[UIColor whiteColor];
            btnView.tag=10+i;
            
            [backView addSubview:btnView];
        
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBtnView:)];
            [btnView addGestureRecognizer:tap];
            
        //}
//        else
//        {
//            CGRect frame = CGRectMake((i-4)*screen_width/4, 80, screen_width/4, 60);
//            NSString* title=[menuArray objectAtIndex:i];
//            NSString* imageStr=imageArray[i];
//            
//            ZDBtnView* btnView=[[ZDBtnView alloc]initWithFrame:frame title:title imageStr:imageStr];
//            btnView.backgroundColor=[UIColor whiteColor];
//            btnView.tag=10+i;
//            [backView addSubview:btnView];
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBtnView:)];
//            [btnView addGestureRecognizer:tap];
//        }
    }
    [self.view addSubview:backView];
    
    UIView* bView=[[UIView alloc]initWithFrame:CGRectMake(0, backView.frame.origin.y+backView.frame.size.height, screen_width, 8)];
    [bView setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:bView];
   
    
    //UItableView
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, bView.frame.size.height+bView.frame.origin.y, screen_width, 500)];
    
    _tableView.backgroundColor=[UIColor whiteColor];
    
    //吃包子
    MJChiBaoZiHeader* chibaoziH=[MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    _tableView.mj_header=chibaoziH;
    
    //[_tableView.mj_header beginRefreshing];
    
    [self.view addSubview:_tableView];
    
    _tableView.dataSource=self;
    _tableView.delegate=self;


    [self request:HTTPARG];

    
}
#pragma mark - 刷新数据
//有待调整
-(void)loadNewData
{
    if (_messageArray)
    {
        _messageArray=nil;
    }
    //[_messageArray addObjectsFromArray:list];
    _messageArray=[NSMutableArray arrayWithArray:list];
    
    NSString* httpArg=[NSString stringWithFormat:@"id=%ld&classify=0&rows=20",messageIdCount*20];
    
    [self request:httpArg];
   
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [_tableView.mj_header beginRefreshing];
        [_tableView reloadData];
        // 拿到当前的下拉刷新控件，结束刷新状态
        [_tableView.mj_header endRefreshing];
        
        messageIdCount++;
    });
   
}
#pragma mark - 初始化数据
-(void)initData
{
    menuArray=@[@"健康图书",@"健康菜谱",@"健康咨询",@"健康知识",@"健康一问",@"健康食品",@"天气预报",@"病状信息"];
    
    imageArray=@[@"homeBtn02.png",@"icon1_c_footer@3x.png",@"homeBtn00.png",@"icon1_c_footer@3x.png",@"homeBtn04.png",@"icon1_c_footer@3x.png",@"icon1_c_footer@3x.png",@"homeBtn07.png"];
    
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
                    list = [dic objectForKey:@"tngou"];
                    
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
#pragma mark - 按钮点击事件
-(void)OnTapBtnView:(UITapGestureRecognizer *)sender
{
   // NSLog(@"tag:%ld",sender.view.tag);
    switch (sender.view.tag)
    {
        case 10:
        {
            [self.navigationController pushViewController:self.book animated:YES];
        }
            break;
        case 11:
        {
            [self.navigationController pushViewController:self.cookBook animated:YES];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - 图片调用方法
/**
 *  下一张图片
 */
-(void)nextImage
{
    NSInteger page = self.pageControl.currentPage;
    if (page==(self.imageTotal-1))
    {
        page=0;
    }else
    {
        page++;
    }
    self.scrollView.contentOffset=CGPointMake(page*self.scrollView.frame.size.width, 0);
}

#pragma mark - timer方法
/**
 *  添加定时器
 */
-(void)addTimer
{
    self.timer =  [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    //多线程 UI IOS程序默认只有一个主线程，处理UI的只有主线程。如果拖动第二个UI，则第一个UI事件则会失效。
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}



/**
 *  关闭定时器
 */
-(void)closeTimer
{
    [self.timer invalidate];
}


#pragma mark - scrollView事件
/**
 *  scrollView 开始拖拽的时候调用
 *
 */
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self closeTimer];
}

/**
 * scrollView滚动的时候调用
 *
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    分页计算方法
    
    CGFloat page = (scrollView.contentOffset.x+scrollView.frame.size.width/2)/(scrollView.frame.size.width);
    self.pageControl.currentPage=page;
    
}

/**
 *  scrollView 结束拖拽的时候调用
 *
 */
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
}
#pragma mark - 定位
-(void)barButtonTap
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"GPS定位" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* sureAction = [UIAlertAction actionWithTitle:@"我在哪" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        CGRect rect=[UIScreen mainScreen].bounds;
        _mapView=[[MKMapView alloc]initWithFrame:rect];
        [self.view addSubview:_mapView];
        //设置代理
                
        //请求定位服务
        _locationManager=[[CLLocationManager alloc]init];
        if(![CLLocationManager locationServicesEnabled]||[CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedWhenInUse){
            [_locationManager requestWhenInUseAuthorization];
        }
        
        //用户位置追踪(用户位置追踪用于标记用户当前位置，此时会调用定位服务)
        _mapView.userTrackingMode=MKUserTrackingModeFollow;
        
        //设置地图类型
        _mapView.mapType=MKMapTypeStandard;
        

    }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"附近好友" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alert addAction:sureAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:^{
    }];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [_mapView removeFromSuperview];
}
#pragma mark - 懒加载
-(UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc]init];
        
        //设置frame
        
        CGFloat scrollW = self.view.frame.size.width;
        CGFloat scrollH = 160;
        CGFloat scrollX = 0;
        CGFloat scrollY = 44;
        _scrollView.frame = CGRectMake(scrollX, scrollY, scrollW, scrollH);
        _scrollView.backgroundColor = [UIColor whiteColor];
        
        //添加到view
        [self.view addSubview:_scrollView];
        
        UITapGestureRecognizer* tapSV=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSV)];
        [_scrollView addGestureRecognizer:tapSV];
    }
    return _scrollView;
}

-(UIPageControl *)pageControl
{
    if (!_pageControl)
    {
        _pageControl = [[UIPageControl alloc]init];
        
        //设置frame
        CGFloat pageW = 160;
        CGFloat pageH = 10;
        CGFloat pageX = (self.view.frame.size.width-pageW)/2;
        CGFloat pageY = 180;
        _pageControl.frame =CGRectMake(pageX, pageY, pageW, pageH);
        
        //添加到view
        [self.view addSubview:_pageControl];
    }
    return _pageControl;
}

-(NSInteger)imageTotal
{
    return 5;
}
//-(NSMutableArray*)messageArray
//{
//    if (_messageArray)
//    {
//        _messageArray=[NSMutableArray array];
//    }
//    return _messageArray;
//}
-(BookViewController*)book
{
    if (!_book)
    {
        _book=[BookViewController new];
    }
    return _book;
}
-(CookBookViewController*)cookBook
{
    if (_cookBook)
    {
        _cookBook=[CookBookViewController new];
    }
    return _cookBook;
}
#pragma mark - 点击轮播图片
-(void)tapSV
{
    imageString=URLSTRING([list[self.pageControl.currentPage]objectForKey:@"img"]);
    titleString=[list[self.pageControl.currentPage] objectForKey:@"message"];
    
    
    
    [self.navigationController pushViewController:_detail animated:YES];

}
#pragma mark -tableView 代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return list.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* homeCell=@"homeCell";
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:homeCell];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:homeCell];
    }

    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:URLSTRING([list[indexPath.row]objectForKey:@"img"])] placeholderImage:[UIImage imageNamed:@"download02.gif"]];
    cell.textLabel.text=[list[indexPath.row] objectForKey:@"title"];
    cell.textLabel.font=[UIFont systemFontOfSize:18];
    cell.detailTextLabel.text=[list[indexPath.row] objectForKey:@"keywords"];
    cell.detailTextLabel.font=[UIFont systemFontOfSize:14];
    
    [self updateView];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     imageString=URLSTRING([list[indexPath.row]objectForKey:@"img"]);
    titleString=[list[indexPath.row] objectForKey:@"message"];
    
    
    
    [self.navigationController pushViewController:_detail animated:YES];
    
}
-(void)updateView
{
    for (int i=0; i<self.imageTotal; i++)
    {
        UIImageView *imageView = [UIImageView new];
        imageX = i * imageW;
        imageView.frame=CGRectMake(imageX, imageY, imageW, imageH);
        [imageView sd_setImageWithURL:[NSURL URLWithString:URLSTRING([list[i]objectForKey:@"img"])] placeholderImage:[UIImage imageNamed:@"download01.gif"]];
        
        
        [self.scrollView addSubview:imageView];
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.delegate setValue:titleString AndImage:imageString];;
}
-(void)viewWillAppear:(BOOL)animated
{
    _detail=[DetailViewController new];
    self.delegate=_detail;
}
@end
