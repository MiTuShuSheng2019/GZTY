//
//  DEConversionIntegralViewController.m
//  美界联盟
//
//  Created by Glory_iMac on 2019/9/11.
//  Copyright © 2019 刘燚. All rights reserved.
//

#import "DEConversionIntegralViewController.h"

@interface DEConversionIntegralViewController ()

@property (weak, nonatomic) IBOutlet UILabel* jbLabel;//金币
@property (weak, nonatomic) IBOutlet UILabel* ybLabel;//银币
@property (weak, nonatomic) IBOutlet UILabel* blLabei;//比例
@property (weak, nonatomic) IBOutlet UISegmentedControl* segmentedC;//
@property (weak, nonatomic) IBOutlet UITextField* jbTF;//金币
@property (weak, nonatomic) IBOutlet UITextField* ybTF;//银币

@property (nonatomic, strong) NSDictionary *params;

@end

@implementation DEConversionIntegralViewController
{
    NSInteger _ratio;
    NSInteger _jb;
    NSInteger _yb;
    NSString* _type;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(238, 238, 238);
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"积分转换" andTitleColor:[UIColor whiteColor] andImage:nil];
    self.segmentedC.selectedSegmentIndex = 0;
    _type = @"金换银";
    _jb = 0;
    _yb = 0;
    _ratio = 0;
    self.jbTF.userInteractionEnabled = YES;
    self.ybTF.userInteractionEnabled = NO;
    [self.jbTF addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    [self.ybTF addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    
    [self requestData];
    
}

- (void)requestData{
    
    NSDictionary* p =[NSDictionary dictionary];
    
    NSString* phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneTextFieldText"];
    if (!phone) {
        phone = @"";
    }
    
    p = @{@"a":phone,
          @"b":@(1),
          };
    
    NSString* url =[NSString stringWithFormat:@"%@mapi/Intergral/MGetExchangeRecordByUser",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:p andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            NSDictionary* c = [respondObject objectForKey:@"c"];
            _params = c;
            [self setTextUI];
        }else{
//            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
    } orFailBlock:^(id error) {
    }];
}

-(void)setTextUI
{
    self.jbLabel.text = [NSString stringWithFormat:@"金币：%@",_params[@"k"]];
    self.ybLabel.text = [NSString stringWithFormat:@"银币：%@",_params[@"i"]];
    self.blLabei.text = [NSString stringWithFormat:@"比例：1金币 = %@银币",_params[@"ratio"]];
}

-(IBAction)conversionBtnClick:(id)sender
{
    if (_jb == 0 && _yb == 0) return;
    
    if (_yb % _ratio != 0) {
        [TYShowHud showHudErrorWithStatus:[NSString stringWithFormat:@"请输入%ld的整数倍",_ratio]];
        return;
    }
    
    NSDictionary* p =[NSDictionary dictionary];
    
    NSString* phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneTextFieldText"];
    if (!phone) {
        phone = @"";
    }
    
    p = @{@"UserCode":phone,
          @"兑换人":_params[@"h"],
          @"手机号":phone,
          @"备注":@"1",
          @"金币兑换数量":[NSString stringWithFormat:@"%ld",_jb],
          @"兑换类型":_type,
          @"银币兑换数量":[NSString stringWithFormat:@"%ld",_yb],
          };
    
    NSString* url =[NSString stringWithFormat:@"%@mapi/金币兑换/金币兑换",APP_REQUEST_URL];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [TYNetworking postRequestURL:url parameters:p andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            [TYShowHud showHudSucceedWithStatus:[respondObject objectForKey:@"b"]];
            [self requestData];
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
    } orFailBlock:^(id error) {
    }];
}

#pragma mark -给每个textfield添加事件，只要值改变就调用此函数
-(void)changedTextField:(UITextField*)textField
{
    _ratio = [_params[@"ratio"] integerValue];
    
    if (textField == self.jbTF) {
        _jb = [textField.text integerValue];
        if (_jb > [_params[@"k"] integerValue]) {
            [TYShowHud showHudErrorWithStatus:@"不能超过现有金币"];
            _jb = [_params[@"k"] integerValue];
            self.jbTF.text = [NSString stringWithFormat:@"%ld",_jb];
        }
        _yb = _jb * _ratio;
        self.ybTF.text = [NSString stringWithFormat:@"%ld",_yb];
    } else {
        _yb = [textField.text integerValue];
        if (_yb > [_params[@"i"] integerValue]) {
            [TYShowHud showHudErrorWithStatus:@"不能超过现有银币"];
            _yb = [_params[@"i"] integerValue];
            self.ybTF.text = [NSString stringWithFormat:@"%ld",_yb];
        }
        _jb = _yb / _ratio;
        self.jbTF.text = [NSString stringWithFormat:@"%ld",_jb];
    }
}

-(UISegmentedControl*)segmentedC
{
    [_segmentedC addTarget:self action:@selector(SegmentedControlClick:) forControlEvents:UIControlEventValueChanged];
    return _segmentedC;
}

-(void)SegmentedControlClick:(UISegmentedControl *)segmentedControl
{
    if (segmentedControl.selectedSegmentIndex == 0) {
        self.jbTF.userInteractionEnabled = YES;
        self.ybTF.userInteractionEnabled = NO;
        _type = @"金换银";
    } else {
        self.jbTF.userInteractionEnabled = NO;
        self.ybTF.userInteractionEnabled = YES;
        _type = @"银换金";
    }
}

//点击空白收起键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

-(NSDictionary*)params
{
    if (!_params) {
        _params = [NSDictionary dictionary];
    }
    return _params;
}

@end
