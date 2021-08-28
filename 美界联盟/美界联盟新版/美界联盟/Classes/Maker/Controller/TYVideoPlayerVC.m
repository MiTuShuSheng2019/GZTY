//
//  TYVideoPlayerVC.m
//  美界联盟
//
//  Created by LY on 2017/11/20.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYVideoPlayerVC.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIView+CH_GestureRecognizer.h"
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self

@interface TYVideoPlayerVC ()

@property (strong, nonatomic) CHPlayerView *playerView;

@end

@implementation TYVideoPlayerVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
      [[NSNotificationCenter defaultCenter] postNotificationName:CHPlayerContinuePlayNotification object:self.playerView];
    
    //设置支持横竖屏
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.allowRotate = 1;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    self.navigationController.navigationBar.barTintColor = RGB(32, 135, 238);
    [[NSNotificationCenter defaultCenter] postNotificationName:CHPlayerStopPlayNotification object:self.playerView];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.allowRotate = 0;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    //采集--获取视频的宽高
    AVAsset *videoAsset = [AVAsset assetWithURL:[NSURL URLWithString:self.strUrl]];
    AVAssetTrack *videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    
//    UIImageOrientation videoAssetOrientation_  = UIImageOrientationUp;
//    BOOL isVideoAssetPortrait_  = NO;
//    CGAffineTransform videoTransform = videoAssetTrack.preferredTransform;
//    if (videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0) {
//        videoAssetOrientation_ = UIImageOrientationRight;
//        isVideoAssetPortrait_ = YES;
//    }
//    if (videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0) {
//        videoAssetOrientation_ =  UIImageOrientationLeft;
//        isVideoAssetPortrait_ = YES;
//    }
//    if (videoTransform.a == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0) {
//        videoAssetOrientation_ =  UIImageOrientationUp;
//    }
//    if (videoTransform.a == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0) {
//        videoAssetOrientation_ = UIImageOrientationDown;
//    }
    
//    [videolayerInstruction setTransform:videoAssetTrack.preferredTransform atTime:kCMTimeZero];
//    [videolayerInstruction setOpacity:0.0 atTime:videoAsset.duration];
//
//    // 3.3 - Add instructions
//    mainInstruction.layerInstructions = [NSArray arrayWithObjects:videolayerInstruction,nil];
//
    CGSize naturalSize = CGSizeMake(videoAssetTrack.naturalSize.height, videoAssetTrack.naturalSize.width);
    
    //根据视频方向来显示视频的高度
    CGFloat videoH;
    if(naturalSize.height > naturalSize.width){ 
         videoH = naturalSize.width * KScreenWidth/naturalSize.height;
    }else{
         videoH = naturalSize.height * KScreenWidth/naturalSize.width;
    }
   
    
    WS(weakSelf);
    //创建播放器 设置播放器类型playerType 是否自动播放autoPlay
    CHPlayerView *playerView = [[CHPlayerView alloc] initWithFrame:CGRectMake(0, (KScreenHeight - videoH - 64)/2, KScreenWidth, videoH) playerType:self.type autoPlay:YES];
    [self.view addSubview:playerView];
    self.playerView = playerView;
    
    //设置播放链接
    playerView.playerUrl = self.strUrl;
    //设置播放器标题
//    playerView.videoTitle = @"视频播放";
    //设置播放器额外属性
    playerView.playedColor   = [UIColor greenColor];
    playerView.cacheBarColor = [UIColor cyanColor];
    //设置播放移动小圆点 在 CHPlayerHeader.h 文件中修改对应的图片名称 并放入图片资源即可
    //非全屏返回
    playerView.backClickBlock = ^(){
        [weakSelf backAction];
    };
    //非全屏更多选项
    playerView.moreClickBlock = ^(){
        
        weakSelf.playerView.playerUrl = weakSelf.strUrl;
    };
    //播放结束回调
    playerView.playerEndBlock = ^(){
        weakSelf.playerView.playerUrl = weakSelf.strUrl;
    };
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
