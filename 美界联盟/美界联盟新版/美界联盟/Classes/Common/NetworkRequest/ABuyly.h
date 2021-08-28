//
//  ABuyly.h
//  美界联盟
//
//  Created by LY on 2018/2/5.
//  Copyright © 2018年 刘燚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bugly/Bugly.h>
#import "AppDelegate.h"
#import <UIKit/UIKit.h>

@interface ABuyly : NSObject
//设置bugly
+(void) buylyWithDelegate:(nonnull AppDelegate *) appDelegate;

//上报异常
+ (void)buylyExceptionWithName:(nonnull NSExceptionName)name reason:(nullable NSString *)reason userInfo:(nullable NSDictionary *)userInfo;

////网络连接超时上报
//+(void) buylyNetWorkTimeForm:(nonnull NSDate *)start name:(nullable NSString *)name urlPath:(nullable NSString *)urlPaht mark:(nullable NSString *)mark;
////网络连接超时上报
//+(void) buylyNetWorkTimeForm:(NSDate *)start name:(NSString *)name urlPath:(NSString *)urlPaht mark:(NSString *)mark time:(NSInteger )time;

//上报异常
+ (void)buylyException:(nonnull NSException *)exception code:(NSInteger) code;

//上报异常
+ (void)buylyException:(nonnull NSException *)exception methodName:(nonnull NSString *) mtheodName;
+(void) setNamePlace:(nonnull NSString *)string;

#pragma mark 抛物线动画,新增一个动画view在supView上，做动画的事新增的图层
+(void)throwView:(UIView *)obj toPoint:(CGPoint)end height:(CGFloat)height duration:(CGFloat)duration delegate:(id <CAAnimationDelegate>) delegate supView:(UIView *)supView;

#pragma mark 水平滚动动画，滚动
+(void)rollView:(UIView *)obj toFrame:(CGRect)frame duration:(CGFloat)duration;

@end

