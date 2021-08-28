//
//  TYLogisticsInformationVC.m
//  美界联盟
//
//  Created by LY on 2017/11/8.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYLogisticsInformationVC.h"
#import <WebKit/WebKit.h>
#import "TYLogisticsModel.h"

@interface TYLogisticsInformationVC ()
{
    NSString *cellReuseIdentifier;
    NSMutableArray *dataScoure;
    
}
@property (strong, nonatomic)  WKWebView *webView;

@end

@implementation TYLogisticsInformationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"物流信息" andTitleColor:[UIColor whiteColor] andImage:nil];
    //网络请求
    [self requestGetConSheetType];
    //初始化webView
    [self initView];
}

-(void) initView{
    @try{
        //以下代码适配大小
        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addUserScript:wkUScript];
        
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        wkWebConfig.userContentController = wkUController;
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
        [self.view addSubview:_webView];
        
    }@catch(NSException *e){
        [ABuyly buylyException:e methodName:NSStringFromSelector(_cmd)];
    };
}

//物流链接
-(NSString *) getUrlType:(NSString *)type postID:(NSString *)code{
    return [NSString stringWithFormat:@"https://m.kuaidi100.com/index_all.html?type=%@&postid=%@",type,code];
}

#pragma mark --- 网络请求
//37 经销中心-发货管理-发货-获取托运单类型(快递公司)
-(void)requestGetConSheetType{
    [SVProgressHUD showWithStatus:@"查询中..."];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([TYSingleton shareSingleton].consumer == 1) {
        params[@"a"] = [TYConsumerLoginModel getSessionID];//回话session
    }else{
        params[@"a"] = [TYLoginModel getSessionID];//回话session
    }
    params[@"b"] = @(1);//页码
    params[@"c"] = @(10);//页大小
    params[@"d"] = self.logisticsName;//根据字典名称获取字典编码
    NSString *url = [NSString stringWithFormat:@"%@mapi/mpsi/GetConSheetType",APP_REQUEST_URL];
    
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            
            NSArray *arr = [TYLogisticsModel mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"e"]];
            [self.modelArray addObjectsFromArray:arr];
            
            TYLogisticsModel *model = [self.modelArray firstObject];

            NSURL *url = [NSURL URLWithString:[self getUrlType:model.ec postID:self.sheetCode]];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [_webView loadRequest:request];
            
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
        [SVProgressHUD dismissWithDelay:1.0];
    } orFailBlock:^(id error) {
        [SVProgressHUD dismissWithDelay:1.0];
    }];
}

@end
