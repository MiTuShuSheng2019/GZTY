//
//  TYVideoPlayerVC.h
//  美界联盟
//
//  Created by LY on 2017/11/20.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYBaseViewController.h"
#import "CHPlayerView.h"
#import "CHPlayerHeader.h"

@interface TYVideoPlayerVC : TYBaseViewController

@property(nonatomic,assign)CHPlayerType type;

/** 播放地址 */
@property (nonatomic, strong) NSString *strUrl;

@end
