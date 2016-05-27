//
//  PersonViewController.h
//  EmptyNester
//
//  Created by shao on 16/5/12.
//  Copyright © 2016年 曹少帅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookDetailViewController.h"
@interface PersonViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,BookDetailVCDelegate>

@property(nonatomic,strong)UITableView*  bookView;

@property(nonatomic,strong)NSMutableArray* booksArray;

@property(nonatomic,strong)NSMutableArray* booksArray2;

@property(nonatomic,strong)id<BookDetailVCDelegate> delegate;
@end
