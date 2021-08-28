//
//  TYDistributorsAddressManagementVC.m
//  美界联盟
//
//  Created by LY on 2018/6/19.
//  Copyright © 2018年 刘燚. All rights reserved.
//

#import "TYDistributorsAddressManagementVC.h"
#import "CZHAddressPickerView.h"

@interface TYDistributorsAddressManagementVC ()

@property (weak, nonatomic) IBOutlet UILabel *province;
@property (weak, nonatomic) IBOutlet UILabel *city;
@property (weak, nonatomic) IBOutlet UILabel *area;
@property (weak, nonatomic) IBOutlet UITextView *addressTextView;

@end

@implementation TYDistributorsAddressManagementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"分销商个人地址管理" andTitleColor:[UIColor whiteColor] andImage:nil];
    [self requestGetcusdetail];
}

- (IBAction)ClickTheButton:(UIButton *)sender {
    
    [self.view endEditing:YES];
    if (sender.tag == 0) {
        
        [CZHAddressPickerView areaPickerViewWithProvince:self.province.text city:self.city.text area:self.area.text areaBlock:^(NSString *province, NSString *city, NSString *area) {
            self.province.text = province;
            self.city.text = city;
            self.area.text = area;
        }];
    }else{
        if ([self.province.text length] == 0) {
            [TYShowHud showHudErrorWithStatus:@"请输入选择地址"];
            return;
        }else if ([self.addressTextView.text length] == 0) {
            [TYShowHud showHudErrorWithStatus:@"请输入详细地址"];
            return;
        }else{
            [self requestUpdatecus];
        }
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark -- 网络请求
//经销中心-用户管理-获取分销商详细信息
-(void)requestGetcusdetail{
    [TYShowHud showHud];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = @([TYLoginModel getPrimaryId]);//分销商ID
    
    NSString *url = [NSString stringWithFormat:@"%@mapi/mcus/getcusdetail",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            
            self.province.text = [NSString stringWithFormat:@"%@",[TYValidate IsNotNull: [[respondObject objectForKey:@"c"] objectForKey:@"addp"]]];
            self.city.text = [NSString stringWithFormat:@"%@",[TYValidate IsNotNull: [[respondObject objectForKey:@"c"] objectForKey:@"addc"]]];
            self.area.text = [NSString stringWithFormat:@"%@",[TYValidate IsNotNull: [[respondObject objectForKey:@"c"] objectForKey:@"adda"]]];
            self.addressTextView.text = [NSString stringWithFormat:@"%@",[TYValidate IsNotNull: [[respondObject objectForKey:@"c"] objectForKey:@"addd"]]];
        }else{
            [TYShowHud showHudSucceedWithStatus:[respondObject objectForKey:@"b"]];
        }
    } orFailBlock:^(id error) {
        
    }];
}

-(void)requestUpdatecus{
    [TYShowHud showHud];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = @([TYLoginModel getPrimaryId]);//分销商ID
    params[@"i"] = self.province.text;
    params[@"j"] = self.city.text;
    params[@"k"] = self.area.text;
    params[@"l"] = self.addressTextView.text;
    
    NSString *url = [NSString stringWithFormat:@"%@mapi/mcus/updatecus",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            [TYShowHud showHudSucceedWithStatus:@"修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [TYShowHud showHudSucceedWithStatus:[respondObject objectForKey:@"b"]];
        }
    } orFailBlock:^(id error) {
        
    }];
}

@end
