//
//  TYAwaitingDeliveryViewController.m
//  美界联盟
//
//  Created by LY on 2017/11/27.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYAwaitingDeliveryViewController.h"
#import "TYAwaitingOneCell.h"
#import "TYAwaitingModel.h"
#import "TYOrderDetailViewController.h"
#import "TYConsumerAwaitingBigModel.h"
#import "TYLogisticsInformationVC.h"

@interface TYAwaitingDeliveryViewController ()<UITableViewDelegate,UITableViewDataSource,TYAwaitingOneCellDelegate>
@property (weak, nonatomic) IBOutlet UILabel *totleLabel;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
/** 分页 */
@property (nonatomic, assign) NSInteger page;
/** 请求的条数 */
@property (nonatomic, assign) NSInteger limit;
/** 列表数组 */
@property (nonatomic, strong) NSMutableArray *dataArr;
/** 记录总数量 */
@property (nonatomic, assign) NSInteger totle;

@end

@implementation TYAwaitingDeliveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigation];
    
    self.limit = 11;
    __weak typeof (&*self)weakSelf = self;
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf.dataArr removeAllObjects];
        [weakSelf requestData];
    }];
    
    self.myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestData];
    }];
    
    self.myTableView.mj_footer.hidden = YES;
    [self.myTableView.mj_header beginRefreshing];
    self.myTableView.tableFooterView = [UIView new];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.showsVerticalScrollIndicator = NO;
}

-(void)setNavigation{
    NSString *title = nil;
    if (self.isWho == 1) {
        title = @"待发货";
    }else if(self.isWho == 2){
        title = @"待收货";
    }else{
        title = @"已完成";
    }
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:title andTitleColor:[UIColor whiteColor] andImage:nil];
}

#pragma mark -- <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TYAwaitingOneCell *cell = [TYAwaitingOneCell CellTableView:self.myTableView];
    cell.delegate = self;
    if (self.isWho == 1) {
        cell.LookDetailBtn.hidden = YES;
        cell.logisticBtn.hidden = YES;
    }
    
    if (self.isWho == 2) {
        [cell.detalBtn setTitle:@"确认收货" forState:UIControlStateNormal];
    }
    
    if (self.isWho == 3){
        cell.LookDetailBtn.hidden = YES;
    }
    
    if (self.dataArr.count == 0) {
        return cell;
    }
    
    cell.model = self.dataArr[indexPath.row];
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
    TYAwaitingOneCell *cell = (TYAwaitingOneCell *)[[btn superview] superview];
    NSIndexPath *path = [self.myTableView indexPathForCell:cell];
    TYConsumerAwaitingBigModel *model = self.dataArr[path.row];
    TYOrderDetailViewController *detailVc = [[TYOrderDetailViewController alloc] init];
    detailVc.consumerModel = model;
    [self.navigationController pushViewController:detailVc animated:YES];
}

//查看物流
-(void)LookLogistic:(UIButton *)btn{
    TYAwaitingOneCell *cell = (TYAwaitingOneCell *)[[btn superview] superview];
    NSIndexPath *path = [self.myTableView indexPathForCell:cell];
    TYConsumerAwaitingBigModel *model = self.dataArr[path.row];
    TYLogisticsInformationVC *vc = [[TYLogisticsInformationVC alloc] init];
    vc.logisticsName = model.dm;
    vc.sheetCode = model.df;
    [self.navigationController pushViewController:vc animated:YES];
}

//查看详情
-(void)LookDetail:(UIButton *)btn{
    TYAwaitingOneCell *cell = (TYAwaitingOneCell *)[[btn superview] superview];
    NSIndexPath *path = [self.myTableView indexPathForCell:cell];
    TYConsumerAwaitingBigModel *model = self.dataArr[path.row];
    
    if (self.isWho == 2) {//确认收货
        [self requestConfirmOrder:model.db andPath:path];
        
    }else{//查看详情
        
        TYOrderDetailViewController *detailVc = [[TYOrderDetailViewController alloc] init];
        detailVc.consumerModel = model;
        [self.navigationController pushViewController:detailVc animated:YES];
    }
}

#pragma mark -- 网络请求
//请求列表数据
-(void)requestData{
    NSString *url = [NSString stringWithFormat:@"%@MAPI/SM/SMOrderList", APP_REQUEST_URL];
    
    NSInteger state;
    if (self.isWho == 1) {
        state = 1;
    }else if(self.isWho == 2){
        state = 2;
    }else{
        state = 4;
    }
    
    NSDictionary *dic = @{
                          @"a":[TYConsumerLoginModel getSessionID],//回话session
                          @"b":[TYConsumerLoginModel getPrimaryId],//分销商ID
                          @"c":@(self.page),//分页页码 默认1
                          @"d":@(self.limit),//分页数量 默认 10
                          @"e":@(state),//订单状态-1全部 1下单成功未发货 2发货成功待收货 3收货完成待确定 4完成
                          };
    
    [TYNetworking postRequestURL:url parameters:dic andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {//成功
            
            self.page = self.page + 1;
            
            NSArray *arr = [TYConsumerAwaitingBigModel mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"d"]];
            [self.dataArr addObjectsFromArray:arr];
            
            if (arr.count == self.limit) {
                self.myTableView.mj_footer.hidden = NO;
            }else{
                self.myTableView.mj_footer.hidden = YES;
            }
            
            if (self.isWho == 1) {
                self.totleLabel.text = [NSString stringWithFormat:@"待发货%@单", [[respondObject objectForKey:@"c"] objectForKey:@"e"]];
            }else if (self.isWho == 2){
                self.totleLabel.text = [NSString stringWithFormat:@"待收货%@单", [[respondObject objectForKey:@"c"] objectForKey:@"e"]];
            }else{
                self.totleLabel.text = [NSString stringWithFormat:@"已完成%@单", [[respondObject objectForKey:@"c"] objectForKey:@"e"]];
            }
            self.totle = [[[respondObject objectForKey:@"c"] objectForKey:@"e"] integerValue];
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

//请求确认收货
-(void)requestConfirmOrder:(NSString *)order andPath:(NSIndexPath *)path{
    
    NSString *url = [NSString stringWithFormat:@"%@MAPI/SM/ConfirmOrder", APP_REQUEST_URL];
    
    NSDictionary *dic = @{
                          @"a":[TYConsumerLoginModel getSessionID],//回话session
                          @"b":order//订单编号
                          };
    
    [TYNetworking postRequestURL:url parameters:dic andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {//成功
            
            [TYShowHud showHudSucceedWithStatus:@"完成"];
            [self.dataArr removeObjectAtIndex:path.row];
            self.totleLabel.text = [NSString stringWithFormat:@"已完成%ld单",self.totle - 1];
            self.totle = self.totle - 1;
            
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
        [self.myTableView reloadData];
        
    } orFailBlock:^(id error) {
        
    }];
}

#pragma mark -- 懒加载
- (NSMutableArray *) dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
@end

