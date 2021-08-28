//
//  LoadManager.h
//  QRCode
//
//  Created by mac on 14-1-15.
//  Copyright (c) 2014年 QRCode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadManager : UIViewController

@property (nonatomic,strong) UIActivityIndicatorView *acView;
@property (nonatomic,strong) UILabel *noticeLabel;
@property (nonatomic,strong) UIView *acViewBG;//小方形试图。
@property (nonatomic,strong) UIView *BGView;//全屏试图view，不包括导航栏。用于是否接收事件，在网络没有返回时阻止用户进一步操作。
@property (nonatomic) BOOL  isWaiting;//全屏试图view，不包括导航栏。用于是否接收事件，在网络没有返回时阻止用户进一步操作。

SYNTHESIZE_SINGLETON_FOR_HEADER(LoadManager)

//在parentView中间显示一个加载等待中的视图。该视图不接受事件，提供给客户端更好的体验。
+ (void)showLoadingView:(UIView *)parentView;

+ (void)showLoadingView:(UIView *)parentView isWaiting:(BOOL)isWaiting;

//隐藏加载视图。（内置的加载视图是一个单例，所以，当前只能显示一个加载视图。暂时没有扩展显示多个。）
+ (void)hiddenLoadView;

//判断网络是否连接
//+ (BOOL)isConnected;

@end
