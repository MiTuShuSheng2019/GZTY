//
//  TYApplyCashVC.m
//  美界联盟
//
//  Created by LY on 2018/11/11.
//  Copyright © 2018 刘燚. All rights reserved.
//

#import "TYApplyCashVC.h"
#import "TYApplyCashCell.h"

@interface TYApplyCashVC ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tabView;

@end

@implementation TYApplyCashVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"申请提现" andTitleColor:[UIColor whiteColor] andImage:nil];
}

#pragma mark -- <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TYApplyCashCell *cell = [TYApplyCashCell CellTableView:self.tabView];
    cell.model = self.model;
    __weak typeof(&*self)weakSelf = self;
    cell.clickTheButtonBlock = ^(NSString * money) {
        [weakSelf.view endEditing:YES];
        [weakSelf requestCashWalletWithdrawa:money];
    };
   
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREEN_HEIGHT;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}


#pragma mark -- 网络请求
//提现申请
-(void)requestCashWalletWithdrawa:(NSString *)money{
    [TYShowHud showHud];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"CusID"] = @([TYLoginModel getPrimaryId]);
    params[@"Amount"] = money;
    
    NSString *url = [NSString stringWithFormat:@"%@SAPI/User/CashWalletWithdrawaLapplyFor",APP_REQUEST_URL];
    __weak typeof(&*self)weakSelf = self;
    
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        if ([[respondObject objectForKey:@"Status"] boolValue] == true) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CashWalletWithdrawa" object:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
         [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"Msg"]];
        
    } orFailBlock:^(id error) {
        [TYShowHud showHudErrorWithStatus:@"接口请求失败"];
    }];
}

@end
