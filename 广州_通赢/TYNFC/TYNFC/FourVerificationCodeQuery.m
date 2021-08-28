//
//  FourVerificationCodeQuery.m
//  TYNFC
//
//  Created by LY on 2018/1/15.
//  Copyright © 2018年 刘燚. All rights reserved.
//

#import "FourVerificationCodeQuery.h"
#import "NFCVerificationQuery.h"

@interface FourVerificationCodeQuery ()
//防伪码
@property (weak, nonatomic) IBOutlet UITextField *fwCodeTextField;
//验证码
@property (weak, nonatomic) IBOutlet UITextField *crCodeTextField;

@end

@implementation FourVerificationCodeQuery

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNavigationBackBtn:@"back"];
    
    [self setNavigationBarTitle:@"四位验证防伪查询" andTitleColor:[UIColor whiteColor] andImage:nil];
    
    self.fwCodeTextField.text = self.fwCode;
  
    
}

//返回按钮被点击时的动作。
- (void)navigationBackBtnClick:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark -- 点击查询
- (IBAction)ClickQuery {
    
    [self.view endEditing:YES];
    if (self.crCodeTextField.text.length == 0) {
        [TYShowHud showHudErrorWithStatus:@"请输入四位验证码"];
        return;
    }
    [self requestCodeVerificationQuery];
}

#pragma mark -- 网路请求
//1彩码验证查询---3验证码查询界面
-(void)requestCodeVerificationQuery{
    NSString *url = [NSString stringWithFormat:@"http://tyfwjk.ty-315.com/api/FW/QueryC?fwm=%@&v=%@&ip=%@",self.fwCode, self.crCodeTextField.text, [TYDevice getIPAddress]];
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
