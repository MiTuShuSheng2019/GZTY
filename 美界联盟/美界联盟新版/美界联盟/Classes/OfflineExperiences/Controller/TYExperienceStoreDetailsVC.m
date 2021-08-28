//
//  TYExperienceStoreDetailsVC.m
//  美界联盟
//
//  Created by LY on 2017/11/23.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYExperienceStoreDetailsVC.h"
#import "TYDetailsHeadView.h"
#import "TYDetailsTitleView.h"
#import "TYDetailsOneCell.h"
#import "TYDetailsTwoCell.h"
#import "TYCommentModel.h"
#import "TYBannerModel.h"
#import "TYMorePhotoCell.h"
#import "TYIWantAppointmentVC.h"

@interface TYExperienceStoreDetailsVC ()<UITableViewDelegate, UITableViewDataSource, TYDetailsHeadViewDelegate, BMKMapViewDelegate, ABaiduMapManagerDelegate>
{
    ABaiduMapManager *baiduMapManager;
    CLLocation *_location;
    NSString *startPosition;//起始位置
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
/** 标题数组 */
@property (nonatomic, strong) NSArray *titleArr;
/** 分页 */
@property (nonatomic, assign) NSInteger page;
/** 请求的条数 */
@property (nonatomic, assign) NSInteger limit;
/** 轮播图片数组 */
@property (nonatomic, strong) NSMutableArray *photoArr;
/** 更多图片图片数组 */
@property (nonatomic, strong) NSMutableArray *morePhotoArr;
/** 详情模型 */
@property (nonatomic, strong) TYExpCenterDetailModel *detailsModel;
/** 头部视图 */
@property (nonatomic, strong) TYDetailsHeadView *headView;

@end

@implementation TYExperienceStoreDetailsVC

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    baiduMapManager = [ABaiduMapManager new];
    [baiduMapManager startLocation];
    baiduMapManager.aBaiduDelegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"体验店详情" andTitleColor:[UIColor whiteColor] andImage:nil];
    
    self.titleArr = @[@"",@"服务项目",@"体验店简介",@"更多图片",@"评价"];
    
    [self setUpTableView];
}

//初始化TableView
-(void)setUpTableView{
    self.limit = 10;
    __weak typeof(&*self)weakSelf = self;
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf.modelArray removeAllObjects];
        [weakSelf requestCommentList];
    }];
    
    self.myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestCommentList];
    }];
    
    self.myTableView.mj_footer.hidden = YES;
    [self.myTableView.mj_header beginRefreshing];
    self.myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.myTableView.tableFooterView = [UIView new];
    self.myTableView.showsVerticalScrollIndicator = NO;
    
    //请求轮播图
    [self requestPicturetList];
    // 请求详情数据
    [self requestExpCenterDetail];
    //请求更多图片
    [self requestMorePhoto];
}

#pragma mark <UITableViewDelegate, UITableViewDataSource>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 9 * KScreenWidth / 16 + 170;
    }else if (indexPath.section == 1) {
        return 40;
    }else if (indexPath.section == 2){
        return self.detailsModel.cellH;
    }else if (indexPath.section == 3){
        return 120;
    }else{
        TYCommentModel *model = self.modelArray[indexPath.row];
        return model.cellH;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return self.detailsModel.s.count;
    }else if (section == 2){
        if (self.detailsModel.g.length == 0) {
            return 0;
        }else{
            return 1;
        }
        
    }else if (section == 3){
        if (self.morePhotoArr.count == 0) {
            return 0;
        }else{
            return 1;
        }
    }else{
        return self.modelArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *cellID = @"cellID";
        
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        TYDetailsHeadView *headView = [TYDetailsHeadView CreatTYDetailsHeadView];
        self.headView = headView;
        headView.delegate = self;
        headView.model = self.model;
        headView.frame = CGRectMake(0, 0, KScreenWidth, 9 * KScreenWidth / 16 + 170);
        [cell addSubview:headView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if (indexPath.section == 1 || indexPath.section == 2) {
        TYDetailsOneCell *cell = [TYDetailsOneCell CellTableView:tableView];
        if (indexPath.section == 1) {
            cell.serviceModel = self.detailsModel.s[indexPath.row];
        }else{
            cell.detailModel = self.detailsModel;
        }
        return cell;
    }else if (indexPath.section == 3){
        TYMorePhotoCell *cell = [TYMorePhotoCell CellTableView:self.myTableView];
        cell.morePhotoArr = self.morePhotoArr;
        return cell;
    }else{
        TYDetailsTwoCell *cell = [TYDetailsTwoCell CellTableView:self.myTableView];
        cell.model = self.modelArray[indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else if(section == 1){
        if (self.detailsModel.s.count == 0) {
            return 0;
        }else{
            return 50;
        }
    }else if (section == 2){
        if (self.detailsModel.g.length == 0) {
            return 0;
        }else{
            return 50;
        }
    }else if (section == 3){
        if (self.morePhotoArr.count == 0) {
            return 0;
        }else{
            return 50;
        }
    }else{
        if (self.modelArray.count == 0) {
            return 0;
        }else{
            return 50;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.titleArr.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    static NSString *identifyHead = @"Hcell";
    TYDetailsTitleView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifyHead];
    if (!headerView) {
        headerView = [[TYDetailsTitleView alloc] initWithReuseIdentifier:identifyHead];
        [headerView setFrame:CGRectMake(0, 0, KScreenWidth, 50)];
    }
    headerView.titleLab.text = self.titleArr[section];
    return headerView;
}

#pragma mark -- <TYDetailsHeadViewDelegate>
//导航
-(void)Navigation{
    
    //检测是否开启定位
    CLAuthorizationStatus type = [CLLocationManager authorizationStatus];
    if (![CLLocationManager locationServicesEnabled] || type == kCLAuthorizationStatusDenied){
        
        [TYAlertAction showTYAlertActionTitle:@"定位服务未开启" andMessage:@"请在手机设置中开启定位服务（设置->隐私->定位服务->开启）" andVc:nil andClick:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
        }];
        
    }
    
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
    
    coor2.latitude = [self.detailsModel.o floatValue];
    coor2.longitude = [self.detailsModel.n floatValue];
    end.pt = coor2;
    //指定终点名称
    end.name = self.detailsModel.m;
    end.cityName =
    [NSString stringWithFormat:@"%@%@",self.detailsModel.k,self.detailsModel.l];
    opt.endPoint = end;
    [BMKOpenRoute openBaiduMapDrivingRoute:opt];
}

#pragma mark pro ABaiduMapManagerDelegate 处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    //以下_mapView为BMKMapView对象
    _location = userLocation.location;
    startPosition = userLocation.title;
}

//拨打电话
-(void)CallPhone{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", self.model.ee]]];
}

//预约
-(void)MakeAppointment{
    TYIWantAppointmentVC *appointementVc = [[TYIWantAppointmentVC alloc] init];
    appointementVc.imgStr = [self.photoArr firstObject];
    appointementVc.contentArr = self.detailsModel.s;
    appointementVc.storID = self.model.ea;
    [self.navigationController pushViewController:appointementVc animated:YES];
}

#pragma mark -- 网路请求
//【83 线下体验 获取图片接口】
- (void)requestPicturetList{
    //获取轮播图
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = @(1);//页码
    params[@"c"] = @(10);//页大小
    params[@"d"] = @(self.model.ea);//体验店ID
    params[@"e"] = @(1);//图片类型 1=轮播图 2=介绍图 3=评论图
    
    NSString *url = [NSString stringWithFormat:@"%@MAPI/Exp/PicturetList",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            
            NSArray *arr = [TYBannerModel mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"e"]];
            for (TYBannerModel *model in arr) {
                [self.photoArr addObject:[NSString stringWithFormat:@"%@%@",PhotoUrl,model.eb]];
            }
            //添加轮播图 可设置其代理监听图片的点击 此处暂时不需要
            SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KScreenWidth, self.headView.photoView.frame.size.height) delegate:nil placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
            
            cycleScrollView.backgroundColor = RGB(183, 183, 183);
            cycleScrollView.imageURLStringsGroup = self.photoArr;
            cycleScrollView.currentPageDotColor = [UIColor blueColor];
            cycleScrollView.pageDotColor = [UIColor blackColor];
            [self.headView.photoView addSubview:cycleScrollView];
            
        }else{
            [TYShowHud showHudSucceedWithStatus:[respondObject objectForKey:@"b"]];
        }
        [self.myTableView reloadData];
    } orFailBlock:^(id error) {
        
    }];
}

//【83 线下体验 获取图片接口】
- (void)requestMorePhoto{
    //获取更多图片
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = @(1);//页码
    params[@"c"] = @(10);//页大小
    params[@"d"] = @(self.model.ea);//体验店ID
    params[@"e"] = @(2);//图片类型 1=轮播图 2=介绍图 3=评论图
    
    NSString *url = [NSString stringWithFormat:@"%@MAPI/Exp/PicturetList",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            
            NSArray *arr = [TYBannerModel mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"e"]];
            for (TYBannerModel *model in arr) {
                [self.morePhotoArr addObject:[NSString stringWithFormat:@"%@%@",PhotoUrl,model.eb]];
            }
            
        }else{
            [TYShowHud showHudSucceedWithStatus:[respondObject objectForKey:@"b"]];
        }
        [self.myTableView reloadData];
    } orFailBlock:^(id error) {
        
    }];
}

//【【85 线下体验 体验店详情】
- (void)requestExpCenterDetail{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"b"] = @(self.model.ea);//体验店ID
    
    NSString *url = [NSString stringWithFormat:@"%@MAPI/Exp/GetExpCenterDetail",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            self.detailsModel = [TYExpCenterDetailModel mj_objectWithKeyValues:[respondObject objectForKey:@"c"]];
            
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
        [self.myTableView reloadData];
    } orFailBlock:^(id error) {
        
    }];
}

//【87 线下体验 获取评论列表】
- (void)requestCommentList{
    //回去轮播图
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"b"] = @(self.page);//页码
    params[@"c"] = @(self.limit);//页大小
    params[@"d"] = @(self.model.ea);//体验店ID
    
    NSString *url = [NSString stringWithFormat:@"%@MAPI/Exp/CommentList",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            NSArray *arr = [TYCommentModel mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"e"]];
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
- (NSMutableArray *) photoArr
{
    if (!_photoArr) {
        _photoArr = [NSMutableArray array];
    }
    return _photoArr;
}

- (NSMutableArray *) morePhotoArr
{
    if (!_morePhotoArr) {
        _morePhotoArr = [NSMutableArray array];
    }
    return _morePhotoArr;
}


@end
