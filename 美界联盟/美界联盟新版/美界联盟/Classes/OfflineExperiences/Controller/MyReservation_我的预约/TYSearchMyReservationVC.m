//
//  TYSearchMyReservationVC.m
//  美界联盟
//
//  Created by LY on 2017/11/25.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYSearchMyReservationVC.h"
#import "TYReservationCell.h"
#import "TYExpOrderListModel.h"
#import "TYReservationDetailVC.h"
#import "TYCommentVC.h"

@interface TYSearchMyReservationVC ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, TYReservationCellDelegate, BMKMapViewDelegate, ABaiduMapManagerDelegate>
{
    ABaiduMapManager *baiduMapManager;
    CLLocation *_location;
    NSString *startPosition;//起始位置
}
@property (nonatomic,strong) UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation TYSearchMyReservationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationRightBtnText:@"取消" andTextColor:[UIColor whiteColor]];
    [self setUpTableView];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.searchBar endEditing:YES];
    [self.searchBar removeFromSuperview];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.autoresizingMask = UIViewAutoresizingNone;
    [self createSearchBar];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    baiduMapManager = [ABaiduMapManager new];
    [baiduMapManager startLocation];
    baiduMapManager.aBaiduDelegate = self;
}


//初始化TableView
-(void)setUpTableView{
    
    self.myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.myTableView.tableFooterView = [UIView new];
    self.myTableView.showsVerticalScrollIndicator = NO;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.searchBar endEditing:YES];
}
//------创建SearchBar-----
-(void)createSearchBar{
    
    self.navigationItem.hidesBackButton = YES;
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0.0, 0.0, KScreenWidth - 54.0, 44.0)];
    
    self.searchBar.delegate  = self;
    self.searchBar.barStyle = UIBarStyleDefault;
    self.searchBar.placeholder = @"请输入手机号查询";
    self.searchBar.searchBarStyle = UISearchBarStyleDefault;
    [self.searchBar becomeFirstResponder];
    [self.navigationController.navigationBar addSubview:self.searchBar];
}

//导航栏右边按钮被按下的触发事件
- (void)navigationRightBtnClick:(UIButton *)btn{
    [self.searchBar endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark <UISearchBarDelegate>----------开始搜索
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length >= 1) {
        [self.modelArray removeAllObjects];
        [self requestExpOrderList:searchText];
    }
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.searchBar endEditing:YES];
}

#pragma mark --- <TYReservationCellDelegate>
//查看详情
-(void)ClicklookDetails:(UIButton *)btn{
    [self.searchBar endEditing:YES];
    TYReservationCell *cell = (TYReservationCell *)[[[btn superview] superview] superview];
    NSIndexPath *path = [self.myTableView indexPathForCell:cell];
    TYReservationDetailVC *detailVc = [[TYReservationDetailVC alloc] init];
    TYExpOrderListModel *model = self.modelArray[path.row];
    detailVc.model = model;
    [self.navigationController pushViewController:detailVc animated:YES];
}

//导航
-(void)ClickNavigation:(UIButton *)btn{
    [self.searchBar endEditing:YES];
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
    [self.searchBar endEditing:YES];
    TYReservationCell *cell = (TYReservationCell *)[[[[btn superview] superview] superview] superview];
    NSIndexPath *path = [self.myTableView indexPathForCell:cell];
    TYExpOrderListModel *model = self.modelArray[path.row];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", model.eb]]];
}

//评论
-(void)ClickComment:(UIButton *)btn{
    [self.searchBar endEditing:YES];
    TYReservationCell *cell = (TYReservationCell *)[[[btn superview] superview] superview];
    NSIndexPath *path = [self.myTableView indexPathForCell:cell];
    TYExpOrderListModel *model = self.modelArray[path.row];
    TYCommentVC *commentVc = [[TYCommentVC alloc] init];
    commentVc.model = model;
    [self.navigationController pushViewController:commentVc animated:YES];
}

#pragma mark -- 网路请求
//78 线下体验 获取预约单列表
- (void)requestExpOrderList:(NSString *)searchStr{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//会话session
    params[@"b"] = @(1);//分页页码
    params[@"c"] = @(100);//分页数量
    params[@"d"] = @([TYLoginModel getExperienceId]);//体验店ID
    params[@"e"] = searchStr;//预约人手机号码 可不填
    params[@"f"] = @(1);//预约单状态 状态：1：待接受，2：已接受，3：已体验，9：已取消
    params[@"g"] = [TYDevice getAPPID];//设备ID 可不填
    NSString *url = [NSString stringWithFormat:@"%@MAPI/Exp/ExpOrderList",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            NSArray *arr = [TYExpOrderListModel mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"e"]];
            [self.modelArray addObjectsFromArray:arr];
            
        }else{
//            [TYShowHud showHudSucceedWithStatus:[respondObject objectForKey:@"b"]];
        }
        
        [self.myTableView reloadData];
    } orFailBlock:^(id error) {
    }];
}

@end
