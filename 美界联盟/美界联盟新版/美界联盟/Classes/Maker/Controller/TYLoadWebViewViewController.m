//
//  TYLoadWebViewViewController.m
//  美界联盟
//
//  Created by LY on 2017/11/21.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYLoadWebViewViewController.h"
#import "TYChooseSharePlatformView.h"

@interface TYLoadWebViewViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *myWebView;

@end

@implementation TYLoadWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:self.model.de andTitleColor:[UIColor whiteColor] andImage:nil];
    [self setNavigationRightBtnImage:@"white_share_icon"];
    
    [_myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.model.dk]]];
}

#pragma mark ------- 点击分享
- (void)navigationRightBtnClick:(UIButton *)btn{
   
    TYChooseSharePlatformView *shareView = [TYChooseSharePlatformView CreatTYChooseSharePlatformView];
    shareView.shareLink = self.model.dk;
    shareView.title = self.model.de;
    shareView.descri = self.model.df;
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

@end
