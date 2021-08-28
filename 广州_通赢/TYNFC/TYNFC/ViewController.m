//
//  ViewController.m
//  TYNFC
//
//  Created by LY on 2017/12/28.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "ViewController.h"
#import <CoreNFC/CoreNFC.h>
#import "TYQRCodeViewController.h"
#import "FourVerificationCodeQuery.h"
#import "NFCVerificationQuery.h"

@interface ViewController ()<NFCNDEFReaderSessionDelegate>

@property (nonatomic, strong) NFCNDEFReaderSession *session;

@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *nfcImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    nfcImg.image = [UIImage imageNamed:@"nfc"];
    [self.view addSubview:nfcImg];
}

//当有一个或多个手指触摸事件在当前视图或window窗体中响应
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    int x = point.x;
    int y = point.y;
    
//    NSLog(@"touch (x, y) is (%d, %d)", x, y);
    
    if(IS_IPHONE_PLUS){
        if ((x >= 130 && x <= 260) && (y >= 290 && y <= 409)) {
            
            //扫码查询
            [self ClickQrCode];
            
        }else if ((x >= 250 && x <= 350) && (y >= 430 && y <= 530)){
            [self ClickQuery];
        }
        
    }else {

        if ((x >= 120 && x <= 235) && (y >= 260 && y <= 375)) {
            //扫码查询
            [self ClickQrCode];
        }else if ((x >= 230 && x <= 315) && (y >= 390 && y <= 475)){
           
             [self ClickQuery];
        }
    }
}


#pragma mark -- 开始查询
-(void)ClickQuery{
   
    //如果希望读取多个标签invalidateAfterFirstRead设置为NO
    self.session = [[NFCNDEFReaderSession alloc] initWithDelegate:self queue:dispatch_queue_create(NULL, DISPATCH_QUEUE_CONCURRENT) invalidateAfterFirstRead:YES];
   
    [self.session beginSession];
}

#pragma mark -- <NFCNDEFReaderSessionDelegate>
//扫描到的回调
-(void)readerSession:(NFCNDEFReaderSession *)session didDetectNDEFs:(NSArray<NFCNDEFMessage *> *)messages{
    
    for (NFCNDEFMessage *message in messages) {
        for (NFCNDEFPayload *payload in message.records) {
            
//            NSLog(@"Payload data=%@",payload.payload);
            
            NSString *str = [[NSString alloc] initWithData:payload.payload encoding:NSUTF8StringEncoding];
           
//             NSRange range = [str rangeOfString:@"en"];
            //截取掉前面的字符串en
            NSString *result  = [str substringFromIndex:3];
            
            [self requestCodeTepy:result];
            
        }
    }
}

//错误回调
-(void)readerSession:(NFCNDEFReaderSession *)session didInvalidateWithError:(NSError *)error{
//    NSLog(@"error = %@", error);
   
}

#pragma mark -- 二维码查询
-(void)ClickQrCode{
    TYQRCodeViewController *qrCodeVc = [[TYQRCodeViewController alloc] init];
    [self presentViewController:qrCodeVc animated:YES completion:nil];
}

#pragma mark -- 网络请求
//请求条码类型
-(void)requestCodeTepy:(NSString *)code{
    NSString *url = [NSString stringWithFormat:@"http://tyfwjk.ty-315.com/api/fw/type?code=%@&ip=%@",code,[TYDevice getIPAddress]];
    [TYNetworkRequest getRequestURL:url parameters:nil andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        if ([[respondObject objectForKey:@"Status"] integerValue] == 1 || [[respondObject objectForKey:@"Status"] integerValue] == 3) {
            
            FourVerificationCodeQuery *queryVc = [[FourVerificationCodeQuery alloc] init];
            queryVc.fwCode = code;
            TYNavigationViewController *nag = [[TYNavigationViewController alloc] initWithRootViewController:queryVc];
            [self presentViewController:nag animated:YES completion:nil];
            //1彩码验证查询 //3验证码查询界面
            
        }else if ([[respondObject objectForKey:@"Status"] integerValue] == 2){
            //2彩码非验证查询
            [self requestCodeNoVerificationQuery:code];
            
        }else if ([[respondObject objectForKey:@"Status"] integerValue] == 4){
            //4黑白码查询界面
            [self requestBlackAndWhiteYards:code];
        }
        
    } orFailBlock:^(id error) {
        
    }];
}


//2彩码非验证查询
-(void)requestCodeNoVerificationQuery:(NSString *)fwCode{
    NSString *url = [NSString stringWithFormat:@"http://tyfwjk.ty-315.com/api/FW/QueryB?fwm=%@&ip=%@",fwCode, [TYDevice getIPAddress]];
    [TYNetworkRequest getRequestURL:url parameters:nil andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        //回到主线程
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            //打开连接
            LoadWebViewController *web = [[LoadWebViewController alloc] init];
            [web loadWebURLSring:[NSString stringWithFormat:@"%@%@",@"http://fw.ty1518.com/app/TempA/Show?fwm=",[respondObject objectForKey:@"FWCode"]]];
            TYNavigationViewController *nag = [[TYNavigationViewController alloc] initWithRootViewController:web];
            [self presentViewController:nag animated:YES completion:nil];
        }];
        
    } orFailBlock:^(id error) {
        
    }];
}

//4黑白码查询界面
-(void)requestBlackAndWhiteYards:(NSString *)fwCode{
    NSString *url = [NSString stringWithFormat:@"http://tyfwjk.ty-315.com/api/FW/QueryA?fwm=%@&ip=%@", fwCode, [TYDevice getIPAddress]];
    [TYNetworkRequest getRequestURL:url parameters:nil andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
       
        NFCVerificationQuery *nfcVc = [[NFCVerificationQuery alloc] init];
        nfcVc.resultStr = [respondObject objectForKey:@"ResultMsg"];
        TYNavigationViewController *nag = [[TYNavigationViewController alloc] initWithRootViewController:nfcVc];
        [self presentViewController:nag animated:YES completion:nil];
        
    } orFailBlock:^(id error) {
        
    }];
}

@end
