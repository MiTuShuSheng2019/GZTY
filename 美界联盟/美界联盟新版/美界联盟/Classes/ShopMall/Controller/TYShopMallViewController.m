//
//  TYShopMallViewController.m
//  美界联盟
//
//  Created by LY on 2017/10/23.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYShopMallViewController.h"
#import "TYProductDetailsViewController.h"
#import "TYShopMallHeadView.h"
#import "TYCustomTableHeadView.h"
#import "TYShopMallOneCell.h"
#import "TYShopMallTwoCell.h"
#import "TYHotProductModel.h"
#import "TYLoginChooseViewController.h"
#import "TYBannerModel.h"

#import "DETextScrollView.h"
#import "TYOpenWXVC.h"
#import "TYMakConListModel.h"
#import "DatePickerView.h"

@interface TYShopMallViewController ()<UITableViewDelegate, UITableViewDataSource, TYShopMallTwoCellDelegate, DETextScrollViewDelegate>

/** UITableView */
@property (nonatomic, strong) UITableView *myTableView;
/** 热销产品数组 */
@property (nonatomic, strong) NSMutableArray *hotArr;
/** 轮播图片数组 */
@property (nonatomic, strong) NSMutableArray *photoArr;
/** 头部视图 */
@property (nonatomic, strong) TYShopMallHeadView *headView;
/** 滚动text */
@property (nonatomic, strong) DETextScrollView *textScroll;
/** 滚动公告 */
@property (nonatomic, strong) NSDictionary *activeDict;

@end

@implementation TYShopMallViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
  
    [self activeFormInfo];
    
    if ([TYSingleton shareSingleton].consumer == 1) {
        [self setNavigationBarTitle:@"购物商城" andTitleColor:[UIColor whiteColor] andImage:nil];
    }else{
        [self setNavigationBarTitle:@"商城" andTitleColor:[UIColor whiteColor] andImage:nil];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    for (id tmpView in [self.view subviews]) {
        if ([tmpView isKindOfClass:[DETextScrollView class]]) {
            DETextScrollView *view = (DETextScrollView*)tmpView;
            if (view.tag == 110) {
                [view removeFromSuperview];
                break;
            }
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(238, 238, 238);
    
    //添加TableView的头部
    [self addHeadView];
    
    [self requestActiveFormInfo];
    
    __weak typeof(&*self)weakSelf = self;
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf.modelArray removeAllObjects];
        [weakSelf.hotArr removeAllObjects];
        
        [weakSelf requestProdlist];
        [weakSelf requestHotProdlist];
        [weakSelf requestBanner];
    }];
    
    self.myTableView.mj_footer.hidden = YES;
    [self.myTableView.mj_header beginRefreshing];
    //接收到登录成功的通知 刷新一下数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"refreshShopData" object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(everydayOnlyCallOnce) name:EVERYDAYONLYCALLONCE object:nil];
}

-(void)refreshData{
    [self.myTableView.mj_header beginRefreshing];
}

-(void)everydayOnlyCallOnce
{
    NSString* url = [NSString stringWithFormat:@"%@mapi/Intergral/MLogin",APP_REQUEST_URL];
    NSString* phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneTextFieldText"];
    if (!phone) {
        phone = @"";
    }
    NSDictionary* params = @{@"a":phone};
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"]integerValue] == TYRequestSuccessful) {
        }
    } orFailBlock:^(id error) {
    }];
    
    [self requestActiveFormInfo];
}

#pragma mark ----- 添加TableView的头部视图
-(void)addHeadView{
    TYShopMallHeadView *headView = [TYShopMallHeadView CreatTYShopMallHeadView];
    self.headView = headView;
    //分类栏的高度ClassifyH+分割线高度
    CGFloat ClassifyH = 95 + 10;
    headView.frame = CGRectMake(0, 0, KScreenWidth, 9 * KScreenWidth / 16 + ClassifyH);
    self.myTableView.tableHeaderView = headView;
}

#pragma mark -- <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (self.hotArr.count == 0) {
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
        TYShopMallOneCell *cell = [TYShopMallOneCell CellTableView:self.myTableView];
        cell.dataArr = self.hotArr;
//        [cell.myCollectionView reloadData];
        return cell;
    }else{
        TYShopMallTwoCell *cell = [TYShopMallTwoCell CellTableView:self.myTableView];
        cell.model = self.modelArray[indexPath.row];
        cell.delegate = self;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return (KScreenWidth - 40)/3 + 25 + 10;
    }else{
        return 90;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (self.hotArr.count == 0) {
            return 0;
        }else{
            return 30;
        }
    }else{
        if (self.modelArray.count == 0) {
            return 0;
        }else{
            return 30;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray *titleArr = @[@"热销产品",@"最新产品"];
    static NSString *identifyHead = @"Hcell";
    TYCustomTableHeadView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifyHead];
    if (!headerView) {
        headerView = [[TYCustomTableHeadView alloc] initWithReuseIdentifier:identifyHead];
        [headerView setFrame:CGRectMake(0, 0, KScreenWidth, 30)];
    }
    headerView.titleLab.text = titleArr[section];
    return headerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return;
    }else{
        TYHotProductModel *model = self.modelArray[indexPath.row];
        TYProductDetailsViewController *detailsVc = [[TYProductDetailsViewController alloc] init];
        detailsVc.model = model;
        [self.navigationController pushViewController:detailsVc animated:YES];
    }
}

#pragma mark -- <TYShopMallTwoCellDelegate>--分享
-(void)share:(UIButton *)btn{
    TYShopMallTwoCell *cell = (TYShopMallTwoCell *)[[btn superview] superview];
    NSIndexPath *path = [self.myTableView indexPathForCell:cell];
    TYHotProductModel *model = self.modelArray[path.row];
    TYShareView *shareV = [TYShareView CreatTYShareView];
    shareV.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    if ([TYLoginModel getPrimaryId] > 0) {
        //表示已经登录
        shareV.distributionID = [TYLoginModel getPrimaryId];
    }else{
        shareV.distributionID = 0;
    }
    shareV.prodcutID = model.ea;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:shareV];
}

#pragma mark -- 网络请求
//产品列表
-(void)requestProdlist{
    [LoadManager showLoadingView:self.view];
    NSString *url;NSDictionary *params;
    if ([TYSingleton shareSingleton].consumer == 1) {
        params = @{
                   @"c":[NSNumber numberWithInteger:2], //产品标签ID
                   @"e":[NSNumber numberWithInteger:1], //分页
                   @"f":[NSNumber numberWithInteger:10], //分页size
                   @"g":@"1"//PID
                   };
        url = [NSString stringWithFormat:@"%@MAPI/SM/SMProdList",APP_REQUEST_URL];
    }else{
        params = @{
                   @"a":[NSNumber numberWithInteger:1], //分页
                   @"b":[NSNumber numberWithInteger:10], //每页大小
                   @"c":@"0", //产品分类
                   @"d":[NSNumber numberWithInteger:2],//产品类型：2 最新1 热门
                   @"e":@"0", //PID
                   @"f":@"0" //结束时间
                   };
        url = [NSString stringWithFormat:@"%@mapi/mall/prodlist",APP_REQUEST_URL];
        
    }
    
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            NSArray *arr = [TYHotProductModel mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"e"]];
            [self.modelArray addObjectsFromArray:arr];
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
        
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView reloadData];
        [LoadManager hiddenLoadView];
    } orFailBlock:^(id error) {
        [self.myTableView.mj_header endRefreshing];
        [LoadManager hiddenLoadView];
    }];
}

//产品列表
-(void)requestHotProdlist{
    
    NSString *url;NSDictionary *params;
    if ([TYSingleton shareSingleton].consumer == 1) {
        params = @{
                   @"c":[NSNumber numberWithInteger:1], //产品类型：1 最新2 热门
                   @"e":[NSNumber numberWithInteger:1], //分页
                   @"f":[NSNumber numberWithInteger:10], //分页size
                   @"g":@"1"//PID
                   };
        url = [NSString stringWithFormat:@"%@MAPI/SM/SMProdList",APP_REQUEST_URL];
    }else{
        params = @{
                   @"a":[NSNumber numberWithInteger:1], //分页
                   @"b":[NSNumber numberWithInteger:10], //每页大小
                   @"c":@"0", //产品分类
                   @"d":[NSNumber numberWithInteger:1],//产品类型：1 最新2 热门
                   @"e":@"0", //PID
                   @"f":@"0" //结束时间
                   };
        url = [NSString stringWithFormat:@"%@mapi/mall/prodlist",APP_REQUEST_URL];
    }
    
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            NSArray *arr = [TYHotProductModel mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"e"]];
            [self.hotArr addObjectsFromArray:arr];
            
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView reloadData];
    } orFailBlock:^(id error) {
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView reloadData];
    }];
}

#pragma mark -- DETextScrollViewDelegate
-(void)DETextScrollViewShare
{
    TYOpenWXVC *vc = [[TYOpenWXVC alloc] init];
    vc.url = [_activeDict objectForKey:@"WebUrl"];
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)activeFormInfo
{
    NSString* nowDate = [NSString stringWithFormat:@"%ld",[TYDevice getDateDayNow]];
    NSString* ShowEndTime = [[self.activeDict objectForKey:@"ShowEndTime"]stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString* ShowStartTime = [[_activeDict objectForKey:@"ShowStartTime"]stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString* Content = [_activeDict objectForKey:@"Content"];
    NSString* ShowTime = [_activeDict objectForKey:@"ShowTime"];
    
    if ([DatePickerView date:nowDate isStartDate:ShowStartTime andEndDate:ShowEndTime dateFormatter:@"yyyyMMdd"]) {
        [self.textScroll setText:Content timer:[ShowTime integerValue]];
    }
}

-(void)requestActiveFormInfo
{
    NSString* urlStr = [NSString stringWithFormat:@"%@mapi/Intergral/GetAnnouncement",APP_REQUEST_URL];
    NSDictionary* p = @{@"a":@"q"};
    [TYNetworking postRequestURL:urlStr parameters:p andProgress:^(double progress) {
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"]integerValue] == TYRequestSuccessful) {
            self.activeDict = [respondObject objectForKey:@"c"];
            [self activeFormInfo];
        }
    } orFailBlock:^(id error) {
    }];
}
#pragma mark -- 网络请求轮播图
-(void)requestBanner{
    NSString *url;
    if ([TYSingleton shareSingleton].consumer == 1) {
        url = [NSString stringWithFormat:@"%@MAPI/SM/BannerList",APP_REQUEST_URL];
    }else{
        url = [NSString stringWithFormat:@"%@mapi/mall/banner",APP_REQUEST_URL];
    }
    
    NSDictionary *params =@{
                            @"a":@"0"//产品ID,如果取商城主轮播图不用传产品ID
                            };
    
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        [self.photoArr removeAllObjects];
        NSArray *arr = [TYBannerModel mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"e"]];
        for (TYBannerModel *model in arr) {
             NSString *imgUlr = [NSString stringWithFormat:@"%@%@",PhotoUrl,model.eb];
            [self.photoArr addObject:aliPic(imgUlr, kAliPicStr_150_150)];
           
//            [self.codeImageView sd_setImageWithURL:[NSURL URLWithString:aliPic(imgUlr, kAliPicStr_150_150)] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
            
        }
        //添加轮播图 可设置其代理监听图片的点击 此处暂时不需要
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KScreenWidth, self.headView.PhotoView.frame.size.height) delegate:nil placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
        cycleScrollView.backgroundColor = RGB(183, 183, 183);
        cycleScrollView.imageURLStringsGroup = self.photoArr;
        cycleScrollView.currentPageDotColor = [UIColor blueColor];
        cycleScrollView.pageDotColor = [UIColor blackColor];
        [self.headView.PhotoView addSubview:cycleScrollView];
        
    } orFailBlock:^(id error) {
        
    }];
}

#pragma mark -- 懒加载
- (UITableView *) myTableView
{
    if (!_myTableView) {
//        CGFloat tabH;
//        if ([TYDevice systemVersion] < 11.0) {
//            tabH = KScreenHeight - 104;
//        }else{
//            tabH = KScreenHeight - 64;
//        }
        CGFloat tabH;
        if (KIsiPhoneX == YES) {
            tabH = KScreenHeight - 88;
        }else{
            if ( [TYDevice systemVersion] < 11.0) {
                tabH = KScreenHeight - 104;
            }else{
                tabH = KScreenHeight - 64;
            }
        }
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, tabH) style:UITableViewStylePlain];
        _myTableView.backgroundColor = RGB(238, 238, 238);
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.tableFooterView = [UIView new];
        _myTableView.showsVerticalScrollIndicator = NO;
        //去掉cell分割线
        _myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [self.view addSubview:_myTableView];
    }
    return _myTableView;
}

-(DETextScrollView*)textScroll
{
    if (1) {
        _textScroll=[[DETextScrollView alloc]initWithFrame:CGRectMake(0, 10, KScreenWidth, 20)];
        _textScroll.tag = 110;
        _textScroll.delegate = self;
        [self.view addSubview:_textScroll];
    }
    return _textScroll;
}

- (NSMutableArray *) hotArr
{
    if (!_hotArr) {
        _hotArr = [NSMutableArray array];
    }
    return _hotArr;
}

- (NSMutableArray *) photoArr
{
    if (!_photoArr) {
        _photoArr = [NSMutableArray array];
    }
    return _photoArr;
}

- (NSDictionary *) activeDict
{
    if (!_activeDict) {
        _activeDict = [[NSDictionary alloc]init];
    }
    return _activeDict;
}

@end
