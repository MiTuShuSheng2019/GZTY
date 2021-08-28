//
//  TYOpenWXVC.m
//  美界联盟
//
//  Created by LY on 2018/12/12.
//  Copyright © 2018 刘燚. All rights reserved.
//

#import "TYOpenWXVC.h"
#import "TYChooseSharePlatformView.h"

@interface TYOpenWXVC ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation TYOpenWXVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    [self setNavigationRightBtnImage:@"white_share_icon"];
    [self setNavigationBarTitle:self.titleText andTitleColor:[UIColor whiteColor] andImage:nil];

    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
    [self.webView loadRequest:request];
}

#pragma mark ------- 点击分享
- (void)navigationRightBtnClick:(UIButton *)btn{
    
    TYChooseSharePlatformView *shareView = [TYChooseSharePlatformView CreatTYChooseSharePlatformView];
    shareView.shareLink = self.url;
//    shareView.title = self.model.de;
//    shareView.descri = self.model.df;
    shareView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:shareView];
    
}

#pragma mark -- <UIWebViewDelegate>
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [LoadManager showLoadingView:self.view];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [LoadManager hiddenLoadView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [LoadManager hiddenLoadView];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self cleanCacheAndCookie];
}

- (void)cleanCacheAndCookie{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}


@end
