//
//  DEIntegralExchangeController.m
//  美界联盟
//
//  Created by Glory_iMac on 2019/7/24.
//  Copyright © 2019年 刘燚. All rights reserved.
//

#import "DEIntegralExchangeController.h"

@interface DEIntegralExchangeController ()

@property (weak, nonatomic) IBOutlet UILabel* nameLabel;//姓名
@property (weak, nonatomic) IBOutlet UILabel* phoneLabel;//手机号
@property (weak, nonatomic) IBOutlet UILabel* integralLabel;//积分
@property (weak, nonatomic) IBOutlet UITextField* addressTV;//地址TV
@property (weak, nonatomic) IBOutlet UITextField* integralTF;//兑换积分
@property (weak, nonatomic) IBOutlet UITextView* remarkTV;//备注
@property (weak, nonatomic) IBOutlet UISegmentedControl* segmentedControl;//金币/银币

@end

@implementation DEIntegralExchangeController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addNavigationBackBtn:@"back"];
    if (self.myUserInteractionEnabled) {
        [self setNavigationBarTitle:@"积分兑换" andTitleColor:[UIColor whiteColor] andImage:nil];
        [self setNavigationRightBtnText:@"兑换" andTextColor:[UIColor whiteColor]];
//        self.segmentedControl.hidden=NO;
    }else{
        [self setNavigationBarTitle:@"积分兑换详情" andTitleColor:[UIColor whiteColor] andImage:nil];
//        self.segmentedControl.hidden=YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(238, 238, 238);
    
    [self creatView];
}

-(void)creatView
{
    _integralTF.userInteractionEnabled = _myUserInteractionEnabled;
    _integralTF.borderStyle = UITextBorderStyleRoundedRect;
    
    _remarkTV.userInteractionEnabled = _myUserInteractionEnabled;
    _remarkTV.layer.cornerRadius = 7;
    [_remarkTV.layer setMasksToBounds:YES];
    
    _addressTV.userInteractionEnabled = _myUserInteractionEnabled;
    
    if (!self.myUserInteractionEnabled) {
        _nameLabel.text = [self string:@"姓名" :_infoDict[@"fb"]];
        _phoneLabel.text = [self string:@"手机号" :_infoDict[@"fa"]];
        if ([[_infoDict objectForKey:@"fd"]isEqualToString:@"1"]) {
            _integralLabel.text = [self string:@"银币" :_infoDict[@"fc"]];
            _segmentedControl.selectedSegmentIndex = 1;
        }else {
            _integralLabel.text = [self string:@"金币" :_infoDict[@"fc"]];
            _segmentedControl.selectedSegmentIndex = 2;
        }
        
        _addressTV.text = _infoDict[@"fe"];
        _integralTF.text = _infoDict[@"fc"];
        _remarkTV.text = _infoDict[@"fg"];
        _segmentedControl.userInteractionEnabled = NO;
    }else {
        _nameLabel.text = [self string:@"姓名" :_infoDict[@"fa"]];
        _phoneLabel.text = [self string:@"手机号" :_infoDict[@"fb"]];
        _integralLabel.text = [NSString stringWithFormat:@"金币 : %@        银币 : %@",_infoDict[@"fd"],_infoDict[@"fc"]];
        _addressTV.text = _infoDict[@"fe"];
        _integralTF.text = @"";
        _remarkTV.text = @"";
    }
}

-(NSString*)string:(NSString*)string1 :(NSString*)string2
{
    return [NSString stringWithFormat:@"%@ : %@",string1,string2];
}

- (void)navigationRightBtnClick:(UIButton *)btn{
    NSString* t ;
    if (_segmentedControl.selectedSegmentIndex == 1) {
        t = @"1";
    }else {
        t = @"2";
    }
    if ([_addressTV.text isEqualToString:@""]) {
        [ShowMessage showMessage:@"请输入地址"];
        return;
    }
    if ([_integralTF.text isEqualToString:@""]) {
        [ShowMessage showMessage:@"请输入兑换积分"];
        return;
    }
    if ([_remarkTV.text isEqualToString:@""]) {
        [ShowMessage showMessage:@"请输入备注"];
        return;
    }
    /*
     *a账号，b积分值，c积分值类型，d地址，e备注，f姓名
     */
    NSNumber *b = [NSNumber numberWithInteger:[_integralTF.text integerValue]];
    NSDictionary* params = @{@"a":_infoDict[@"fb"],
                             @"b":b,
                             @"c":t,
                             @"d":_addressTV.text,
                             @"e":_remarkTV.text,
                             @"f":_infoDict[@"fa"]
                             };
    
    NSString* url =[NSString stringWithFormat:@"%@mapi/Intergral/MExchange",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params  andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
//        if ([[respondObject objectForKey:@"a"]integerValue] == TYRequestSuccessful) {
            [ShowMessage showMessage:[respondObject objectForKey:@"b"]];
//        }
    } orFailBlock:^(id error) {
        [TYShowHud showHudErrorWithStatus:@"网络超时，请重新再试"];
    }];
}

-(UISegmentedControl*)segmentedControl
{
    _segmentedControl.selectedSegmentIndex=0;
    [_segmentedControl addTarget:self action:@selector(SegmentedControlClick:) forControlEvents:UIControlEventValueChanged];
    return _segmentedControl;
}

-(void)SegmentedControlClick:(UISegmentedControl *)segmentedControl
{
    NSLog(@"---%d",segmentedControl.selectedSegmentIndex);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
