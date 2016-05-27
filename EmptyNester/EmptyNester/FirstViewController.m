//
//  FirstViewController.m
//  EmptyNester
//
//  Created by shao on 16/5/27.
//  Copyright © 2016年 曹少帅. All rights reserved.
//

#import "FirstViewController.h"
#import "CoreDataManager.h"
#import "User.h"
#import "SecondViewController.h"
@interface FirstViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) CoreDataManager *manager;
@end

@implementation FirstViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataArr = [[NSMutableArray alloc] init];
        _manager = [CoreDataManager sharedCoreDataManager];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"显示";
    [self loadNaviBar];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) loadNaviBar
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"新增" style:UIBarButtonItemStylePlain target:self action:@selector(clickAdd:)];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    创建取回数据请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    //    设置要检索哪种类型的实体对象
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:_manager.managedObjContext];
    //    设置请求实体
    [request setEntity:entity];
    
    //    指定对结果的排序方式
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"age" ascending:NO];
    NSArray *sortDescriptions = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptions];
    
    NSError *error = nil;
    //    执行获取数据请求，返回数组
    NSArray *fetchResult = [_manager.managedObjContext executeFetchRequest:request error:&error];
    if (!fetchResult)
    {
        NSLog(@"error:%@,%@",error,[error userInfo]);
    }
    [self.dataArr removeAllObjects];
    [self.dataArr addObjectsFromArray:fetchResult];
    [self.tableView reloadData];
}

#pragma mark - Action

- (void) clickAdd:(id)sender
{
    SecondViewController *set = [[SecondViewController alloc] init];
    set.title = @"添加";
    set.type = ADD;
    [self.navigationController pushViewController:set animated:YES];
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strCell = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strCell];
    }
    
    User *user = [_dataArr objectAtIndex:indexPath.row];
    
    cell.textLabel.text = user.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@,%d,%@,%@,%d",user.sex ,user.age.intValue,user.address,user.love,user.telephone.intValue];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    User *user = [_dataArr objectAtIndex:indexPath.row];
    
    SecondViewController *set = [[SecondViewController alloc] init];
    set.title = @"修改或者删除";
    set.type = CHANGE;
    set.user = user;
    [self.navigationController pushViewController:set animated:YES];
}


@end
