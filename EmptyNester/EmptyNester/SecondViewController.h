//
//  SecondViewController.h
//  EmptyNester
//
//  Created by shao on 16/5/27.
//  Copyright © 2016年 曹少帅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataManager.h"
#import "User.h"
@interface SecondViewController : UIViewController
typedef enum : NSUInteger {
    ADD,
    CHANGE
} Type;
@property (weak, nonatomic) IBOutlet UITextField *tfName;
@property (weak, nonatomic) IBOutlet UITextField *tfAge;
@property (weak, nonatomic) IBOutlet UITextField *tfSex;
@property (weak, nonatomic) IBOutlet UITextField *tfAddress;
@property (weak, nonatomic) IBOutlet UITextField *tfTelephone;
@property (weak, nonatomic) IBOutlet UITextField *tfLove;

@property (nonatomic, assign) Type type;
@property (nonatomic, strong) User *user;
@end
