//
//  TYShipingEditViewController.m
//  美界联盟
//
//  Created by LY on 2017/11/14.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYShipingEditViewController.h"
#import "TYQRCodeViewController.h"
#import "TYLogisticsModel.h"

@interface TYShipingEditViewController ()<UITextFieldDelegate>
//流水号
@property (weak, nonatomic) IBOutlet UILabel *numberOderLabel;
//代理商
@property (weak, nonatomic) IBOutlet UILabel *agentLabel;
//收货人
@property (weak, nonatomic) IBOutlet UITextField *ReceiveGoodsField;
//电话号码
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
//收货地址
@property (weak, nonatomic) IBOutlet UITextField *addressField;
//物流公司
@property (weak, nonatomic) IBOutlet UITextField *LogisticsCompanyField;
//快递单号
@property (weak, nonatomic) IBOutlet UITextField *CourierNumberField;
/** 快递名称数组 */
@property (nonatomic, strong) NSMutableArray *CourierArr;
/** 快递主键id数组 */
@property (nonatomic, strong) NSMutableArray *CourierIDArr;

@end

@implementation TYShipingEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"编辑" andTitleColor:[UIColor whiteColor] andImage:nil];
    
    [self setNavigationRightBtnText:@"保存" andTextColor:[UIColor whiteColor]];
    
    //请求快递公司
    [self requestGetConSheetType];
    
    self.numberOderLabel.text = self.model.eb;
    self.agentLabel.text = self.model.ec;
    self.ReceiveGoodsField.text = self.model.eh;
    self.phoneField.text = self.model.ed;
    self.addressField.text = self.model.ei;
    self.LogisticsCompanyField.text = self.model.ej;
    self.CourierNumberField.text = self.model.ek;
    
    self.LogisticsCompanyField.delegate = self;
    //接收通知传值
    NSNotificationCenter * center =[NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(RefreshCodeTextFieldData:) name:@"backTYAuthorizationQueryViewController" object:nil];
    
}

-(void)RefreshCodeTextFieldData:(NSNotification *)not{
    self.CourierNumberField.text = [not.userInfo objectForKey:@"metadataObject"];
}

//导航栏右边按钮被按下的触发事件
- (void)navigationRightBtnClick:(UIButton *)btn{
    [self.view endEditing:YES];
    
    if (self.ReceiveGoodsField.text.length == 0) {
        [TYShowHud showHudErrorWithStatus:@"请填写联系人"];
        return;
    }
    
    if (self.addressField.text.length == 0) {
        [TYShowHud showHudErrorWithStatus:@"请填写收货地址"];
        return;
    }
    
    if (self.phoneField.text.length == 0) {
        [TYShowHud showHudErrorWithStatus:@"请填写联系人电话"];
        return;
    }
    
    if (self.LogisticsCompanyField.text.length == 0) {
        [TYShowHud showHudErrorWithStatus:@"请选择快递公司"];
        return;
    }
    
    if (self.CourierNumberField.text.length == 0) {
        [TYShowHud showHudErrorWithStatus:@"请填写快递单号"];
        return;
    }
    
    [self requestEditOutStorage];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark -- <UITextFieldDelegate>
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.LogisticsCompanyField) {
        [self.view endEditing:YES];
        
        LTPickerView* pickerView = [LTPickerView new];
        
        pickerView.dataSource = self.CourierArr;//设置要显示的数据
        
        [pickerView show];//显示
        //回调block
        pickerView.block = ^(LTPickerView* obj,NSString* str,int num){
            
            self.LogisticsCompanyField.text = str;
        };
    }
    return NO;
}


#pragma mark -- 扫描快递单号
- (IBAction)ClickScan {
    [self.view endEditing:YES];
    TYQRCodeViewController *qrVc = [[TYQRCodeViewController alloc] init];
    [self.navigationController pushViewController:qrVc animated:YES];
}

#pragma mark --- 网络请求
//37 经销中心-发货管理-发货-获取托运单类型(快递公司)
-(void)requestGetConSheetType{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = @(1);//页码
    params[@"c"] = @(100);//页大小
    params[@"d"] = @"";//根据字典名称获取字典编码此处传空
    
    NSString *url = [NSString stringWithFormat:@"%@mapi/mpsi/GetConSheetType",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            
            NSArray *arr = [TYLogisticsModel mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"e"]];
            [self.modelArray addObjectsFromArray:arr];
            
            for (TYLogisticsModel *model in self.modelArray) {
                
                [self.CourierArr addObject:model.eb];
                [self.CourierIDArr addObject:model.ea];
            }
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
    } orFailBlock:^(id error) {
        
    }];
}

//32 经销中心-发货管理-发货-修改出库信息
-(void)requestEditOutStorage{
    [LoadManager showLoadingView:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = self.model.ea;//出库ID
    params[@"c"] = self.ReceiveGoodsField.text;//收货联系人
    params[@"d"] = self.addressField.text;//收货地址
    params[@"e"] = self.phoneField.text;//收货联系人电话
    params[@"f"] = self.LogisticsCompanyField.text;//托运类型
    params[@"g"] = self.CourierNumberField.text;//托运单号
    params[@"h"] = @"";//备注
    
    NSString *url = [NSString stringWithFormat:@"%@mapi/mpsi/EditOutStorage",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
        [LoadManager hiddenLoadView];
    } orFailBlock:^(id error) {
        [LoadManager hiddenLoadView];
    }];
}
#pragma mark -- 懒加载
- (NSMutableArray *) CourierArr
{
    if (!_CourierArr) {
        _CourierArr = [NSMutableArray array];
    }
    return _CourierArr;
}

- (NSMutableArray *) CourierIDArr
{
    if (!_CourierIDArr) {
        _CourierIDArr = [NSMutableArray array];
    }
    return _CourierIDArr;
}
@end
