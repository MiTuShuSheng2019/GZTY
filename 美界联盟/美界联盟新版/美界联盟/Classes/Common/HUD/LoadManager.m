//
//  LoadManager.m
//  QRCode
//
//  Created by mac on 14-1-15.
//  Copyright (c) 2014年 QRCode. All rights reserved.
//

#import "LoadManager.h"
#import "AppDelegate.h"
//#import "Reachability.h"
@interface LoadManager ()

@end

@implementation LoadManager

SYNTHESIZE_SINGLETON_FOR_CLASS(LoadManager)

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-  (void)showLoadingViewDelay:(UIView *)parentView{
    if (!self.acView) {
        
        self.BGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
        self.BGView.backgroundColor=[UIColor clearColor];
        
        self.acViewBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
//        self.acViewBG.backgroundColor=[UIColor colorWithHex:0X33 alpha:0.3];
        self.acViewBG.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        self.acViewBG.layer.cornerRadius=10;
        self.acViewBG.userInteractionEnabled = NO;
        
        self.acView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
        self.acView.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
        [self.acViewBG addSubview:[LoadManager sharedLoadManager].acView];
        
//        self.noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 120, 20)];
//        self.noticeLabel.text=@"加载中，请等待…";
//        [self.noticeLabel setTextAlignment:NSTextAlignmentCenter];
//        [self.noticeLabel setFont:[UIFont systemFontOfSize:13]];
//        [self.noticeLabel setTextColor:[UIColor colorWithHex:0x11 alpha:1]];
//        [self.acViewBG addSubview:self.noticeLabel];
        
        [self.BGView addSubview:self.acViewBG];
    }
    
    self.BGView.userInteractionEnabled=self.isWaiting;
    
//    if ([Device systemVersion]<7.0) {
//        self.acViewBG.center=CGPointMake(parentView.width/2, parentView.height/2);
//    }else{

        self.acViewBG.center = CGPointMake(parentView.frame.size.width/2, parentView.frame.size.height/2-30);

//    }

    [parentView addSubview:self.BGView];

    [self.acView startAnimating];
    
//    self.BGView.backgroundColor=[UIColor greenColor];
}

+ (void)showLoadingView:(UIView *)parentView{
    [LoadManager showLoadingView:parentView isWaiting:NO];
}

+ (void)showLoadingView:(UIView *)parentView isWaiting:(BOOL)isWaiting{
    [LoadManager sharedLoadManager].isWaiting = isWaiting;
    [[LoadManager sharedLoadManager] performSelector:@selector(showLoadingViewDelay:) withObject:parentView afterDelay:0];
}

- (void)hiddenLoadViewDelay{
    [self.acView stopAnimating];
    [self.BGView removeFromSuperview];
    self.isWaiting=NO;
}

+ (void)hiddenLoadView{
    [[LoadManager sharedLoadManager] performSelector:@selector(hiddenLoadViewDelay) withObject:nil afterDelay:0];
}


//+ (BOOL)isConnected
//{
//    Reachability *reachability = [Reachability reachabilityWithHostname:@"www.baidu.com"];
//    switch ([reachability currentReachabilityStatus]) {
//        case NotReachable:
//            // 没有网络连接
//            [PromptMessage showMessage:@"亲！请检测网络是否连接"];
//            return NO;
//            break;
//        case ReachableViaWWAN:
//            // 使用3G网络
//            return YES;
//            break;
//        case ReachableViaWiFi:
//            // 使用WiFi网络
//            return YES;
//            break;
//    }
//}

@end
