//
//  TYTransactionRecordViewController.m
//  美界联盟
//
//  Created by LY on 2017/10/31.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYTransactionRecordViewController.h"
#import "TYRechargeCell.h"

@interface TYTransactionRecordViewController ()<UITableViewDelegate, UITableViewDataSource, TYGlobalSearchViewDelegate>
//余额
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
//总额
@property (weak, nonatomic) IBOutlet UILabel *TotalAmountLabel;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
/** 分页 */
@property (nonatomic, assign) NSInteger page;
/** 请求的条数 */
@property (nonatomic, assign) NSInteger limit;
/** 记录选择的类型 */
@property (nonatomic, assign) NSInteger type;

@end

@implementation TYTransactionRecordViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"交易记录" andTitleColor:[UIColor whiteColor] andImage:nil];
    [self setNavigationRightBtnImage:@"search"];
    
    //给头部的控件赋值
    self.balanceLabel.text = [NSString stringWithFormat:@"可充值余额￥%0.2lf",[TYLoginModel getPrepaidBalance]];
    //    self.TotalAmountLabel.text = [NSString stringWithFormat:@"（可下单总额￥%0.2lf）",[TYLoginModel getAvailableOrder]];
    self.TotalAmountLabel.hidden = YES;
    
    //初始化TableView
    [self setUpTableView];
}

//初始化TableView
-(void)setUpTableView{
    self.limit = 10;
    __weak typeof(&*self)weakSelf = self;
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf.modelArray removeAllObjects];
        [weakSelf requestCusResidualAmountLo:weakSelf.type];
    }];
    
    self.myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestCusResidualAmountLo:weakSelf.type];
    }];
    
    self.myTableView.mj_footer.hidden = YES;
    self.myTableView.showsVerticalScrollIndicator = NO;
    [self.myTableView.mj_header beginRefreshing];
    self.myTableView.tableFooterView = [UIView new];
    self.myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
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

#pragma mark -- 选择类型
- (IBAction)ClickChoose:(UIButton *)sender {
    NSArray *dataScoureS = @[@"全部",@"增加",@"减少"];
    CFPopOverView *popView = [[CFPopOverView alloc] initWithOrigin:CGPointMake(100, 185) titles:dataScoureS images:nil];
    
    __weak typeof(&*self)weakSelf = self;
    popView.selectRowAtIndex = ^(NSInteger rowIndex){
        
        [sender setTitle:dataScoureS[rowIndex] forState:UIControlStateNormal];
        weakSelf.page = 1;
        weakSelf.type = rowIndex;//1:增加；2：扣减；默认0全部
        weakSelf.myTableView.mj_footer.hidden = YES;
        [weakSelf.myTableView.mj_header beginRefreshing];
    };
    [popView show];
}

#pragma mark -- <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TYRechargeCell *cell = [TYRechargeCell CellTableView:self.myTableView];
    cell.RecordModel = self.modelArray[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
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
-(void)requestCusResidualAmountLo:(NSInteger)type{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = @(self.page);//分页页码
    params[@"c"] = @(self.limit);//分页数量
    params[@"d"] = @([TYLoginModel getPrimaryId]);//分销商ID
    params[@"e"] = @(type);//操作类型 1:增加；2：扣减；默认0，查全部
    params[@"f"] = self.startTime;//查询开始时间
    params[@"g"] = self.endTime;//查询结束时间
    
    NSString *url = [NSString stringWithFormat:@"%@MAPI/Recharge/CusResidualAmountLog",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            
            NSArray *arr = [TYTransactionRecordModel mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"e"]];
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
