//
//  TYCashWalletVC.m
//  美界联盟
//
//  Created by LY on 2018/11/11.
//  Copyright © 2018 刘燚. All rights reserved.
//

#import "TYCashWalletVC.h"
#import "TYCashWalletCell.h"
#import "TYApplyCashVC.h"
#import "TYBillDetailVC.h"
#import "TYCashModel.h"
#import "TYOpenWXVC.h"

@interface TYCashWalletVC ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tabView;
/** TYCashModel */
@property (nonatomic, strong) TYCashModel *model;

@end

@implementation TYCashWalletVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"现金钱包" andTitleColor:[UIColor whiteColor] andImage:nil];
    [self requestCashWalletWithdrawalCount];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WalletWithdrawa) name:@"CashWalletWithdrawa" object:nil];
}

-(void)WalletWithdrawa{
     [self requestCashWalletWithdrawalCount];
}


#pragma mark -- <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TYCashWalletCell *cell = [TYCashWalletCell CellTableView:self.tabView];
    __weak typeof(&*self)weakSelf = self;
    cell.model = self.model;
    cell.clickTheButtonBlock = ^(NSInteger tag) {
        if (tag == 1) {
            if (weakSelf.model.hasWx == YES) {
                //创建一个url，记得加上：//
//                NSURL *url = [NSURL URLWithString:@"weixin://"];
//                BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
//                //先判断是否能打开该url
//                if (canOpen)
//                {   //打开微信
//                    [[UIApplication sharedApplication] openURL:url];
//                }else {
//                    [TYShowHud showHudErrorWithStatus:@"您的设备未安装微信"];
//                }
                TYOpenWXVC *vc = [[TYOpenWXVC alloc] init];
                vc.url = weakSelf.model.link;
                [weakSelf.navigationController pushViewController:vc animated:YES];
                
            }else{
                TYApplyCashVC *vc = [[TYApplyCashVC alloc] init];
                vc.model = weakSelf.model;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
            
        }else{
            
            TYBillDetailVC *vc = [[TYBillDetailVC alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREEN_HEIGHT;
}

#pragma mark -- 网络请求
-(void)requestCashWalletWithdrawalCount{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"CusID"] = @([TYLoginModel getPrimaryId]);
    NSString *url = [NSString stringWithFormat:@"%@SAPI/User/CashWalletWithdrawalCount",APP_REQUEST_URL];
     __weak typeof(&*self)weakSelf = self;
    
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        if ([[respondObject objectForKey:@"Status"] boolValue] == true) {
            weakSelf.model = [TYCashModel mj_objectWithKeyValues:[respondObject objectForKey:@"Data"]];
            [weakSelf.tabView reloadData];
        }
//        [TYShowHud showHudSucceedWithStatus:[respondObject objectForKey:@"Msg"]];
    } orFailBlock:^(id error) {
       [TYShowHud showHudErrorWithStatus:@"接口请求失败"];
    }];
}
@end
