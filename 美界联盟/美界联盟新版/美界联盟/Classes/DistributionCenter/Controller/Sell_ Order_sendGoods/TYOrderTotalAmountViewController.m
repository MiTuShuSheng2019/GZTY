//
//  TYOrderTotalAmountViewController.m
//  美界联盟
//
//  Created by LY on 2017/10/30.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYOrderTotalAmountViewController.h"
#import "TYCommonHeadView.h"
#import "TYCommonCell.h"
#import "TYOrderPriceModel.h"

@interface TYOrderTotalAmountViewController ()<UITableViewDelegate, UITableViewDataSource, TYGlobalSearchViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
/** tableHeaderView */
@property (nonatomic, strong) TYCommonHeadView *headView;

@end

@implementation TYOrderTotalAmountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"订货总额" andTitleColor:[UIColor whiteColor] andImage:nil];
    [self setNavigationRightBtnImage:@"search"];
    
    [self setUpTableView];
    
}

//初始化TableView
-(void)setUpTableView{
    self.myTableView.tableFooterView = [UIView new];
    self.myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.myTableView.showsHorizontalScrollIndicator = NO;
    
    TYCommonHeadView *headView = [TYCommonHeadView CreatTYCommonHeadView];
    headView.height = 75;
    self.headView = headView;
    self.myTableView.tableHeaderView = headView;
    
    __weak typeof(&*self)weakSelf = self;
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf.modelArray removeAllObjects];
        [weakSelf requestGetCusSumOutData];
    }];
    self.myTableView.mj_footer.hidden = YES;
    [self.myTableView.mj_header beginRefreshing];
    
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

#pragma mark -- <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TYCommonCell *cell = [TYCommonCell CellTableView:self.myTableView];
    cell.OrderPriceModel = self.modelArray[indexPath.row];
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
//57 经销中心 根据产品分类获取订货价格
-(void)requestGetCusSumOutData{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];
    params[@"b"] = @([TYLoginModel getPrimaryId]);
    params[@"c"] = @"";//产品名称
    params[@"d"] = self.startTime;//开始时间
    params[@"e"] = self.endTime;//结束时间
    
    NSString *url = [NSString stringWithFormat:@"%@mapi/mpsi/GetOrderPriceByProd",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            NSArray *arr = [TYOrderPriceModel mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"e"]];
            [self.modelArray addObjectsFromArray:arr];
            
            NSString * str = (NSString *)[[respondObject objectForKey:@"c"] objectForKey:@"d"];
            if ([str isEqual:[NSNull null]]) {
                
                self.headView.priceLabel.text = [NSString stringWithFormat:@"%0.2lf", 0.00];
            }else{
                //d--总金额
                self.headView.priceLabel.text = [NSString stringWithFormat:@"%0.2lf",[[[respondObject objectForKey:@"c"] objectForKey:@"d"] doubleValue]];
            }
            
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
