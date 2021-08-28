//
//  TYNewShippingAddressVC.m
//  美界联盟
//
//  Created by LY on 2017/11/9.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYNewShippingAddressVC.h"
#import "CZHAddressPickerView.h"
#import "AddressPickerHeader.h"

@interface TYNewShippingAddressVC ()<UITextViewDelegate>

/** 给textView添加占位 */
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
//详细地址
@property (weak, nonatomic) IBOutlet UITextView *textTextView;
//联系人
@property (weak, nonatomic) IBOutlet UITextField *ContactTextField;
//手机号
@property (weak, nonatomic) IBOutlet UITextField *PhoneTextField;
//邮编
@property (weak, nonatomic) IBOutlet UITextField *PostcodeTextField;
//选择省
@property (weak, nonatomic) IBOutlet UITextField *provinceTextField;
//选择市
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
//选择县区
@property (weak, nonatomic) IBOutlet UITextField *zoneTextField;
/** 是否是默认地址 1否，2是 */
@property (nonatomic, assign) NSInteger isDefaultAddress;
//默认地址按钮
@property (weak, nonatomic) IBOutlet UISwitch *DefaultAddressSwitch;

@end

@implementation TYNewShippingAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"新增收货地址" andTitleColor:[UIColor whiteColor] andImage:nil];
    
    if (self.type == 1) {
        //表示编辑
        self.ContactTextField.text = self.model.dc;
        self.PhoneTextField.text = self.model.dd;
        self.provinceTextField.text = self.model.de;
        self.cityTextField.text = self.model.df;
        self.zoneTextField.text = self.model.dl;
        self.PostcodeTextField.text = self.model.dk;
        self.textTextView.text = self.model.dg;
        if (self.model.dh == 2) {
            //是否默认1不是 2 是
            self.DefaultAddressSwitch.on = YES;
        }else{
            self.DefaultAddressSwitch.on = NO;
        }
        //赋值
        self.isDefaultAddress = self.model.dh;
        //隐藏占位Label
        _placeholderLabel.hidden = YES;
    }else{
        //新增地址
        //默认是设为默认地址
        self.isDefaultAddress = 2;
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark -- 选择地址
- (IBAction)ClickSelectAddress {
    [self.view endEditing:YES];
    [CZHAddressPickerView areaPickerViewWithAreaBlock:^(NSString *province, NSString *city, NSString *area) {
        
        self.provinceTextField.text = province;
        self.cityTextField.text = city;
        self.zoneTextField.text = area;
    }];
}

#pragma mark -- 设为默认
- (IBAction)ClickSetDefault:(UISwitch *)sender {
    sender.on = !sender.on;
    if (sender.on) {
        self.isDefaultAddress = 2;
    }else{
        self.isDefaultAddress = 1;
    }
}

#pragma mark -- 确定
- (IBAction)ClickDetermine {
    if (self.ContactTextField.text.length == 0) {
        [TYShowHud showHudErrorWithStatus:@"请输入联系人"];
        return;
    }
    if (self.PhoneTextField.text.length == 0) {
        [TYShowHud showHudErrorWithStatus:@"请输入手机号码"];
        return;
    }
    
    if (self.PhoneTextField.text.length != 11) {
        [TYShowHud showHudErrorWithStatus:@"手机号码输入有误"];
        return;
    }
    
    if (self.provinceTextField.text.length == 0 || self.cityTextField.text.length == 0 || self.zoneTextField.text.length == 0) {
        [TYShowHud showHudErrorWithStatus:@"请选择城市"];
        return;
    }
    
    if (self.textTextView.text.length == 0) {
        [TYShowHud showHudErrorWithStatus:@"请输入详细地址"];
        return;
    }
    
    if (self.type == 1) {
        //请求编辑接口
        [self requestEditCusAddress];
    }else{
        //请求新增接口
        [self requestAddCusAddress];
    }
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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark --- 网络请求
//53 经销中心 收货地址新增
-(void)requestAddCusAddress{
    [LoadManager showLoadingView:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *url;
    if ([TYSingleton shareSingleton].consumer == 1) {
        params[@"a"] = [TYConsumerLoginModel getSessionID];//回话session
        params[@"b"] = [TYConsumerLoginModel getPrimaryId];//用户id
        params[@"c"] = self.ContactTextField.text;//收货联系人
        params[@"d"] = self.PhoneTextField.text;//收货电话
        params[@"e"] = self.provinceTextField.text;//省份
        params[@"f"] = self.cityTextField.text;//城市
        params[@"g"] = self.zoneTextField.text;//区域
        params[@"h"] = self.textTextView.text;//详细地址
        params[@"i"] = self.PostcodeTextField.text;//邮政编码
        params[@"j"] = @(self.isDefaultAddress);//是否默认地址1否，2是
        params[@"k"] = @(1);//PID默认为1
        url = [NSString stringWithFormat:@"%@MAPI/SM/AddSMAddress",APP_REQUEST_URL];
    }else{
        params[@"a"] = [TYLoginModel getSessionID];//回话session
        params[@"b"] = self.ContactTextField.text;//收货联系人
        params[@"c"] = self.PhoneTextField.text;//收货电话
        params[@"d"] = self.provinceTextField.text;//省份
        params[@"e"] = self.cityTextField.text;//城市
        params[@"f"] = self.zoneTextField.text;//区域
        params[@"g"] = self.textTextView.text;//详细地址
        params[@"h"] = self.PostcodeTextField.text;//邮政编码
        params[@"i"] = @(self.isDefaultAddress);//是否默认地址1否，2是
        url = [NSString stringWithFormat:@"%@mapi/mcus/AddCusAddress",APP_REQUEST_URL];
    }
    
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"BackTYAddressManagementVC" object:nil];
        }else{
             [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
        [LoadManager hiddenLoadView];
    } orFailBlock:^(id error) {
        [LoadManager hiddenLoadView];
    }];
}

//54 经销中心 收货地址编辑
-(void)requestEditCusAddress{
    [LoadManager showLoadingView:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *url;
    if ([TYSingleton shareSingleton].consumer == 1) {
        params[@"a"] = [TYConsumerLoginModel getSessionID];//回话session
        params[@"b"] = @(self.model.da);//地址PKID
        params[@"c"] = self.ContactTextField.text;//收货联系人
        params[@"d"] = self.PhoneTextField.text;//收货电话
        params[@"e"] = self.provinceTextField.text;//省份
        params[@"f"] = self.cityTextField.text;//城市
        params[@"g"] = self.zoneTextField.text;//区域
        params[@"h"] = self.textTextView.text;//详细地址
        params[@"i"] = self.PostcodeTextField.text;//邮政编码
        params[@"j"] = @(self.isDefaultAddress);//是否默认地址1否，2是
        url = [NSString stringWithFormat:@"%@MAPI/SM/EditSMAddress",APP_REQUEST_URL];
    }else{
        params[@"a"] = [TYLoginModel getSessionID];//回话session
        params[@"b"] = self.ContactTextField.text;//收货联系人
        params[@"c"] = self.PhoneTextField.text;//收货电话
        params[@"d"] = self.provinceTextField.text;//省份
        params[@"e"] = self.cityTextField.text;//城市
        params[@"f"] = self.zoneTextField.text;//区域
        params[@"g"] = self.textTextView.text;//详细地址
        params[@"h"] = self.PostcodeTextField.text;//邮政编码
        params[@"i"] = @(self.isDefaultAddress);//是否默认地址1否，2是
        params[@"j"] = @(self.model.da);//PKID
        url = [NSString stringWithFormat:@"%@mapi/mcus/EditCusAddress",APP_REQUEST_URL];
    }
    
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"BackTYAddressManagementVC" object:nil];
        }else{
             [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
        [LoadManager hiddenLoadView];
    } orFailBlock:^(id error) {
        [LoadManager hiddenLoadView];
    }];
}

@end
