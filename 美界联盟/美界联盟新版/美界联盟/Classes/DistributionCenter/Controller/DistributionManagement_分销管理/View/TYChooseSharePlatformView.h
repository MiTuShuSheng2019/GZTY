//
//  TYChooseSharePlatformView.h
//  美界联盟
//
//  Created by LY on 2017/11/7.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYChooseSharePlatformView : UIView

//创建
+(instancetype)CreatTYChooseSharePlatformView;

/** 分享链接 必传*/
@property (nonatomic, strong) NSString *shareLink;

/** 分享标题 可选*/
@property (nonatomic, strong) NSString *title;
/** 分享副标题 可选*/
@property (nonatomic, strong) NSString *descri;

@end
