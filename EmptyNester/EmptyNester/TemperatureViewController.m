//
//  TemperatureViewController.m
//  EmptyNester
//
//  Created by shao on 16/5/27.
//  Copyright © 2016年 曹少帅. All rights reserved.
//

#import "TemperatureViewController.h"
#import "HYModel.h"
#import "fmdbTool.h"
@interface TemperatureViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *idField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UIButton *insertBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *queryBtn;

@property (weak, nonatomic) IBOutlet UIButton *updateBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)insertAction:(UIButton *)sender;
- (IBAction)deleteAction:(UIButton *)sender;
- (IBAction)queryAction:(UIButton *)sender;
- (IBAction)updateAction:(UIButton *)sender;

@end

@implementation TemperatureViewController

{
    NSMutableArray *_tableSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableSource = [[NSMutableArray alloc]init];
    [_tableSource setArray:[fmdbTool queryDataWithId:nil]];
    [self.tableView reloadData];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _tableSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    
    HYModel *model = _tableSource[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"日期：%@",model.modelId];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"体温：%@",model.attribute1];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (IBAction)insertAction:(UIButton *)sender
{
    HYModel *model = [[HYModel alloc]init];
    model.modelId = _idField.text;
    model.attribute1 = _valueField.text;
    BOOL isOk = [fmdbTool insertModel:model];
    if (isOk) {
        NSLog(@"插入成功！！！");
        [_tableSource setArray:[fmdbTool queryDataWithId:nil]];
        [self.tableView reloadData];
    }else{
        NSLog(@"插入失败了！！！");
    }
}

- (IBAction)deleteAction:(UIButton *)sender
{
    BOOL isok = [fmdbTool deleteDataWithId:_idField.text];
    if (isok) {
        NSLog(@"删除成功！！！！！！");
        [_tableSource setArray:[fmdbTool queryDataWithId:nil]];
        [self.tableView reloadData];
    }else{
        NSLog(@"删除失败了！！！！！");
    }
}


- (IBAction)queryAction:(UIButton *)sender
{
    [_tableSource setArray:[fmdbTool queryDataWithId:_idField.text]];
    [self.tableView reloadData];

}

- (IBAction)updateAction:(UIButton *)sender
{
    HYModel *model = [[HYModel alloc]init];
    model.modelId = _idField.text;
    model.attribute1 = _valueField.text;
    
    BOOL isOk = [fmdbTool modifyDataWithId:_idField.text andModel:model];
    if (isOk) {
        NSLog(@"修改成功！！！！！");
        [_tableSource setArray:[fmdbTool queryDataWithId:nil]];
        [self.tableView reloadData];
    }else{
        NSLog(@"修改失败了！！！！！");
    }

}
@end
