//
//  MyOrderViewController.m
//  美界联盟
//
//  Created by LY on 2017/11/6.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "MyOrderViewController.h"
#import "TYAwaitingOneCell.h"
#import "TYOrderDetailViewController.h"
#import "TYSelectProductViewController.h"
#import "TYLogisticsInformationVC.h"

@interface MyOrderViewController ()<TYAwaitingOneCellDelegate>
//共计多少订单
@property (weak, nonatomic) IBOutlet UILabel *totleOrderLabel;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
//底部视图
@property (weak, nonatomic) IBOutlet UIView *bottomView;
//底部视图的高
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewH;
/** 分页 */
@property (nonatomic, assign) NSInteger page;
/** 请求的条数 */
@property (nonatomic, assign) NSInteger limit;

@end

@implementation MyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.width = KScreenWidth;
    if (self.type == 1) {
        
        if ([TYLoginModel getWhetherHeadquarters] != YES) {
            self.bottomView.hidden = NO;
            self.bottomViewH.constant = 50;
        }else{
            self.bottomView.hidden = YES;
            self.bottomViewH.constant = 0;
        }
        
    }else{
        self.bottomView.hidden = YES;
        self.bottomViewH.constant = 0;
    }
    [self setUpTableView];
    
    //接收到搜索的通知 搜索数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchData:) name:@"searchMyOrderViewController" object:nil];
    //接收通知属性数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"backMyOrderViewController" object:nil];
    
}

//搜索数据
-(void)searchData:(NSNotification *)not{
    self.keyWord = [not.userInfo objectForKey:@"keyWord"];
    self.startTime = [not.userInfo objectForKey:@"startTime"];
    self.endTime = [not.userInfo objectForKey:@"endTime"];
    self.ddtype = [not.userInfo objectForKey:@"type"];
    [self.myTableView.mj_header beginRefreshing];
}

//刷新数据
-(void)refreshData{
    [self.myTableView.mj_header beginRefreshing];
}

//初始化TableView
-(void)setUpTableView{
    self.limit = 11;
    self.ddtype = @"0";
    __weak typeof(&*self)weakSelf = self;
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf.modelArray removeAllObjects];
        [weakSelf requestMyorderList];
    }];
    
    self.myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestMyorderList];
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
    TYAwaitingOneCell *cell = [TYAwaitingOneCell CellTableView:self.myTableView];
    cell.delegate = self;
    
    cell.LookDetailBtn.hidden = YES;
    if (self.type == 1 || self.type == 2) {
        cell.stateLabel.hidden = YES;
        cell.logisticBtn.hidden = NO;
        [cell.logisticBtn setTitle:@"删除" forState:UIControlStateNormal];
    }else{
        cell.stateLabel.hidden = NO;
        
    }
    
    cell.MyOrderModel = self.modelArray[indexPath.row];
    
    if (self.type == -1) {
        //判断在全部模块是否显示查看物流
        if (cell.MyOrderModel.OrderStatus == 2 || cell.MyOrderModel.OrderStatus == 6) {
            cell.logisticBtn.hidden = NO;
        }else{
            cell.logisticBtn.hidden = YES;
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
}

#pragma mark - TableView 占位图
- (UIImage *)xy_noDataViewImage {
    return [UIImage imageNamed:@"no_data"];
}

- (NSString *)xy_noDataViewMessage {
    return @"抱歉，暂无相关数据";
}

- (UIColor *)xy_noDataViewMessageColor {
    return RGB(170, 170, 170);
}

#pragma mark -- <TYAwaitingOneCellDelegate>
//查看详情
-(void)FirstLookDetail:(UIButton *)btn{
    //    TYAwaitingOneCell *cell = (TYAwaitingOneCell *)[[btn superview] superview];
    //    NSIndexPath *path = [self.myTableView indexPathForCell:cell];
    //    TYMyOrderModel *model = self.modelArray[path.row];
    //    TYOrderDetailViewController *detailVc = [[TYOrderDetailViewController alloc] init];
    //    detailVc.model = model;
    //    [self.navigationController pushViewController:detailVc animated:YES];
}

//查看物流
-(void)LookLogistic:(UIButton *)btn{
    
    TYAwaitingOneCell *cell = (TYAwaitingOneCell *)[[btn superview] superview];
    NSIndexPath *path = [self.myTableView indexPathForCell:cell];
    TYMyOrderModel *model = self.modelArray[path.row];
    
    if (self.type == -1) {
        //查看物流
        TYLogisticsInformationVC *vc = [[TYLogisticsInformationVC alloc] init];
        vc.logisticsName = model.el;
        vc.sheetCode = model.em;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else  if (self.type == 1 || self.type == 2) {
        //删除订单
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"你确定删除该订单" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self requestOrderDelete:model.ea andPath:path];
        }];
        [alertController addAction:action];
        [alertController addAction:action1];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark -- 查看详情
-(void)LookDetail:(UIButton *)btn{
    TYAwaitingOneCell *cell = (TYAwaitingOneCell *)[[btn superview] superview];
    NSIndexPath *path = [self.myTableView indexPathForCell:cell];
    TYMyOrderModel *model = self.modelArray[path.row];
    TYOrderDetailViewController *detailVc = [[TYOrderDetailViewController alloc] init];
    detailVc.model = model;
    [self.navigationController pushViewController:detailVc animated:YES];
}

#pragma mark ------ 点击新增订单
- (IBAction)ClickNewOrder {
    TYSelectProductViewController *selectVc = [[TYSelectProductViewController alloc] init];
    [self.navigationController pushViewController:selectVc animated:YES];
}

#pragma mark --- 网络请求
//17 经销中心-订单管理-我的订单列表
-(void)requestMyorderList{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = @(self.page);//分页页码
    params[@"c"] = @(self.limit);//分页数量
    params[@"d"] = @([TYLoginModel getPrimaryId]);//分销商ID
    params[@"e"] = @(self.type);//订单状态 1未审核,2:审核通过;3:未通过;4:订单出库;5:订单入库;6:订单完成;7:订单作废
    params[@"f"] = self.startTime;//查询开始时间
    params[@"g"] = self.endTime;//查询结束时间
    params[@"type"] = self.ddtype;//订单来源 *0 全部 *1 购买 *2 积分兑换
    
    NSString *url = [NSString stringWithFormat:@"%@mapi/order/myorderList",APP_REQUEST_URL];
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

//22 经销中心-订单管理-删除
-(void)requestOrderDelete:(NSString *)orderID andPath:(NSIndexPath *)path{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = orderID;//订单ID
    
    NSString *url = [NSString stringWithFormat:@"%@mapi/Order/OrderDelete",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            [self.modelArray removeObjectAtIndex:path.row];
            [TYShowHud showHudSucceedWithStatus:@"成功删除"];
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
        [self.myTableView reloadData];
    } orFailBlock:^(id error) {
        
    }];
}
@end
