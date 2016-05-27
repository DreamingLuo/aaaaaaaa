//
//  PlayViewController.m
//  EmptyNester
//
//  Created by shao on 16/5/12.
//  Copyright © 2016年 曹少帅. All rights reserved.
//

#import "PlayViewController.h"

@interface PlayViewController ()
{
UILocalNotification* notif;

}
@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor grayColor];
    
      self.navigationItem.title=@"提醒";
    _pickeyData=[[NSArray alloc]initWithObjects:@"每分钟",@"每小时",@"每天",@"每个月",@"每年",@"不重复", nil];
    
    _InterverTime.dataSource=self;
    _InterverTime.delegate=self;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 1;
    
    
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    
    return [_pickeyData count];
    
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_pickeyData objectAtIndex:row];
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)begin:(id)sender
{
    
    //NSLog(@"%@",[NSDate date]);
    
   // NSDateFormatter* fomatter=[[NSDateFormatter alloc]init];
    //[fomatter setDateFormat:@"HH:mm:ss"];
    // NSDate * datenow=[fomatter dateFromString:@"24:00:00"];
    //创建一个本地通知
    
    notif=[[UILocalNotification alloc]init];
    
    if (notif)
    {
       // NSDate *currentDate   = [NSDate date];
       // NSDate *date=[_DateTime date];
       // NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
       // formatter.dateFormat=@"yy-MM-dd HH:mm:ss";
        //NSString* timeStr=[formatter stringFromDate:date];
        notif.timeZone = [NSTimeZone defaultTimeZone]; // 使用本地时区
        notif.fireDate=[_DateTime date];
        NSLog(@"%@",_DateTime.date);
        //notif.fireDate =  notif.fireDate = [currentDate dateByAddingTimeInterval:10.0];
         NSInteger row=[_InterverTime selectedRowInComponent:0];
        
        switch (row) {
            case 0:
                notif.repeatInterval=NSCalendarUnitMinute;
                break;
            case 1:
                notif.repeatInterval=kCFCalendarUnitHour;
                break;
            case 2:
                notif.repeatInterval=kCFCalendarUnitDay;
                break;
            case 3:
                notif.repeatInterval=kCFCalendarUnitMonth;
                break;
            case 4:
                notif.repeatInterval=kCFCalendarUnitYear;
                break;
            case 5:
                notif.repeatInterval=0;
                break;

                
            default:
                break;
        }
        //[notif setFireDate:date];
        notif.timeZone=[NSTimeZone defaultTimeZone];
        notif.repeatInterval=NSCalendarUnitMinute;
        //推送的内容
        notif.alertBody=_warning.text;
        notif.applicationIconBadgeNumber=1;
        
        [[UIApplication sharedApplication]scheduleLocalNotification:notif];
        
        

    
    
}
}
@end
