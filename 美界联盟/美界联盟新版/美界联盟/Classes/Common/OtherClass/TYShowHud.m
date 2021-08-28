//
//  TYShowHud.m
//  美界联盟
//
//  Created by LY on 2017/12/11.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYShowHud.h"

@implementation TYShowHud

/* 直接显示hud加载转圈 */
+(void)showHud{
    [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD show];
    [SVProgressHUD dismissWithDelay:1.0];//默认1秒消失
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
    [SVProgressHUD dismissWithDelay:3.0];
}

@end
