//
//  TYLoginViewController.m
//  美界联盟
//
//  Created by LY on 2017/10/26.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYLoginViewController.h"
#import "TYRegisterVC.h"
#import "TYTabBarViewController.h"
#import "TYMakerViewController.h"

@interface TYLoginViewController ()<UITextFieldDelegate>

//账号
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
//秘密
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
//记住密码图标
@property (weak, nonatomic) IBOutlet UIButton *memberBtn;
//注册button
@property (weak, nonatomic) IBOutlet UIButton *RegistBtn;
//登录提示
@property (weak, nonatomic) IBOutlet UILabel *HintLabel;

@end

@implementation TYLoginViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"RememberPassword"] integerValue] == 1) {
        //记住密码 去缓存赋值
        self.phoneTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneTextFieldText"];
        self.passwordTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"passwordTextFieldText"];
        self.memberBtn.selected = YES;
    }else{
        self.phoneTextField.text = nil;
        self.passwordTextField.text =nil;
        self.memberBtn.selected = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    if (self.type == 1) {
        [self setNavigationBarTitle:@"消费者登录" andTitleColor:[UIColor whiteColor] andImage:nil];
        self.HintLabel.hidden = YES;
    }else{
        [self setNavigationBarTitle:@"分销商登录" andTitleColor:[UIColor whiteColor] andImage:nil];
        self.RegistBtn.hidden = YES;
    }
    
    [self setTextField:self.phoneTextField];
    [self setTextField:self.passwordTextField];
}

#pragma mark 设置textField 样式
-(void)setTextField:(UITextField *)textField{
    UIColor * color = [UIColor grayColor];
    textField.tintColor = color;
    [textField setValue:color forKeyPath:@"_placeholderLabel.textColor"];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark -- <UITextFieldDelegate>
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //按下Done按钮的调用方法，让键盘消失
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -- 登录
-(IBAction)ClickLogin{
    if (self.phoneTextField.text.length == 0) {
        [TYShowHud showHudErrorWithStatus:@"请输入手机号"];
        return;
    }
    if (self.passwordTextField.text.length == 0) {
        [TYShowHud showHudErrorWithStatus:@"请输入密码"];
        return;
    }
    [self requestLogin];
    [self.view endEditing:YES];
}


#pragma mark -- 记住密码
-(IBAction)RememberPassword:(UIButton *)btn{
    [self.view endEditing:YES];
    self.memberBtn.selected = !self.memberBtn.selected;
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"RememberPassword"];
    if (self.memberBtn.selected) {//记住密码
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"RememberPassword"];
        
    }else{//不记住
        [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"RememberPassword"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

#pragma mark -- 去注册
- (IBAction)GoRegistration {
    [self.view endEditing:YES];
    TYRegisterVC *registerVC = [[TYRegisterVC alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

//15322380032
#pragma mark -- 网络请求
-(void)requestLogin{
    //设置hud
    [TYShowHud showHud];
    
    TYTabBarViewController *tabBarController = (TYTabBarViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    NSMutableArray *tabbarViewControllers = [NSMutableArray arrayWithArray: [tabBarController viewControllers]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *url;
    
    params[@"a"] = self.phoneTextField.text;
    params[@"b"] = self.passwordTextField.text;
    params[@"c"] = @"1";//PID 默认传1 具体什么意思你可以问一下后台
    
    if (self.type == 1) {//消费者登录参数
        url = [NSString stringWithFormat:@"%@MAPI/SM/SMLogin",APP_REQUEST_URL];
    }else{//分销商登录参数
        
        params[@"version"] = @"2.0.0.0";//每次提交审核问一下后台把 记住啦 老铁
        url = [NSString stringWithFormat:@"%@mapi/msys/Mlogin",APP_REQUEST_URL];
    }
    
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            //登录成功发送通知刷新商城数据
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshShopData" object:nil];
            
            //每日增加积分 通知
             [[NSNotificationCenter defaultCenter] postNotificationName:EVERYDAYONLYCALLONCE object:nil];
            
            [[NSUserDefaults standardUserDefaults] setObject:self.phoneTextField.text forKey:@"phoneTextFieldText"];
            if (self.memberBtn.selected == YES) {
                [[NSUserDefaults standardUserDefaults] setObject:self.passwordTextField.text forKey:@"passwordTextFieldText"];
            }
            
//            if (self.type == 1) {//消费者登录
//                //清空分销商的登录信息
//                [TYLoginModel cleanUserLoginAllMessage];
//                //保存消费者的登录信息
//                [TYConsumerLoginModel saveAccount:[respondObject objectForKey:@"c"]];
//
//                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"consumer"];
//                [[TYSingleton shareSingleton] setConsumer:1];
//                [[NSUserDefaults standardUserDefaults] setInteger:[TYSingleton shareSingleton].consumer forKey:@"consumer"];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//
//                //隐藏创客
//                if (tabbarViewControllers.count == 4) {
//                    [tabbarViewControllers removeObjectAtIndex:2];
//                }else{
//                    //此处表示已隐藏无需再隐藏了
//                }
            
//            }else{
                //清空消费者的登录信息
//                [TYConsumerLoginModel cleanUserLoginAllMessage];
                //保存分销商的信息
                [TYLoginModel saveAccount:[respondObject objectForKey:@"c"]];
                
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"consumer"];
                [[TYSingleton shareSingleton] setConsumer:2];
                [[NSUserDefaults standardUserDefaults] setInteger:[TYSingleton shareSingleton].consumer forKey:@"consumer"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
//                if (tabbarViewControllers.count == 4) {
//                    //如果创客没有被删除就无需添加了
//                }else{
//                    TYMakerViewController *makerVc = [[TYMakerViewController alloc] init];
//                    //包装一个导航控制器
//                    TYNavigationViewController *homeNavController = [[TYNavigationViewController alloc] initWithRootViewController:makerVc];
//
//                    [tabBarController upChildVc:homeNavController title:@"创客" image:@"maker" selectedImage:@"maker_Selected"];
//                    [tabbarViewControllers insertObject:homeNavController atIndex:2];
//                }
//            }
//            [tabBarController setViewControllers: tabbarViewControllers ];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
        
    } orFailBlock:^(id error) {
        [TYShowHud showHudErrorWithStatus:@"网络超时，请重新再试"];
    }];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshShopData" object:nil];
}

@end

