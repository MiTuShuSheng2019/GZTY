//
//  TYQRCodeViewController.m
//  TYNFC
//
//  Created by LY on 2018/1/3.
//  Copyright © 2018年 刘燚. All rights reserved.
//

#import "TYQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "QRCodeAreaView.h"
#import "QRCodeBacgrouView.h"
#import "UIView+Extension.h"

@interface TYQRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>{
    AVCaptureSession * session;//输入输出的中间桥梁
    QRCodeAreaView *_areaView;//扫描区域视图
}

@end

@implementation TYQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];
    
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        //用户关闭了相机权限
//        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"应用相机权限受限,请在设置中启用" preferredStyle:UIAlertControllerStyleAlert];
//
//        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            [self.navigationController popViewControllerAnimated:YES];
//        }];
//
//        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            // 无权限 引导去开启
//            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//
//            if ([[UIApplication sharedApplication] canOpenURL:url]) {
//
//                [[UIApplication sharedApplication] openURL:url];
//            }
//        }];
//
//        [alertVc addAction:action1];
//        [alertVc addAction:action2];
//        [self presentViewController:alertVc animated:YES completion:nil];
        
        [TYShowHud showHudErrorWithStatus:@"相机权限未开启无法扫描，请在设置中开启"];
        return;
    }
    
    /**
     *  初始化二维码扫描
     */
    
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //设置识别区域
    //深坑，这个值是按比例0~1设置，而且X、Y要调换位置，width、height调换位置
    output.rectOfInterest = CGRectMake(_areaView.y/KScreenHeight, _areaView.x/KScreenWidth, _areaView.size.height/KScreenHeight, _areaView.size.width/KScreenWidth);
    
    //初始化链接对象
    session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [session addInput:input];
    [session addOutput:output];
    
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.view.layer.bounds;
    
    [self.view.layer insertSublayer:layer atIndex:0];
    
    //开始捕获
    [session startRunning];
}

-(void)setUpView{
    //扫描区域
    CGRect areaRect = CGRectMake((KScreenWidth - 218)/2, (KScreenHeight - 218)/2, 218, 218);
    
    //半透明背景
    QRCodeBacgrouView *bacgrouView = [[QRCodeBacgrouView alloc]initWithFrame:self.view.bounds];
    bacgrouView.scanFrame = areaRect;
    [self.view addSubview:bacgrouView];
    
    //设置扫描区域
    _areaView = [[QRCodeAreaView alloc]initWithFrame:areaRect];
    [self.view addSubview:_areaView];
    
    //提示文字
    UILabel *label = [UILabel new];
    label.text = @"将二维码放入框内，即开始扫描";
    label.textColor = [UIColor whiteColor];
    label.y = CGRectGetMaxY(_areaView.frame) + 20;
    [label sizeToFit];
    label.center = CGPointMake(_areaView.center.x, label.center.y);
    [self.view addSubview:label];
    
    //返回键
    UIButton *backbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    backbutton.frame = CGRectMake(12, 26, 35, 35);
    [backbutton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backbutton addTarget:self action:@selector(clickBackButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backbutton];
}

#pragma 二维码扫描的回调
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        [session stopRunning];//停止扫描
        [_areaView stopAnimaion];//暂停动画
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        
        
        //通知传值
//        NSNotification *not = [[NSNotification alloc] initWithName:@"backTYAuthorizationQueryViewController" object:nil userInfo:@{@"metadataObject":metadataObject.stringValue}];
//        [[NSNotificationCenter defaultCenter] postNotification:not];
//        [self dismissViewControllerAnimated:YES completion:nil];
        
        //打开连接
        NSString *strUrl = metadataObject.stringValue;
//        LoadWebViewController *web = [[LoadWebViewController alloc] init];
//        [web loadWebURLSring:[NSString stringWithFormat:@"%@%@",@"http://fw.ty1518.com/app/TempA/Show?fwm=",strUrl]];
//        TYNavigationViewController *nag = [[TYNavigationViewController alloc] initWithRootViewController:web];
//        [self presentViewController:nag animated:YES completion:nil];
        
        [self requestCodeTepy:strUrl];
        //输出扫描字符串
        //        NSLog(@"%@",metadataObject.stringValue);
    }
}

//点击返回按钮回调
-(void)clickBackButton{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark -- 网络请求
//请求条码类型
-(void)requestCodeTepy:(NSString *)code{
    NSString *url = [NSString stringWithFormat:@"http://tyfwjk.ty-315.com/api/fw/type?code=%@&ip=%@",code,[TYDevice getIPAddress]];
    [TYNetworkRequest getRequestURL:url parameters:nil andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        if ([[respondObject objectForKey:@"Status"] integerValue] == 1 || [[respondObject objectForKey:@"Status"] integerValue] == 3) {
            //1彩码验证查询 //3验证码查询界面
            [self requestCodeVerificationQuery:code];
            
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

//1彩码验证查询---3验证码查询界面
-(void)requestCodeVerificationQuery:(NSString *)fwCode{
    NSString *url = [NSString stringWithFormat:@"http://tyfwjk.ty-315.com/api/FW/QueryC?fwm=%@&v=%@&ip=%@",fwCode, fwCode, [TYDevice getIPAddress]];
    [TYNetworkRequest getRequestURL:url parameters:nil andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        //        if ([[respondObject objectForKey:@"Status"] isEqualToString:@"4"]){
        //
        //
        //        }
        
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
        
        //        if ([[respondObject objectForKey:@"Status"] isEqualToString:@"4"]){
        //
        //
        //        }
        
    } orFailBlock:^(id error) {
        
    }];
}


@end
