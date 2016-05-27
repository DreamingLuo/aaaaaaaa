//
//  AuthcodeView.h
//  EmptyNester
//
//  Created by liman on 16/5/19.
//  Copyright © 2016年 曹少帅. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthcodeView : UIView
@property(nonatomic,strong)NSArray* dataArray;/**<字符素材数组*/
@property(nonatomic,strong)NSMutableString* authCodeStr;/**<验证码字符串*/
@end
