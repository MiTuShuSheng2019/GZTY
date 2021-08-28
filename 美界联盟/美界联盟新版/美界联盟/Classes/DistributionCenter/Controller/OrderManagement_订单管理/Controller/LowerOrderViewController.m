//
//  LowerOrderViewController.m
//  美界联盟
//
//  Created by LY on 2017/11/6.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "LowerOrderViewController.h"
#import "TYLowerOrderCell.h"
#import "TYMyOrderModel.h"
#import "TYOrderDetailViewController.h"

@interface LowerOrderViewController ()<TYLowerOrderCellDelegate>

//共计多少订单
@property (weak, nonatomic) IBOutlet UILabel *totleOrderLabel;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

/** 分页 */
@property (nonatomic, assign) NSInteger page;
/** 请求的条数 */
@property (nonatomic, assign) NSInteger limit;

@end

@implementation LowerOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpTableView];
    
    //接收到搜索的通知 搜索数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchData:) name:@"searchLowerOrderViewController" object:nil];
}

-(void)searchData:(NSNotification *)not{
    
    self.keyWord = [not.userInfo objectForKey:@"keyWord"];
    self.startTime = [not.userInfo objectForKey:@"startTime"];
    self.endTime = [not.userInfo objectForKey:@"endTime"];
    [self.myTableView.mj_header beginRefreshing];
}

//初始化TableView
-(void)setUpTableView{
    self.limit = 10;
    __weak typeof(&*self)weakSelf = self;
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf.modelArray removeAllObjects];
        [weakSelf requestLowerOrderList];
    }];
    
    self.myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestLowerOrderList];
    }];
    
    self.myTableView.mj_footer.hidden = YES;
    [self.myTableView.mj_header beginRefreshing];
    self.myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.myTableView.tableFooterView = [UIView new];
    self.myTableView.showsVerticalScrollIndicator = NO;
}

#pragma mark -- <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TYLowerOrderCell *cell = [TYLowerOrderCell CellTableView:self.myTableView];
    cell.delegate = self;
    
    if (self.type == 1 || self.type == 2) {
        cell.stateLabel.hidden = YES;
        if (self.type == 1) {
            cell.auditBtn.hidden = NO;
        }else{
            cell.auditBtn.hidden = YES;
        }
        
    }else{
        cell.stateLabel.hidden = NO;
        cell.auditBtn.hidden = YES;
    }
    
    cell.model = self.modelArray[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
}

#pragma mark -- <TYLowerOrderCellDelegate>
//审核通过
-(void)AuditApproval:(UIButton *)btn{
    TYLowerOrderCell *cell = (TYLowerOrderCell *)[[btn superview] superview];
    NSIndexPath *path = [self.myTableView indexPathForCell:cell];
    TYMyOrderModel *model = self.modelArray[path.row];
    [self requestExamine:model.ea andPath:path];
}

//查看详情
-(void)LookDetail:(UIButton *)btn{
    TYLowerOrderCell *cell = (TYLowerOrderCell *)[[btn superview] superview];
    NSIndexPath *path = [self.myTableView indexPathForCell:cell];
    
    TYMyOrderModel *model = self.modelArray[path.row];
    TYOrderDetailViewController *detailVc = [[TYOrderDetailViewController alloc] init];
    detailVc.model = model;
    [self.navigationController pushViewController:detailVc animated:YES];
}


#pragma mark --- 网络请求
//17 经销中心-订单管理-我的订单列表
-(void)requestLowerOrderList{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = @(self.page);//分页页码
    params[@"c"] = @(self.limit);//分页数量
    params[@"d"] = @([TYLoginModel getPrimaryId]);//分销商ID
    params[@"e"] = @(self.type);//订单状态 1未审核,2:审核通过;3:未通过;4:订单出库;5:订单入库;6:订单完成;7:订单作废
    params[@"f"] = self.startTime;//查询开始时间
    params[@"g"] = self.endTime;//查询结束时间
    
    NSString *url = [NSString stringWithFormat:@"%@mapi/order/lowerOrderList",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            self.page = self.page + 1;
            
            NSArray *arr = [TYMyOrderModel mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"e"]];
            [self.modelArray addObjectsFromArray:arr];
            
            if (arr.count == self.limit) {
                self.myTableView.mj_footer.hidden = NO;
            }else{
                self.myTableView.mj_footer.hidden = YES;
            }
            
            if (self.type == 1) {
                self.totleOrderLabel.text = [NSString stringWithFormat:@"待审核%@单", [[respondObject objectForKey:@"c"] objectForKey:@"count"]];
            }else if (self.type == 2){
                self.totleOrderLabel.text = [NSString stringWithFormat:@"已审核%@单", [[respondObject objectForKey:@"c"] objectForKey:@"count"]];
            }else{
                self.totleOrderLabel.text = [NSString stringWithFormat:@"全部订单%@单", [[respondObject objectForKey:@"c"] objectForKey:@"count"]];
            }
            
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
        [self.myTableView reloadData];
    } orFailBlock:^(id error) {
        
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
    }];
}

// 21 经销中心-订单管理-审核
-(void)requestExamine:(NSString *)orderID andPath:(NSIndexPath *)path{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = orderID;//订单ID
    
    NSString *url = [NSString stringWithFormat:@"%@mapi/Order/Examine",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            [self.modelArray removeObjectAtIndex:path.row];
            
            [TYShowHud showHudSucceedWithStatus:@"审核通过"];
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
        
        [self.myTableView reloadData];
    } orFailBlock:^(id error) {
        
    }];
}

@end
