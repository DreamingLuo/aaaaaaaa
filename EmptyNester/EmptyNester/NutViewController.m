//
//  NutViewController.m
//  EmptyNester
//
//  Created by shao on 16/5/12.
//  Copyright © 2016年 曹少帅. All rights reserved.
//

#import "NutViewController.h"
#import "ZFViewController.h"
#import "TLViewController.h"
#import "HotViewController.h"
#import "VCViewController.h"
#import "DBZViewController.h"
#import "WJYViewController.h"
#import "MedViewController.h"
#import "CWViewController.h"
@interface NutViewController ()
{
    NSArray* array;
    NSArray* arr;
}
@end

@implementation NutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithWhite:0.772 alpha:1.000];
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
    
    array = @[@"脂肪",@"糖类",@"热能",@"维生素",@"蛋白质",@"健康一问",@"用药参考",@"健康食谱"];
    arr = @[@"a9.jpg",@"b1.jpg",@"b4.jpg",@"b2.jpg",@"a1.jpg",@"a8.jpg",@"a7.jpg",@"b3.jpg"];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [array count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* str = @"cellFi";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1
                                     reuseIdentifier:str];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = array[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:arr[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            ZFViewController* zf = [[ZFViewController
                                       alloc]init];
            [self.navigationController pushViewController:zf animated:YES];
            
        }
            break;
        case 1:
        {
            TLViewController* tl = [[TLViewController
                                       alloc]init];
            [self.navigationController pushViewController:tl animated:YES];
        }
              break;
        case 2:
        {
            HotViewController* hot = [[HotViewController
                                     alloc]init];
            [self.navigationController pushViewController:hot animated:YES];
        }
            break;
        case 3:
        {
            VCViewController* vc = [[VCViewController
                                     alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:
        {
            DBZViewController* dbz = [[DBZViewController
                                     alloc]init];
            [self.navigationController pushViewController:dbz animated:YES];
        }
            break;
        case 5:
        {
            WJYViewController* wjy = [[WJYViewController
                                     alloc]init];
            [self.navigationController pushViewController:wjy animated:YES];
        }
            break;
        case 6:
        {
            MedViewController* medic = [[MedViewController
                                     alloc]init];
            [self.navigationController pushViewController:medic animated:YES];
        }
            break;
        case 7:
        {
            CWViewController* cw = [[CWViewController
                                     alloc]init];
            [self.navigationController pushViewController:cw animated:YES];
        }
            break;
        default:
            break;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
