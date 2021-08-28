//
//  TYShowHud.m
//  TYNFC
//
//  Created by LY on 2018/1/16.
//  Copyright © 2018年 刘燚. All rights reserved.
//

#import "TYShowHud.h"

@implementation TYShowHud

/* 直接显示hud加载转圈 */
+(void)showHud{
    [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD show];
    [SVProgressHUD dismissWithDelay:2.0];//默认2秒消失
}

/* 显示hud加载成功的样式 */
+(void)showHudSucceedWithStatus:(NSString *)status{
    [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD showSuccessWithStatus:status];
    [SVProgressHUD dismissWithDelay:2.0];
    
}

/* 显示hud加载失败的样式 */
+(void)showHudErrorWithStatus:(NSString *)status{
    [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD showErrorWithStatus:status];
    [SVProgressHUD dismissWithDelay:4.0];
}

@end
