//
//  TYAuthorizationQueryViewController.m
//  美界联盟
//
//  Created by LY on 2017/11/7.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYAuthorizationQueryViewController.h"
#import "TYAuthorizationView.h"
#import "TYQRCodeViewController.h"

@interface TYAuthorizationQueryViewController ()
//条形码按钮
@property (weak, nonatomic) IBOutlet UIButton *BarCodeBtn;
//手机号或微信号按钮
@property (weak, nonatomic) IBOutlet UIButton *numberBtn;
//扫码按钮
@property (weak, nonatomic) IBOutlet UIButton *scanBtn;
//扫码按钮的宽
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scanBtnW;

@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

/** <#注释#> */
@property (nonatomic, assign) NSInteger selectedTepy;
@end

@implementation TYAuthorizationQueryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"授权查询" andTitleColor:[UIColor whiteColor] andImage:nil];
    
    self.selectedTepy = 1;
    //添加默认状态
    self.BarCodeBtn.backgroundColor = RGB(20, 132, 240);
    [self.BarCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.numberBtn.backgroundColor = RGB(226, 226, 226);
    [self.numberBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    //接收通知传值
    NSNotificationCenter * center =[NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(RefreshCodeTextFieldData:) name:@"backTYAuthorizationQueryViewController" object:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)RefreshCodeTextFieldData:(NSNotification *)not{
    self.codeTextField.text = [not.userInfo objectForKey:@"metadataObject"];
}

#pragma mark -- 条码查询
- (IBAction)ClickBarCodeQuery:(UIButton *)sender {
    self.BarCodeBtn.backgroundColor = RGB(20, 132, 240);
    [self.BarCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.numberBtn.backgroundColor = RGB(226, 226, 226);
    [self.numberBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.codeTextField.placeholder = @"请扫描或输入条码";
    self.scanBtn.hidden = NO;
    self.scanBtnW.constant = 40;
    self.selectedTepy = 1;
}

#pragma mark -- 手机号或微信号查询
- (IBAction)ClickMobilePhoneNumberAndWeiXin:(UIButton *)sender {
    self.numberBtn.backgroundColor = RGB(20, 132, 240);
    [self.numberBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.BarCodeBtn.backgroundColor = RGB(226, 226, 226);
    [self.BarCodeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.codeTextField.placeholder = @"请输入手机号或微信号";
    self.scanBtn.hidden = YES;
    self.scanBtnW.constant = 0;
    self.selectedTepy = 2;
}

#pragma mark -- 扫码
- (IBAction)ClickScan:(UIButton *)sender {
    [self.view endEditing:YES];
    TYQRCodeViewController *qrVc = [[TYQRCodeViewController alloc] init];
    [self.navigationController pushViewController:qrVc animated:YES];
}

#pragma mark -- 查询
- (IBAction)ClickEnquiries {
    [self.view endEditing:YES];
    if (self.codeTextField.text.length == 0) {
        [TYShowHud showHudErrorWithStatus:@"输入的内容不能为空"];
        return;
    }
    
    [self requestGetTYCertificate];
}

#pragma mark -- 网络请求
//59 经销中心 获取授权证书
-(void)requestGetTYCertificate{
    [LoadManager showLoadingView:self.view];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    if (self.selectedTepy == 1) {
        params[@"b"] = self.codeTextField.text;//条码小标
    }else{
        params[@"c"] = self.codeTextField.text;// tel或者微信
    }
    
    NSString *url = [NSString stringWithFormat:@"%@mapi/mcus/GetTYCertificate",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            
            //处理回文
            NSString *encodedImageStr = [respondObject objectForKey:@"c"];
            NSRange range = [encodedImageStr rangeOfString:@"base64,"];
            encodedImageStr = [encodedImageStr substringFromIndex:range.location+range.length];
            NSData *imageData = [[NSData alloc]
                                 initWithBase64EncodedString:encodedImageStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *image = [UIImage imageWithData:imageData];
            
            [TYShowHud showHudSucceedWithStatus:@"查询成功"];
            
            TYAuthorizationView *screeView = [TYAuthorizationView CreatTYAuthorizationView];
            screeView.isRequest = NO;
            screeView.AuthorizationImageView.image = image;
            screeView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [window addSubview:screeView];
            
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
        [LoadManager hiddenLoadView];
    } orFailBlock:^(id error) {
        [LoadManager hiddenLoadView];
    }];
}

@end
