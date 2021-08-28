//
//  TYRetailViewController.m
//  美界联盟
//
//  Created by LY on 2017/10/30.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYRetailViewController.h"
#import "TYCommonHeadView.h"
#import "TYCommonCell.h"

@interface TYRetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation TYRetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpTableView];
    
    //接收到搜索的通知 搜索数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchData:) name:@"searchRefresh" object:nil];
}

-(void)searchData:(NSNotification *)not{
    
    self.keyWord = [not.userInfo objectForKey:@"keyWord"];
    self.startTime = [not.userInfo objectForKey:@"startTime"];
    self.endTime = [not.userInfo objectForKey:@"endTime"];
    [self.myTableView.mj_header beginRefreshing];
}



//初始化TableView
-(void)setUpTableView{
    self.myTableView.tableFooterView = [UIView new];
    self.myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.myTableView.showsHorizontalScrollIndicator = NO;
    
    TYCommonHeadView *headView = [TYCommonHeadView CreatTYCommonHeadView];
    headView.height = 75;
    headView.priceLabel.text = [NSString stringWithFormat:@"%0.2lf",[TYSingleton shareSingleton].totalSales];
    self.myTableView.tableHeaderView = headView;
    
    __weak typeof(&*self)weakSelf = self;
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf.modelArray removeAllObjects];
        [weakSelf requestGetCusSumOutData];
    }];
    self.myTableView.mj_footer.hidden = YES;
    [self.myTableView.mj_header beginRefreshing];
}

#pragma mark -- <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TYCommonCell *cell = [TYCommonCell CellTableView:self.myTableView];
    cell.model = self.modelArray[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
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

#pragma mark --- 网络请求
//获取分销商零售出库汇总
-(void)requestGetCusSumOutData{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];
    params[@"b"] = @([TYLoginModel getPrimaryId]);
    params[@"c"] = self.keyWord;//产品名称
    params[@"d"] = self.startTime;//开始时间
    params[@"e"] = self.endTime;//结束时间
    
    NSString *url = [NSString stringWithFormat:@"%@mapi/mpsi/GetCusSaleSumOutData",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            NSArray *arr = [TYCusSumModel mj_objectArrayWithKeyValuesArray:[respondObject objectForKey:@"c"]];
            [self.modelArray addObjectsFromArray:arr];
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView reloadData];
    } orFailBlock:^(id error) {
        [self.myTableView.mj_header endRefreshing];
    }];
}

@end
