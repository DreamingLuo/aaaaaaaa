//
//  BookDetailViewController.h
//  EmptyNester
//
//  Created by liman on 16/5/25.
//  Copyright © 2016年 曹少帅. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BookDetailVCDelegate<NSObject>
@optional
-(void)setValue:(NSString*) bookName AndId:(NSInteger)bookId;
@end
@interface BookDetailViewController : UIViewController<BookDetailVCDelegate,UITableViewDataSource,UITableViewDelegate>


@property(nonatomic,strong)UILabel* bookName;

@property(nonatomic,assign)NSInteger boodId;

@property(nonatomic,strong)UITableView* booklist;

@property(nonatomic,strong)UIWebView* bookContent;

@property(nonatomic,strong)UIView* backView;

@property(nonatomic,strong)UIToolbar* bookToolBar;
@end
