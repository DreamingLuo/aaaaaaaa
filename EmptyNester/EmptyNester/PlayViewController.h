//
//  PlayViewController.h
//  EmptyNester
//
//  Created by shao on 16/5/12.
//  Copyright © 2016年 曹少帅. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *warning;
- (IBAction)begin:(id)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *DateTime;
@property (weak, nonatomic) IBOutlet UIPickerView *InterverTime;
@property(nonatomic,strong)NSArray* pickeyData;

@end
