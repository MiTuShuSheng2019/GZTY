//
//  TYShowHud.h
//  TYNFC
//
//  Created by LY on 2018/1/16.
//  Copyright © 2018年 刘燚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYShowHud : NSObject

/** 直接显示hud加载转圈 默认2.0秒消失 */
+(void)showHud;

/** 显示hud加载成功的样式*/
+(void)showHudSucceedWithStatus:(NSString *)status;

/** 显示hud加载失败的样式*/
+(void)showHudErrorWithStatus:(NSString *)status;

//更多hud的样式请老铁自行封装了

@end
