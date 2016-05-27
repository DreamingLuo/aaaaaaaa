//
//  AppDelegate.m
//  EmptyNester
//
//  Created by shao on 16/5/12.
//  Copyright © 2016年 曹少帅. All rights reserved.
//

#import "AppDelegate.h"
#import <iflyMSC/IFlyRecognizerViewDelegate.h>
#import <iflyMSC/IFlyRecognizerView.h>
#import <iflyMSC/IFlySpeechSynthesizer.h>
#import <iflyMSC/IFlySpeechConstant.h>
#import <iflyMSC/IFlySpeechUtility.h>
#import <BmobSDK/Bmob.h>
#import "LoginViewController.h"
@interface AppDelegate ()<IFlySpeechSynthesizerDelegate>
{
    IFlySpeechSynthesizer  * _iFlySpeechSynthesizer;

}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    
    //用户通知的一些设置
    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge |UIUserNotificationTypeSound categories:nil]];
    //这个应用可以有远程推送
    [application registerForRemoteNotifications];
//    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",@"57318ca7"];
//    [IFlySpeechUtility createUtility:initString];
//    _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance]; _iFlySpeechSynthesizer.delegate = self;
//    //设置语音合成的参数
//    //语速,取值范围 0~100
//    [_iFlySpeechSynthesizer setParameter:@"50" forKey:[IFlySpeechConstant SPEED]];
//    //音量;取值范围 0~100
//    [_iFlySpeechSynthesizer setParameter:@"50" forKey: [IFlySpeechConstant VOLUME]];
//    //发音人,默认为”xiaoyan”;可以设置的参数列表可参考个 性化发音人列表
//    [_iFlySpeechSynthesizer setParameter:@" xiaoyan " forKey: [IFlySpeechConstant VOICE_NAME]];
//    //音频采样率,目前支持的采样率有 16000 和 8000
//    [_iFlySpeechSynthesizer setParameter:@"8000" forKey: [IFlySpeechConstant SAMPLE_RATE]];
//    //asr_audio_path保存录音文件路径，如不再需要，设置value为nil表示取消，默认目录是documents
//    [_iFlySpeechSynthesizer setParameter:@" tts.pcm" forKey: [IFlySpeechConstant TTS_AUDIO_PATH]];
//    //[_iFlySpeechSynthesizer startSpeaking:@"老衲姓罗"];

    return YES;
}
- (void) onCompleted:(IFlySpeechError*) error
{
    
    NSLog(@"推送完成");
    //[_iFlySpeechSynthesizer startSpeaking:@"老衲姓罗"];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    
    
    NSLog(@"推送了一条消息");
    
   
    //[_iFlySpeechSynthesizer startSpeaking:notification.alertBody]
   
}
//- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
//{
//    //"我的"页面的tabbarItem的下标是4,
//     BmobQuery* query=[BmobUser query];
//    
//    if (viewController == tabBarController.viewControllers[4] &&  (!query))
//    {
//      LoginViewController *loginViewController = [LoginViewController new];
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginViewController];
//        [((UINavigationController *)tabBarController.selectedViewController) presentViewController:nav animated:YES completion:nil];
//        
//        return YES;
//    } else {
//        return NO;
//    }
//}


@end
