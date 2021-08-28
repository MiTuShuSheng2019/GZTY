//
//  TYUpgradeApplyVC.m
//  美界联盟
//
//  Created by LY on 2018/11/11.
//  Copyright © 2018 刘燚. All rights reserved.
//

#import "TYUpgradeApplyVC.h"

@interface TYUpgradeApplyVC ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textTextView;
/** 给textView添加占位 */
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;

@end

@implementation TYUpgradeApplyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"升级申请" andTitleColor:[UIColor whiteColor] andImage:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma <UITextViewdDelegate>
-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    _placeholderLabel.hidden = YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    
    if (_textTextView.text.length != 0) {
        _placeholderLabel.hidden = YES;
    }else{
        _placeholderLabel.hidden = NO;
    }
}

#pragma mark -- 申请
- (IBAction)ClickApply {
    
    if ([self.textTextView.text length] == 0) {
        [TYShowHud showHudErrorWithStatus:@"请填写申请理由"];
        return;
    }
    
    [self requestUpgradeApply];
    
}

#pragma mark -- 网络请求
//升级申请
-(void)requestUpgradeApply{
    [TYShowHud showHud];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"CusID"] = @([TYLoginModel getPrimaryId]);
    params[@"describe"] = self.textTextView.text;
    
    NSString *url = [NSString stringWithFormat:@"%@SAPI/User/UpgradeApply",APP_REQUEST_URL];
    __weak typeof(&*self)weakSelf = self;
    
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        if ([[respondObject objectForKey:@"Status"] boolValue] == true) {
           
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        [TYShowHud showHudSucceedWithStatus:[respondObject objectForKey:@"Msg"]];
        
    } orFailBlock:^(id error) {
        [TYShowHud showHudErrorWithStatus:@"接口请求失败"];
    }];
}



@end
