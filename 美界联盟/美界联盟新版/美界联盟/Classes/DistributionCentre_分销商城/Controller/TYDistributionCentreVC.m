//
//  TYDistributionCentreVC.m
//  美界联盟
//
//  Created by LY on 2018/4/12.
//  Copyright © 2018年 刘燚. All rights reserved.
//

#import "TYDistributionCentreVC.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>
#import "TYChooseSharePlatformView.h"

@interface TYDistributionCentreVC ()<WKNavigationDelegate,WKScriptMessageHandler>

//@property (weak, nonatomic) IBOutlet UIWebView *myWebView;


@end

@implementation TYDistributionCentreVC
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [TYBootPageView showForView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setNavigationBarTitle:@"分销商城" andTitleColor:[UIColor whiteColor] andImage:nil];
    [LoadManager showLoadingView:self.view];
    WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc]init];
    //注册供js调用的方法
    WKUserContentController *userContentController =[[WKUserContentController alloc]init];
    [userContentController addScriptMessageHandler:self  name:@"sharp"];//注册一个name为aaa的js方法
    configuration.userContentController = userContentController;
    configuration.preferences.javaScriptEnabled = YES; //打开JavaScript交互 默认为YES
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight  - self.tabBarController.tabBar.frame.size.height) configuration:configuration];
     [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:DistributionCentreUrl]]];
    
    [self.view addSubview:webView];
    webView.navigationDelegate = self;
}

-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    //message.name  js发送的方法名称
    if([message.name  isEqualToString:@"sharp"])
    {
        NSString *title = [message.body objectForKey:@"title"];
        NSString *link = [message.body objectForKey:@"link"];
        NSString *des = [message.body objectForKey:@"des"];
        
        TYChooseSharePlatformView *shareView = [TYChooseSharePlatformView CreatTYChooseSharePlatformView];
        shareView.shareLink = link;
        shareView.title = title;
        shareView.descri = des;
        
        shareView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:shareView];
    }
}

- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^ _Nullable)(_Nullable id, NSError * _Nullable error))completionHandler{
    
    
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    [LoadManager hiddenLoadView];
}


@end

