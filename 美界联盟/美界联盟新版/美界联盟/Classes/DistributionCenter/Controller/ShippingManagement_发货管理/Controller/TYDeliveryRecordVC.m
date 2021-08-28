//
//  TYDeliveryRecordVC.m
//  美界联盟
//
//  Created by LY on 2017/11/8.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYDeliveryRecordVC.h"
#import "TYDeliveryRecordCell.h"
#import "TYDeliveryRecordModel.h"
#import "TYLuxuryHeadTitleView.h"
#import "TYLogisticsInformationVC.h"
#import "TYDetailViewController.h"

@interface TYDeliveryRecordVC ()<UITableViewDelegate, UITableViewDataSource,TYDeliveryRecordCellDelegate, TYGlobalSearchViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *totleLabel;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
/** 分页 */
@property (nonatomic, assign) NSInteger page;
/** 请求的条数 */
@property (nonatomic, assign) NSInteger limit;

@end

@implementation TYDeliveryRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"发货记录" andTitleColor:[UIColor whiteColor] andImage:nil];
    [self setNavigationRightBtnImage:@"search"];
    
    self.totleLabel.text = [NSString stringWithFormat:@"￥%0.2lf",[TYSingleton shareSingleton].totalDelivery];
    
    [self setUpTableView];
}

//初始化TableView
-(void)setUpTableView{
    self.limit = 10;
    __weak typeof(&*self)weakSelf = self;
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf.modelArray removeAllObjects];
        [weakSelf requestOutStorageList];
    }];
    
    self.myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestOutStorageList];
    }];
    
    self.myTableView.mj_footer.hidden = YES;
    [self.myTableView.mj_header beginRefreshing];
    self.myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.myTableView.tableFooterView = [UIView new];
    self.myTableView.showsVerticalScrollIndicator = NO;
}

#pragma mark -- 搜索
- (void)navigationRightBtnClick:(UIButton *)btn{
    TYGlobalSearchView *SearchView = [TYGlobalSearchView CreatTYGlobalSearchView];
    SearchView.delegate = self;
    SearchView.frame = CGRectMake(0, 20, KScreenWidth, KScreenHeight);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:SearchView];
}

#pragma mark -- <TYGlobalSearchViewDelegate>
-(void)ClickSearch:(NSString *)KeyWord andStartTime:(NSString *)startTime andEndTime:(NSString *)endTime{
    self.keyWord = KeyWord;
    self.startTime = startTime;
    self.endTime = endTime;
    [self.myTableView.mj_header beginRefreshing];
}


#pragma mark -- <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TYDeliveryRecordCell *cell = [TYDeliveryRecordCell CellTableView:self.myTableView];
    cell.model = self.modelArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 175;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    static NSString *identifyHead = @"Hcell";
    TYLuxuryHeadTitleView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifyHead];
    if (!headerView) {
        headerView = [[TYLuxuryHeadTitleView alloc] initWithReuseIdentifier:identifyHead];
        [headerView setFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    }
    headerView.contentView.backgroundColor = [UIColor whiteColor];
    headerView.titleLab.text = @"发货记录";
    headerView.titleLab.textColor = [UIColor blackColor];
    return headerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
//查看详情
-(void)ClickLookDetail:(UIButton *)btn{
    TYDeliveryRecordCell *cell = (TYDeliveryRecordCell *)[[btn superview] superview];
    NSIndexPath *path = [self.myTableView indexPathForCell:cell];
    TYDeliveryRecordModel *model = self.modelArray[path.row];
    TYDetailViewController *vc = [[TYDetailViewController alloc] init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

//查看物流
-(void)ClickLookLogistic:(UIButton *)btn{
    TYDeliveryRecordCell *cell = (TYDeliveryRecordCell *)[[btn superview] superview];
    NSIndexPath *path = [self.myTableView indexPathForCell:cell];
    TYDeliveryRecordModel *model = self.modelArray[path.row];
    TYLogisticsInformationVC *vc = [[TYLogisticsInformationVC alloc] init];
    vc.logisticsName = model.ej;
    vc.sheetCode = model.ek;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --- 网络请求
//25 经销中心-发货管理-发货记录
-(void)requestOutStorageList{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = @(self.page);//页码
    params[@"c"] = @(self.limit);//页大小
    params[@"d"] = @(4);//出库单状态（ 1、预出库，2、已出库/未入库，3、入库中 4、已入库 5、退回上级）
    params[@"g"] = @(0);//查询类型：1，订单；2，流水；0，全部 默认为0；
    params[@"h"] = self.startTime;//出库开始时间
    params[@"i"] = self.endTime;//出库结束时间
    params[@"j"] = @([TYLoginModel getPrimaryId]);//出库分销商ID--默认当前登录用户ID
    params[@"k"] = self.keyWord;//入库分销商名称--模糊搜索入库分销商名称
    
    NSString *url = [NSString stringWithFormat:@"%@mapi/mpsi/outStorageList",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            
            NSArray *arr = [TYDeliveryRecordModel mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"e"]];
            [self.modelArray addObjectsFromArray:arr];
            
            self.page = self.page + 1;
            if (arr.count == self.limit) {
                self.myTableView.mj_footer.hidden = NO;
            }else{
                self.myTableView.mj_footer.hidden = YES;
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


@end
