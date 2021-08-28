//
//  TYRegisterVC.m
//  美界联盟
//
//  Created by LY on 2017/11/27.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYRegisterVC.h"

@interface TYRegisterVC ()

@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *againPasswordField;

@end

@implementation TYRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"注册" andTitleColor:[UIColor whiteColor] andImage:nil];
}

- (IBAction)ClickRegister {
    [self.view endEditing:YES];
    
    if (self.userNameField.text.length == 0) {
        [TYShowHud showHudErrorWithStatus:@"请输入用户名"];
        return;
    }
    
    if (self.phoneField.text.length != 11) {
        [TYShowHud showHudErrorWithStatus:@"请输入正确的手机号"];
        return;
    }
    
    if (self.passwordField.text.length == 0) {
        [TYShowHud showHudErrorWithStatus:@"请输入密码"];
        return;
    }
    
    if (self.passwordField.text.length < 6) {
        [TYShowHud showHudErrorWithStatus:@"密码至少为6位"];
        return;
    }
    
    if (self.againPasswordField.text.length == 0) {
        [TYShowHud showHudErrorWithStatus:@"请再次输入密码"];
        return;
    }
    
    if ([self.againPasswordField.text isEqualToString:self.passwordField.text]) {
        [self requestRegister];
    }else{
        [TYShowHud showHudErrorWithStatus:@"两次输入的密码不相同"];
    }
}

#pragma mark -- 网络请求
-(void)requestRegister{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"b"] = self.userNameField.text;//账户
    dic[@"c"] = self.passwordField.text;//密码
    dic[@"d"] = self.phoneField.text;//手机号码
    dic[@"e"] = @"2";//1：安卓；2：IOS；3：PC；4：微信
    NSString *url = [NSString stringWithFormat:@"%@MAPI/SM/SMRegister",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:dic andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {//成功
            [self.navigationController popViewControllerAnimated:YES];
            [TYShowHud showHudSucceedWithStatus:@"注册成功"];
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
        
    } orFailBlock:^(id error) {
        
    }];
}

@end
