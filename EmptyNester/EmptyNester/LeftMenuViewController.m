//
//  LeftMenuViewController.m
//  EmptyNester
//
//  Created by liman on 16/5/19.
//  Copyright © 2016年 曹少帅. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "LoginViewController.h"
#import "RegisetViewController.h"
#import <RESideMenu.h>
#import "HomeViewController.h"
#import "BaseTabBarController.h"
//#import <MapKit/MapKit.h>
//#import <CoreLocation/CoreLocation.h>
#define  WIDTH self.view.frame.size.width
#define HEIGHT self.view.frame.size.height
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:r/255.0 blue:b/255.0 alpha:a/1]
@interface LeftMenuViewController ()
{
    NSArray* array;
    NSArray* imageArray;
    NSArray* conArray;
    UIViewController* viewC;

}
@property(nonatomic,strong)LoginViewController* login;
@property(nonatomic,strong)RegisetViewController* regiset;
@property(nonatomic,strong)BaseTabBarController* baseTab;
@end

@implementation LeftMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Stars@2x.png"]]];
    
    array=@[@"首页",@"登录",@"注册",@"设置"];
 imageArray=@[@"IconHome@2x.png",@"IconProfile@2x.png",@"icon3_s_footer@3x.png",@"IconSettings@2x.png"];
    
    self.tableMenu = ({
        UITableView* tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 200,WIDTH,HEIGHT-200) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate=self;
        tableView.dataSource=self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView;
    });
    
    
    [self.view addSubview:self.tableMenu];
    
  
    
}
#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"ce"];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ce"];
        
    }
    //把tableView变透明
    cell.backgroundColor=[UIColor clearColor];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
    cell.selectedBackgroundView = [[UIView alloc] init];
    cell.imageView.image=[UIImage imageNamed:imageArray[indexPath.row]];
    cell.textLabel.text=array[indexPath.row];
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row)
    {
        case 0:
        {
            [self.sideMenuViewController setContentViewController:self.baseTab animated:YES];

            [self.sideMenuViewController hideMenuViewController];
            
        }
            break;
            
        case 1:
        {
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:self.login] animated:YES];
            [self.sideMenuViewController hideMenuViewController];
        }
            break;
        
        case 2:
        {
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:self.regiset] animated:YES];
            [self.sideMenuViewController hideMenuViewController];
        }
            break;
        case 3:
        {
            
        }
            break;
        
    }
   
    
}
#pragma mark - 懒加载
-(LoginViewController*)login
{
    if (!_login)
    {
        UIStoryboard* home=[UIStoryboard storyboardWithName:@"Home" bundle:nil];
        _login=[home instantiateViewControllerWithIdentifier:@"LoginViewController"];
    }
    return _login;
}

-(RegisetViewController*)regiset
{
    if (!_regiset)
    {
        UIStoryboard* home=[UIStoryboard storyboardWithName:@"Home" bundle:nil];
        _regiset=[home instantiateViewControllerWithIdentifier:@"RegisetViewController"];
    }
    return _regiset;
}
-(BaseTabBarController*)baseTab
{
    if (!_baseTab)
    {
        _baseTab=[BaseTabBarController new];
    }


    
    return _baseTab;
}


@end
