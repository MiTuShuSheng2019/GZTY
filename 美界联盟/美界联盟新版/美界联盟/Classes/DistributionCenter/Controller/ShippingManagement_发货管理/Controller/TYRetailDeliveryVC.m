//
//  TYRetailDeliveryVC.m
//  美界联盟
//
//  Created by LY on 2017/11/8.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYRetailDeliveryVC.h"
#import "TYRetailDeliveryCell.h"
#import "TYRetailOutStorageModel.h"
#import "TYRetailDeliveryDetailVC.h"
#import "TYNewLibraryInformationVC.h"

@interface TYRetailDeliveryVC ()<TYRetailDeliveryCellDelegate>
//零售总收入
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
/** 分页 */
@property (nonatomic, assign) NSInteger page;
/** 请求的条数 */
@property (nonatomic, assign) NSInteger limit;

@end

@implementation TYRetailDeliveryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"零售发货" andTitleColor:[UIColor whiteColor] andImage:nil];
    [self setNavigationRightBtnImage:@"search"];
    
    self.totalLabel.text = [NSString stringWithFormat:@"￥%0.2lf", [TYSingleton shareSingleton].totalRetailValue];
    
    [self setUpTableView];
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

//初始化TableView
-(void)setUpTableView{
    self.limit = 10;
    __weak typeof(&*self)weakSelf = self;
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf.modelArray removeAllObjects];
        [weakSelf requestRetailOutStorageListt];
    }];
    
    self.myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestRetailOutStorageListt];
    }];
    
    self.myTableView.mj_footer.hidden = YES;
    [self.myTableView.mj_header beginRefreshing];
    self.myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.myTableView.tableFooterView = [UIView new];
    self.myTableView.showsVerticalScrollIndicator = NO;
}


#pragma mark -- <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TYRetailDeliveryCell *cell = [TYRetailDeliveryCell CellTableView:self.myTableView];
    cell.delegate = self;
    cell.model = self.modelArray[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 155;
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

#pragma mark -- <TYRetailDeliveryCellDelegate>--- 查看详情
-(void)ClickLookDetail:(UIButton *)btn{
    TYRetailDeliveryCell *cell = (TYRetailDeliveryCell *)[[btn superview] superview];
    NSIndexPath *path = [self.myTableView indexPathForCell:cell];
    TYRetailDeliveryDetailVC *retailVc = [[TYRetailDeliveryDetailVC alloc] init];
    retailVc.model = self.modelArray[path.row];
    [self.navigationController pushViewController:retailVc animated:YES];
}

#pragma mark --- 新增出库信息
- (IBAction)ClickNewLibraryInformation {
    TYNewLibraryInformationVC *outVc = [[TYNewLibraryInformationVC alloc] init];
    [self.navigationController pushViewController:outVc animated:YES];
}

#pragma mark --- 网络请求
//38 经销中心-发货管理-零售发货列表
-(void)requestRetailOutStorageListt{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = @(self.page);//页码
    params[@"c"] = @(self.limit);//页大小
    params[@"d"] = @"";//销售流水号
    params[@"e"] = self.startTime;//开始时间
    params[@"f"] = self.endTime;//结束时间
  
    
    NSString *url = [NSString stringWithFormat:@"%@mapi/mpsi/retailOutStorageList",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            
            NSArray *arr = [TYTYRetailOutStorageBigModel mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"list"]];
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
