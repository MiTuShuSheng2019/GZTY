//
//  TYMyReservationVC.m
//  美界联盟
//
//  Created by LY on 2017/11/25.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYMyReservationVC.h"
#import "TYSearchMyReservationVC.h"
#import "TYReservationCell.h"
#import "TYExpOrderListModel.h"
#import "TYReservationDetailVC.h"
#import "TYCommentVC.h"

@interface TYMyReservationVC ()<UITableViewDelegate, UITableViewDataSource, TYReservationCellDelegate, BMKMapViewDelegate, ABaiduMapManagerDelegate>
{
    ABaiduMapManager *baiduMapManager;
    CLLocation *_location;
    NSString *startPosition;//起始位置
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
/** 分页 */
@property (nonatomic, assign) NSInteger page;
/** 请求的条数 */
@property (nonatomic, assign) NSInteger limit;

@end

@implementation TYMyReservationVC

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    baiduMapManager = [ABaiduMapManager new];
    [baiduMapManager startLocation];
    baiduMapManager.aBaiduDelegate = self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"我的预约" andTitleColor:[UIColor whiteColor] andImage:nil];
    [self setNavigationRightBtnImage:@"search"];
    
    [self setUpTableView];
}

//导航栏右边按钮被按下的触发事件
- (void)navigationRightBtnClick:(UIButton *)btn{
    TYSearchMyReservationVC *searchVc = [[TYSearchMyReservationVC alloc] init];
    [self.navigationController pushViewController:searchVc animated:YES];
}

//初始化TableView
-(void)setUpTableView{
    self.limit = 10;
    __weak typeof(&*self)weakSelf = self;
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf.modelArray removeAllObjects];
        [weakSelf requestExpOrderList];
    }];

    self.myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestExpOrderList];
    }];
    
    self.myTableView.mj_footer.hidden = YES;
    [self.myTableView.mj_header beginRefreshing];
    self.myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.myTableView.tableFooterView = [UIView new];
    self.myTableView.showsVerticalScrollIndicator = NO;
    
}

#pragma mark <UITableViewDelegate, UITableViewDataSource>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 310;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TYReservationCell *cell = [TYReservationCell CellTableView:self.myTableView];
    cell.model = self.modelArray[indexPath.row];
    cell.delegate = self;
    return cell;
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

#pragma mark --- <TYReservationCellDelegate>
//查看详情
-(void)ClicklookDetails:(UIButton *)btn{
    TYReservationCell *cell = (TYReservationCell *)[[[btn superview] superview] superview];
    NSIndexPath *path = [self.myTableView indexPathForCell:cell];
    TYReservationDetailVC *detailVc = [[TYReservationDetailVC alloc] init];
    TYExpOrderListModel *model = self.modelArray[path.row];
    detailVc.model = model;
    [self.navigationController pushViewController:detailVc animated:YES];
}

//导航
-(void)ClickNavigation:(UIButton *)btn{
    TYReservationCell *cell = (TYReservationCell *)[[[[btn superview] superview] superview] superview];
    NSIndexPath *path = [self.myTableView indexPathForCell:cell];
    TYExpOrderListModel *model = self.modelArray[path.row];
    
    BMKOpenDrivingRouteOption *opt = [[BMKOpenDrivingRouteOption alloc] init];
    
    opt.appScheme = @"baidumapsdk://mapsdk.baidu.com";
    //初始化起点节点
    BMKPlanNode *start = [[BMKPlanNode alloc]init];
    //坐标
    start.pt = _location.coordinate;
    
    start.name = startPosition;
    //指定起点
    opt.startPoint = start;
    
    //初始化终点节点
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    CLLocationCoordinate2D coor2;
    
    coor2.latitude = [model.en floatValue];
    coor2.longitude = [model.eo floatValue];
    end.pt = coor2;
    //指定终点名称
    end.name = model.ef;
//    end.cityName = [NSString stringWithFormat:@"%@%@",self.detailsModel.k,self.detailsModel.l];
    opt.endPoint = end;
    [BMKOpenRoute openBaiduMapDrivingRoute:opt];
}

#pragma mark pro ABaiduMapManagerDelegate 处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //以下_mapView为BMKMapView对象
    _location = userLocation.location;
    startPosition = userLocation.title;
}

//电话
-(void)ClickPhone:(UIButton *)btn{
    TYReservationCell *cell = (TYReservationCell *)[[[[btn superview] superview] superview] superview];
    NSIndexPath *path = [self.myTableView indexPathForCell:cell];
    TYExpOrderListModel *model = self.modelArray[path.row];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", model.eb]]];
}

//评论
-(void)ClickComment:(UIButton *)btn{
    TYReservationCell *cell = (TYReservationCell *)[[[btn superview] superview] superview];
    NSIndexPath *path = [self.myTableView indexPathForCell:cell];
    TYExpOrderListModel *model = self.modelArray[path.row];
    TYCommentVC *commentVc = [[TYCommentVC alloc] init];
    commentVc.model = model;
    [self.navigationController pushViewController:commentVc animated:YES];
}

#pragma mark -- 网路请求
//78 线下体验 获取预约单列表
- (void)requestExpOrderList{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//会话session
    params[@"b"] = @(self.page);//分页页码
    params[@"c"] = @(self.limit);//分页数量
    params[@"d"] = @([TYLoginModel getExperienceId]);//体验店ID
    params[@"e"] = @"";//预约人手机号码 可不填
    params[@"f"] = @(1);//预约单状态 状态：1：待接受，2：已接受，3：已体验，9：已取消
    params[@"g"] = [TYDevice getAPPID];//设备ID 可不填
    NSString *url = [NSString stringWithFormat:@"%@MAPI/Exp/ExpOrderList",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            NSArray *arr = [TYExpOrderListModel mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"e"]];
            [self.modelArray addObjectsFromArray:arr];
            self.page = self.page + 1;
            if (arr.count < self.limit) {
                self.myTableView.mj_footer.hidden = YES;
            }else{
                self.myTableView.mj_footer.hidden = NO;
            }
        }else{
            [TYShowHud showHudSucceedWithStatus:[respondObject objectForKey:@"b"]];
        }
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
        [self.myTableView reloadData];
    } orFailBlock:^(id error) {
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
    }];
}

@end
