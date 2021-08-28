//
//  ShippingViewController.m
//  美界联盟
//
//  Created by LY on 2017/11/8.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "ShippingViewController.h"
#import "TYDeliveryRecordCell.h"
#import "TYOutStorageModel.h"
#import "TYYOutStorageCell.h"
#import "TYOrderDetailViewController.h"
#import "TYOutboundGoodsViewController.h"
#import "TYDistributorsViewController.h"
#import "TYShipingEditViewController.h"

@interface ShippingViewController ()<UITableViewDataSource, UITableViewDelegate, TYDeliveryRecordCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UIView *totalView;
//40
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalViewH;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;
//35
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomBtnH;

/** 分页 */
@property (nonatomic, assign) NSInteger page;
/** 请求的条数 */
@property (nonatomic, assign) NSInteger limit;

@end

@implementation ShippingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.width = KScreenWidth;
    if (self.type == 0) {
        self.bottomBtn.hidden = YES;
        self.bottomBtnH.constant = 0;
        //接收通知刷新数据
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"backShippingViewController" object:nil];
        self.myTableView.editing = NO;
    }else{
        self.totalView.hidden = YES;
        self.totalViewH.constant = 0;
    }
    [self setUpTableView];
    
    //接收到搜索的通知 搜索数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchData:) name:@"searchShippingViewController" object:nil];
}

-(void)refreshData{
    [self.myTableView.mj_header beginRefreshing];
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
        if (self.type == 0) {
            [weakSelf requestOutStrogeOrderList];
        }else{
            [weakSelf requestOutStorageList];
        }
    }];
    
    self.myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.type == 0) {
            [weakSelf requestOutStrogeOrderList];
        }else{
            [weakSelf requestOutStorageList];
        }
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
        if (self.type == 0) {
            TYDeliveryRecordCell *cell = [TYDeliveryRecordCell CellTableView:self.myTableView];
            cell.awModel = self.modelArray[indexPath.row];
            cell.delegate = self;
            return cell;
        }else{
            TYYOutStorageCell *cell = [TYYOutStorageCell CellTableView:self.myTableView];
            cell.model = self.modelArray[indexPath.row];
            return cell;
        }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == 0) {
        return 175;
    }else{
        return 88;
    }
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (self.type == 1) {
//        TYFlowingWaterView *waterView = [TYFlowingWaterView CreatTYFlowingWaterView];
//        waterView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
//        UIWindow *window = [UIApplication sharedApplication].keyWindow;
//        [window addSubview:waterView];
//    }
//}


/**
 *  左滑cell时出现什么按钮
 */
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == 0) {
        return nil;
    }
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
       
        
        TYShipingEditViewController *editVc = [[TYShipingEditViewController alloc] init];
        editVc.model = self.modelArray[indexPath.row];
        [self.navigationController pushViewController:editVc animated:YES];
        
    }];
    
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        [self.modelArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        TYOutStorageModel *model = self.modelArray[indexPath.row];
        [self requestOutStorageInfoDeleted:model.ea];
    }];
    
    UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"扫描" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        TYOutStorageModel *model = self.modelArray[indexPath.row];        TYOutboundGoodsViewController *vc = [[TYOutboundGoodsViewController alloc] init];
        vc.orderID = model.ea;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    return @[action, action1, action2];
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

#pragma mark -- <TYDeliveryRecordCellDelegate>
//发货
-(void)ClickLookLogistic:(UIButton *)btn{
    TYDeliveryRecordCell *cell = (TYDeliveryRecordCell *)[[btn superview] superview];
    NSIndexPath *path = [self.myTableView indexPathForCell:cell];
    
    TYMyOrderModel *model = self.modelArray[path.row];
    TYOutboundGoodsViewController *vc = [[TYOutboundGoodsViewController alloc] init];
    vc.orderID = model.ea;
    [self.navigationController pushViewController:vc animated:YES];
}

//查看详情
-(void)ClickLookDetail:(UIButton *)btn{
    TYDeliveryRecordCell *cell = (TYDeliveryRecordCell *)[[btn superview] superview];
    NSIndexPath *path = [self.myTableView indexPathForCell:cell];
    TYMyOrderModel *model = self.modelArray[path.row];
    TYOrderDetailViewController *vc = [[TYOrderDetailViewController alloc] init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ---  点击创建出库信息
- (IBAction)ClickCreateInformation {
    TYDistributorsViewController *createVc = [[TYDistributorsViewController alloc] init];
    createVc.type = 2;
    [self.navigationController pushViewController:createVc animated:YES];
}

#pragma mark --- 网络请求
//18 经销中心-订单管理-获取我的审核通过的和出库中的下级订单列表】---订单发货
-(void)requestOutStrogeOrderList{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = @(self.page);//页码
    params[@"c"] = @(self.limit);//页大小
    params[@"d"] = @([TYLoginModel getPrimaryId]);//分销商ID
    params[@"e"] = @(0);//订单状态 1未审核,2:审核通过;3:未通过;4:订单出库;5:订单入库;6:订单完成;7:订单作废 0全部
    params[@"f"] = self.startTime;//查询开始时间
    params[@"g"] = self.endTime;//查询结束时间
    params[@"k"] = self.keyWord;//入库分销商名称--模糊搜索入库分销商名称
    
    NSString *url = [NSString stringWithFormat:@"%@mapi/order/OutStrogeOrderList",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            
            NSArray *arr = [TYMyOrderModel mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"e"]];
            [self.modelArray addObjectsFromArray:arr];
            
            self.page = self.page + 1;
            if (arr.count == self.limit) {
                self.myTableView.mj_footer.hidden = NO;
            }else{
                self.myTableView.mj_footer.hidden = YES;
            }
            self.totalLabel.text = [NSString stringWithFormat:@"需发货%@单",[[respondObject objectForKey:@"c"] objectForKey:@"count"]];
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

//25 经销中心-发货管理-发货记录 -- 流水发货
-(void)requestOutStorageList{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = @(self.page);//页码
    params[@"c"] = @(self.limit);//页大小
    params[@"d"] = @(1);//出库单状态（ 1、预出库，2、已出库/未入库，3、入库中 4、已入库 5、退回上级）
    params[@"e"] = @"";//出库流水号 --可不传
    params[@"f"] = @"";//出库ID--可不传
    params[@"g"] = @(2);//查询类型：1，订单；2，流水；0，全部 默认为0；
    params[@"h"] = self.startTime;//出库开始时间
    params[@"i"] = self.endTime;//出库结束时间
    params[@"j"] = @([TYLoginModel getPrimaryId]);//出库分销商ID默认当前登录用户ID
    params[@"k"] = self.keyWord;//入库分销商名称模糊搜索入库分销商名称
    
    NSString *url = [NSString stringWithFormat:@"%@mapi/mpsi/outStorageList",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            
            NSArray *arr = [TYOutStorageModel mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"e"]];
            [self.modelArray addObjectsFromArray:arr];
            
            self.page = self.page + 1;
            if (arr.count == self.limit) {
                self.myTableView.mj_footer.hidden = NO;
            }else{
                self.myTableView.mj_footer.hidden = YES;
            }
            if (self.modelArray.count != 0) {
                self.myTableView.editing = YES;
            }else{
                self.myTableView.editing = NO;
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


//【33 经销中心-发货管理-发货-分销商出库信息列表删除接口】
-(void)requestOutStorageInfoDeleted:(NSString *)code{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = code;//出库ID
    
    NSString *url = [NSString stringWithFormat:@"%@mapi/mpsi/OutStorageInfoDeleted",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            [TYShowHud showHudSucceedWithStatus:@"删除成功"];
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
    } orFailBlock:^(id error) {
        
    }];
}

@end
