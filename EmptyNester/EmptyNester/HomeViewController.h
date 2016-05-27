//
//  HomeViewController.h
//  EmptyNester
//
//  Created by shao on 16/5/12.
//  Copyright © 2016年 曹少帅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
@interface HomeViewController : UIViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,DetailVCDelegate>

/**
 *  滚动视图
 */
@property (nonatomic,strong) UIScrollView *scrollView;


/**
 *  页码
 */
@property (nonatomic,strong) UIPageControl *pageControl;

/**
 *  定时器
 */
@property (nonatomic,strong) NSTimer *timer;

/**
 *  图片数量
 */
@property (nonatomic,assign)NSInteger imageTotal;
/**
 *  UITableView
 */
@property(nonatomic,strong)UITableView* tableView;

@property(nonatomic,strong)id<DetailVCDelegate> delegate;

@property(nonatomic,strong)NSMutableArray* messageArray;
@end
