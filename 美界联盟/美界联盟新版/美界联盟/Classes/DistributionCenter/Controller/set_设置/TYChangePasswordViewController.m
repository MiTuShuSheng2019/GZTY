//
//  TYChangePasswordViewController.m
//  美界联盟
//
//  Created by LY on 2017/11/9.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYChangePasswordViewController.h"
#import "TYLoginChooseViewController.h"

#define kMaxLength 6

@interface TYChangePasswordViewController ()<UITextFieldDelegate>
//原密码
@property (weak, nonatomic) IBOutlet UITextField *originalPasswordField;
//新密码
@property (weak, nonatomic) IBOutlet UITextField *NewPasswordField;
//确认新密码
@property (weak, nonatomic) IBOutlet UITextField *ConfirmNewPasswordField;
//文字提示说明
@property (weak, nonatomic) IBOutlet UILabel *instructionLabel;

@end

@implementation TYChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    NSString *title;
    if (self.type == 1) {
        title = @"修改登录密码";
    }else{
        title = @"修改交易密码";
        self.instructionLabel.text = @"交易密码的长度为6位";
        self.originalPasswordField.keyboardType = UIKeyboardTypeNumberPad;
        self.NewPasswordField.keyboardType = UIKeyboardTypeNumberPad;
        self.ConfirmNewPasswordField.keyboardType = UIKeyboardTypeNumberPad;
        self.originalPasswordField.delegate = self;
        self.NewPasswordField.delegate = self;
        self.ConfirmNewPasswordField.delegate = self;
    }
    [self setNavigationBarTitle:title andTitleColor:[UIColor whiteColor] andImage:nil];
    
    self.originalPasswordField.secureTextEntry = YES;
    self.NewPasswordField.secureTextEntry = YES;
    self.ConfirmNewPasswordField.secureTextEntry = YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark -- 确认提交
- (IBAction)ClickConfirm {
    [self.view endEditing:YES];
    
    //如果是支付验证原密码是否输入正确
    if (self.type == 2 && [[TYLoginModel getPayPassword] isEqualToString:self.originalPasswordField.text] == NO) {
        [TYShowHud showHudErrorWithStatus:@"原密码输入错误"];
        return;
    }
    //以下统一判断
    if (self.originalPasswordField.text.length == 0 || self.NewPasswordField.text.length == 0 || self.ConfirmNewPasswordField.text.length == 0) {
        [TYShowHud showHudErrorWithStatus:@"密码不能为空"];
        return;
    }
    
    if (self.type == 1) {
        if (self.originalPasswordField.text.length < 6 ||self.NewPasswordField.text.length < 6 || self.ConfirmNewPasswordField.text.length < 6) {
            [TYShowHud showHudErrorWithStatus:@"密码长度至少为6位"];
            return;
        }
    }else{
        if (self.originalPasswordField.text.length != 6 ||self.NewPasswordField.text.length != 6 || self.ConfirmNewPasswordField.text.length != 6) {
            [TYShowHud showHudErrorWithStatus:@"密码长度为6位"];
            return;
        }
    }
    
    if ([self.NewPasswordField.text isEqualToString:self.ConfirmNewPasswordField.text] == NO) {
        [TYShowHud showHudErrorWithStatus:@"新密码确认有误"];
        
    }else{
        if (self.type == 1) {
            [self requestUpdatepwd];
        }else{
            [self requestChangePayPassword];
        }
    }
}

#pragma mark -- <UITextFieldDelegate>
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (toBeString.length > kMaxLength && range.length!=1){
        textField.text = [toBeString substringToIndex:kMaxLength];
        [TYShowHud showHudErrorWithStatus:@"交易密码的长度为6位"];
        return NO;
        
    }
    return YES;
}

#pragma mark --- 网络请求
//6 经销中心-用户管理-修改登录密码
-(void)requestUpdatepwd{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *url;
    if ([TYSingleton shareSingleton].consumer == 1) {
        params[@"a"] = [TYConsumerLoginModel getSessionID];//回话session
        params[@"b"] = [TYConsumerLoginModel getPrimaryId];//用户名
        url = [NSString stringWithFormat:@"%@MAPI/SM/SMUpdatePwd",APP_REQUEST_URL];
    }else{
        params[@"a"] = [TYLoginModel getSessionID];//回话session
        params[@"b"] = [TYLoginModel getUserName];//用户名
        url = [NSString stringWithFormat:@"%@mapi/msys/updatepwd",APP_REQUEST_URL];
    }
    params[@"c"] = self.originalPasswordField.text;//旧密码
    params[@"d"] = self.NewPasswordField.text;//新密码
    
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            
            //如果是修改登录密码重新登录
            [TYLoginModel cleanUserLoginAllMessage];
            [self.navigationController pushViewController:[[TYLoginChooseViewController alloc] init] animated:YES];
            [TYShowHud showHudSucceedWithStatus:@"修改成功请重新登录"];
            
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
        
    } orFailBlock:^(id error) {
        [TYShowHud showHudErrorWithStatus:@"网络连接失败"];
    }];
}

//58 经销中心 修改支付密码
-(void)requestChangePayPassword{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = self.NewPasswordField.text;//新密码
    params[@"c"] = self.originalPasswordField.text;//原密码
    
    NSString *url = [NSString stringWithFormat:@"%@mapi/mcus/ChangePayPassword",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            //保存支付密码
            [TYLoginModel savePayPassword:self.NewPasswordField.text];
            [TYShowHud showHudSucceedWithStatus:@"修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
    } orFailBlock:^(id error) {
        
    }];
}
@end
