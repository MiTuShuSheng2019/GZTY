//
//  TYTeamResultsVC.m
//  美界联盟
//
//  Created by LY on 2018/9/14.
//  Copyright © 2018年 刘燚. All rights reserved.
//

#import "TYTeamResultsVC.h"
#import "TYResultsCell.h"
#import "TYMyOrderModel.h"
#import "TYAwaitingOneCell.h"
#import "TYOrderDetailViewController.h"
#import "TYLogisticsInformationVC.h"
#import "TYGlobalSearchView.h"

@interface TYTeamResultsVC ()<UITableViewDelegate, UITableViewDataSource, TYAwaitingOneCellDelegate, TYGlobalSearchViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tabView;
/** 分页 */
@property (nonatomic, assign) NSInteger page;
/** 请求的条数 */
@property (nonatomic, assign) NSInteger limit;


@end

@implementation TYTeamResultsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"团队业绩" andTitleColor:[UIColor whiteColor] andImage:nil];
    [self setNavigationRightBtnImage:@"search"];
    
    self.limit = 11;
    __weak typeof(&*self)weakSelf = self;
    self.tabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf requestTeamOrderCount];
    }];
    
    self.tabView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestOrderList];
    }];
    
    self.tabView.mj_footer.hidden = YES;
    [self.tabView.mj_header beginRefreshing];
    self.tabView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tabView.tableFooterView = [UIView new];
    self.tabView.showsVerticalScrollIndicator = NO;
}

#pragma mark -- 搜索
- (void)navigationRightBtnClick:(UIButton *)btn{
    TYGlobalSearchView *SearchView = [TYGlobalSearchView CreatTYGlobalSearchView];
    SearchView.delegate = self;
    SearchView.frame = CGRectMake(0, 20, KScreenWidth, KScreenHeight);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:SearchView];
}

#pragma mark -- TYGlobalSearchViewDelegate
-(void)ClickSearch:(NSString *)KeyWord andStartTime:(NSString *)startTime andEndTime:(NSString *)endTime{
    self.keyWord = KeyWord;
    self.startTime = startTime;
    self.endTime = endTime;
    [self.tabView.mj_header beginRefreshing];
}

#pragma mark --<UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TYAwaitingOneCell *cell = [TYAwaitingOneCell CellTableView:self.tabView];
    cell.delegate = self;
    cell.LookDetailBtn.hidden = YES;
    
    cell.MyOrderModel = self.modelArray[indexPath.row];
    //判断在全部模块是否显示查看物流
    if (cell.MyOrderModel.OrderStatus == 2 || cell.MyOrderModel.OrderStatus == 6) {
        cell.logisticBtn.hidden = NO;
    }else{
        cell.logisticBtn.hidden = YES;
    }
    
    return cell;
}

#pragma mark -- <TYAwaitingOneCellDelegate>
-(void)FirstLookDetail:(UIButton *)btn{
    
}
//查看物流
-(void)LookLogistic:(UIButton *)btn{
    
    TYAwaitingOneCell *cell = (TYAwaitingOneCell *)[[btn superview] superview];
    NSIndexPath *path = [self.tabView indexPathForCell:cell];
    TYMyOrderModel *model = self.modelArray[path.row];
    //查看物流
    TYLogisticsInformationVC *vc = [[TYLogisticsInformationVC alloc] init];
    vc.logisticsName = model.el;
    vc.sheetCode = model.em;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark -- 查看详情
-(void)LookDetail:(UIButton *)btn{
    TYAwaitingOneCell *cell = (TYAwaitingOneCell *)[[btn superview] superview];
    NSIndexPath *path = [self.tabView indexPathForCell:cell];
    TYMyOrderModel *model = self.modelArray[path.row];
    TYOrderDetailViewController *detailVc = [[TYOrderDetailViewController alloc] init];
    detailVc.model = model;
    [self.navigationController pushViewController:detailVc animated:YES];
}


#pragma mark --- 网络请求
//团队业绩的订单汇总
-(void)requestTeamOrderCount{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = @([TYLoginModel getPrimaryId]);//分销商Id
    params[@"d"] = self.startTime;//查询开始时间
    params[@"e"] = self.endTime;//查询结束时间
    
    NSString *url = [NSString stringWithFormat:@"%@mapi/Order/teamOrderCount",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            
            TYTeamOrderCount *model = [TYTeamOrderCount mj_objectWithKeyValues:[respondObject objectForKey:@"c"]];
            TYResultsCell *headView = [TYResultsCell CellTableView:self.tabView];
            headView.height = 200;
            headView.model = model;
            self.tabView.tableHeaderView = headView;
            [self requestOrderList];
            
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }

    } orFailBlock:^(id error) {
        
        [self.tabView.mj_header endRefreshing];
        [self.tabView.mj_footer endRefreshing];
    }];
}

//团队业绩的订单列表
-(void)requestOrderList{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = @(self.page);//分页页码
    params[@"c"] = @(self.limit);//分页数量
    params[@"d"] = @([TYLoginModel getPrimaryId]);//分销商ID
    params[@"e"] = self.keyWord;//模糊查询（人名，电话）
    params[@"f"] = self.startTime;//查询开始时间
    params[@"g"] = self.endTime;//查询结束时间
    
    NSString *url = [NSString stringWithFormat:@"%@mapi/Order/teamOrderDetail",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            
            if (self.page == 1) {
                 [self.modelArray removeAllObjects];
            }
            self.page = self.page + 1;
            
            NSArray *arr = [TYMyOrderModel mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"e"]];
            [self.modelArray addObjectsFromArray:arr];
            
            if (arr.count == self.limit) {
                self.tabView.mj_footer.hidden = NO;
            }else{
                self.tabView.mj_footer.hidden = YES;
            }
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
        [self.tabView.mj_header endRefreshing];
        [self.tabView.mj_footer endRefreshing];
        [self.tabView reloadData];
    } orFailBlock:^(id error) {
        
        [self.tabView.mj_header endRefreshing];
        [self.tabView.mj_footer endRefreshing];
    }];
}

@end
