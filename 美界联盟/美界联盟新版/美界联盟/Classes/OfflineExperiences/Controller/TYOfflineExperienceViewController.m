//
//  TYOfflineExperienceViewController.m
//  美界联盟
//
//  Created by LY on 2017/10/23.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYOfflineExperienceViewController.h"
#import "TYOfflineNavView.h"
#import "TYOfflineNearbyHeadView.h"
#import "TYOfflineExperienceTableViewCell.h"
#import "AMovableButton.h"
#import "TYExpCenterModel.h"
#import "TYExperienceStoreDetailsVC.h"
#import "TYMyExperienceStoreVC.h"
#import "TYMyReservationVC.h"

@interface TYOfflineExperienceViewController ()<ABaiduMapManagerDelegate, BMKMapViewDelegate, ABaiduMapManagerDelegate, UITableViewDelegate, UITableViewDataSource, TYOfflineNavViewDelegate>
{
    ABaiduMapManager *baiduMapManager;
    CLLocation *_location;
}

/** UITableView */
@property (nonatomic, strong) UITableView *myTableView;
/** 分页 */
@property (nonatomic, assign) NSInteger page;
/** 请求的条数 */
@property (nonatomic, assign) NSInteger limit;
/** 搜索词 */
@property (nonatomic, strong) NSString *searchWord;

@end

 static NSString *const cellID = @"offlinelistcell";

@implementation TYOfflineExperienceViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [baiduMapManager startLocation];
    
    [self setNavigationView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.hidden = true;
    self.view.backgroundColor = [UIColor whiteColor];
    //搜索词初始为空
    self.searchWord = @"";
    //添加地图
    baiduMapManager = [ABaiduMapManager new];
    [baiduMapManager startLocation];
    baiduMapManager.aBaiduDelegate = self;
    [baiduMapManager initMapViewForView:self.view withFrame:CGRectMake(0, 64, KScreenWidth, KScreenWidth * 0.58) mapDelegate:self];
    
    [self.view addSubview:self.myTableView];
    
    //添加浮动图标，我的预约
    [self createMovableButton];
    
    //刷新数据
    [self refreshData];
}

#pragma mark -- 添加导航栏视图
-(void)setNavigationView{
    TYOfflineNavView *navView = [TYOfflineNavView showNavView];
    navView.frame = CGRectMake(0, 0, KScreenWidth, 64);
    navView.delegate = self;
    //如果体验店id不存在 隐藏我的体验店
    if ([TYLoginModel getExperienceId] == 0) {
        [navView.myShopButton updateConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(CGSizeMake(0, 0));
        }];
        navView.myShopButton.hidden = YES;
    }
    [self.view addSubview:navView];
}

#pragma mark -- <TYOfflineNavViewDelegate>
// 搜索
- (void)ClickSearch:(NSString *)content{
    self.searchWord = content;
    [self.myTableView.mj_header beginRefreshing];
}

// 我的店铺
- (void)ClickMyShop{
    TYMyExperienceStoreVC *storeVc = [[TYMyExperienceStoreVC alloc] init];
    [self.navigationController pushViewController:storeVc animated:YES];
}

#pragma mark pro ABaiduMapManagerDelegate 处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    //以下_mapView为BMKMapView对象
    if (!_location) {
        _location = userLocation.location;
    }
    _location = userLocation.location;
}

#pragma mark pro BMKMapViewDelegate 地图移动完成
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    @try{
        
    }@catch(NSException *e){
        [ABuyly buylyException:e methodName:NSStringFromSelector(_cmd)];
    };
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - 创建我的预约按钮
-(void)createMovableButton{
    CGFloat buttonW = 65;
    CGFloat buttonH = buttonW;
    CGFloat buttonX = [UIScreen mainScreen].bounds.size.width-buttonW-10;
    CGFloat buttonY = [UIScreen mainScreen].bounds.size.height-buttonH-60;
    AMovableButton *movableButton=[[AMovableButton alloc] init];
    movableButton.frame=CGRectMake(buttonX, buttonY, buttonW, buttonH);
    movableButton.titleLabel.numberOfLines = 2;
    movableButton.titleLabel.font = [UIFont systemFontOfSize:15];
    movableButton.backgroundColor = RGB(32, 135, 238);
    movableButton.layer.masksToBounds = YES;
    movableButton.layer.cornerRadius = buttonH/2;
    //点击事件
    [movableButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    //按钮图片
    [movableButton setTitle:@"我的\n预约" forState:UIControlStateNormal];
    [self.view addSubview:movableButton];
}

#pragma mark - 我的预约按钮事件
-(void)buttonClick{
    TYMyReservationVC *reservationVc = [[TYMyReservationVC alloc] init];
    [self.navigationController pushViewController:reservationVc animated:YES];
}

//初始化TableView
-(void)refreshData{
    self.limit = 10;
    __weak typeof(&*self)weakSelf = self;
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf.modelArray removeAllObjects];
        [weakSelf requestExpCenterList];
    }];
    
    self.myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestExpCenterList];
    }];
    
    self.myTableView.mj_footer.hidden = YES;
    [self.myTableView.mj_header beginRefreshing];
    self.myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.myTableView.tableFooterView = [UIView new];
    self.myTableView.showsVerticalScrollIndicator = NO;
}

#pragma mark <UITableViewDelegate, UITableViewDataSource>
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    TYOfflineNearbyHeadView *headView = [TYOfflineNearbyHeadView showHeadView];
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TYOfflineExperienceTableViewCell *cell = [TYOfflineExperienceTableViewCell CellTableView:tableView];
    cell.model = self.modelArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TYExperienceStoreDetailsVC *stroeVc = [[TYExperienceStoreDetailsVC alloc] init];
    stroeVc.model = self.modelArray[indexPath.row];
    [self.navigationController pushViewController:stroeVc animated:YES];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
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


#pragma mark -- 网络请求
//【84 线下体验 获取体验店列表】
- (void)requestExpCenterList{
    
    NSDictionary *params = @{
                             @"a":@(self.page), //分页
                             @"b":@(self.limit), //每页大小
                             @"c":[NSString stringWithFormat:@"%lf", _location.coordinate.longitude], //经度
                             @"d":[NSString stringWithFormat:@"%lf", _location.coordinate.latitude],//纬度
                             @"e":self.searchWord, //查询关键字可根据体验店名称、联系人、电话进行搜索
                             };
    NSString *url = [NSString stringWithFormat:@"%@MAPI/Exp/GetExpCenterList",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            
            NSArray *arr = [TYExpCenterModel mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"e"]];
            [self.modelArray addObjectsFromArray:arr];
            
            self.page = self.page + 1;
            if (arr.count < self.limit) {
                self.myTableView.mj_footer.hidden = YES;
            }else{
                self.myTableView.mj_footer.hidden = NO;
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

#pragma mark -- 懒加载
- (UITableView *) myTableView
{
    if (!_myTableView) {
        CGFloat tabH;
        if ([TYDevice systemVersion] < 11.0) {
            tabH = KScreenHeight - 104 - KScreenWidth * 0.5;
        }else{
            tabH = KScreenHeight - 64 - KScreenWidth * 0.5;
        }
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + KScreenWidth * 0.5, KScreenWidth, tabH) style:UITableViewStylePlain];
        _myTableView.backgroundColor = RGB(238, 238, 238);
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.tableFooterView = [UIView new];
        _myTableView.showsVerticalScrollIndicator = NO;
        //去掉cell分割线
        _myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    }
    return _myTableView;
}

@end

