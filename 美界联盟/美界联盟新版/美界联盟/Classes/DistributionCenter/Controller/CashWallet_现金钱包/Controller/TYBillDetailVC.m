//
//  TYBillDetailVC.m
//  美界联盟
//
//  Created by LY on 2018/11/11.
//  Copyright © 2018 刘燚. All rights reserved.
//

#import "TYBillDetailVC.h"
#import "TYBillDetailCell.h"
#import "TYBillDetailModel.h"

@interface TYBillDetailVC ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tabView;

@end

@implementation TYBillDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"账单明细" andTitleColor:[UIColor whiteColor] andImage:nil];
    
    [self setUpTableView];
    
}

//初始化TableView
-(void)setUpTableView{
   
//    __weak typeof(&*self)weakSelf = self;
//    self.tabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        weakSelf.page = 1;
//        [weakSelf.modelArray removeAllObjects];
//        [weakSelf requestCashWalletWithdrawalDetail];
//    }];
    [self requestCashWalletWithdrawalDetail];
//    self.tabView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        [weakSelf requestPushManageList];
//    }];
    
    self.tabView.mj_footer.hidden = YES;
//    [self.tabView.mj_header beginRefreshing];
    self.tabView.tableFooterView = [UIView new];
    
    self.tabView.estimatedRowHeight = 10.f;
    self.tabView.rowHeight = UITableViewAutomaticDimension;
}


#pragma mark -- <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TYBillDetailCell *cell = [TYBillDetailCell CellTableView:self.tabView];
    cell.model = self.modelArray[indexPath.row];
    return cell;
}


#pragma mark -- 网络请求
//提现明细
-(void)requestCashWalletWithdrawalDetail{
    [TYShowHud showHud];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"CusID"] = @([TYLoginModel getPrimaryId]);
    NSString *url = [NSString stringWithFormat:@"%@SAPI/User/CashWalletWithdrawalDetail",APP_REQUEST_URL];
    
     __weak typeof(&*self)weakSelf = self;
    
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        if ([[respondObject objectForKey:@"Status"] boolValue] == true) {
            NSArray *arr = [TYBillDetailModel mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"Data"] objectForKey:@"list"]];
            [weakSelf.modelArray addObjectsFromArray:arr];
            [weakSelf.tabView reloadData];
        }
//        [TYShowHud showHudSucceedWithStatus:[respondObject objectForKey:@"Msg"]];
        
    } orFailBlock:^(id error) {
        [TYShowHud showHudErrorWithStatus:@"接口请求失败"];
    }];
}

@end
