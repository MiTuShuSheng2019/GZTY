//
//  AppDelegate.m
//  美界联盟
//
//  Created by LY on 2017/10/23.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "AppDelegate.h"
#import "TYTabBarViewController.h"
#import "TYMessageViewController.h"

@interface AppDelegate ()<XGPushDelegate,WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [TYSingleton shareSingleton].consumer = [[[NSUserDefaults standardUserDefaults] objectForKey:@"consumer"] integerValue];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.window = [[UIWindow alloc] init];
    self.window.frame = [[UIScreen mainScreen] bounds];
//    self.window.backgroundColor = RGB(32, 135, 238);
    
    ABaiduMapManager *manager = [ABaiduMapManager new];
    [manager addBaiduManager:self];
    
    self.window.rootViewController = [[TYTabBarViewController alloc] init];
    [self.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    //注册微信分享
    [WXApi registerApp:WeChatShareAppID];
    
    //信鸽推送
    //打开debug开关
    [[XGPush defaultManager] setEnableDebug:YES];
    //查看debug开关是否打开
    //    BOOL debugEnabled = [[XGPush defaultManager] isEnableDebug];
    //启动信鸽推送
//    [[XGPush defaultManager] startXGWithAppID:PUSH_APPID appKey:PUSH_APPKEY delegate:self];
    
    [[XGPush defaultManager] reportXGNotificationInfo:launchOptions];
    //绑定账号
    [[XGPushTokenManager defaultTokenManager] bindWithIdentifier:[NSString stringWithFormat:@"S%@", [TYLoginModel getAPPID]] type:XGPushTokenBindTypeAccount];
    
    //是否提示更新
    [TYVersion CheckVersion];
    return YES;
}

/**
 收到通知的回调
 
 @param application  UIApplication 实例
 @param userInfo 推送时指定的参数
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    NSLog(@"[XGDemo] receive Notification");
    [[XGPush defaultManager] reportXGNotificationInfo:userInfo];
}

/**
 收到静默推送的回调
 
 @param application  UIApplication 实例
 @param userInfo 推送时指定的参数
 @param completionHandler 完成回调
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//    NSLog(@"[XGDemo] receive slient Notification");
//    NSLog(@"[XGDemo] userinfo %@", userInfo);
    [[XGPush defaultManager] reportXGNotificationInfo:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}


// iOS 10 新增 API
// iOS 10 会走新 API, iOS 10 以前会走到老 API
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// App 用户点击通知
// App 用户选择通知中的行为
// App 用户在通知中心清除消息
// 无论本地推送还是远程推送都会走这个回调
- (void)xgPushUserNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    
    //    NSDictionary *notification = response.notification.request.content.userInfo;
    //    NSLog(@"notification = %@", notification);
    //    if ([response.actionIdentifier isEqualToString:@"xgaction001"]) {
    //        NSLog(@"click from Action1");
    //    } else if ([response.actionIdentifier isEqualToString:@"xgaction002"]) {
    //        NSLog(@"click from Action2");
    //    }
    
    [[XGPush defaultManager] reportXGNotificationInfo:response];
   
    TYMessageViewController *vc = [[TYMessageViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [(TYNavigationViewController *)_window.rootViewController pushViewController:vc animated:YES];
    completionHandler();
}

// App 在前台弹通知需要调用这个接口
- (void)xgPushUserNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSDictionary *noti = notification.request.content.userInfo;
    [[XGPush defaultManager] reportXGNotificationInfo:notification.request.content.userInfo];
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

#endif

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
     [[NSNotificationCenter defaultCenter] postNotificationName:EVERYDAYONLYCALLONCE object:nil];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


//此方法会在设备横竖屏变化的时候调用
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    //  allowRotate默认等于0 等于1支持横竖屏切换
    if (_allowRotate == 1) {
        return UIInterfaceOrientationMaskAll;
    }else{
        return (UIInterfaceOrientationMaskPortrait);
    }
}

//设置推送数字显示为0
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

// 返回是否支持设备自动旋转
- (BOOL)shouldAutorotate{
    if (_allowRotate == 1) {
        return YES;
    }
    return NO;
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    return [WXApi handleOpenURL:url delegate:self];
}

@end
