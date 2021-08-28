//
//  TYLuxuryCarViewController.m
//  美界联盟
//
//  Created by LY on 2017/11/1.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYLuxuryCarViewController.h"
#import "TYLuxuryHeadTitleView.h"
#import "TYShareBonusCell.h"
#import "TYLuxuryCarCell.h"
#import "TYAmountModel.h"
#import "TYChoosePrizeViewController.h"
#import "TYForRecordViewController.h"

@interface TYLuxuryCarViewController ()<UITableViewDelegate, UITableViewDataSource>
//销售总额
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
/** 标题数组 */
@property (nonatomic, strong) NSArray *titleArr;
/** 年份数组 */
@property (nonatomic, strong) NSMutableArray *yearArr;
/** 分页 */
@property (nonatomic, assign) NSInteger page;
/** 请求的条数 */
@property (nonatomic, assign) NSInteger limit;

@end

@implementation TYLuxuryCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"季度豪车奖" andTitleColor:[UIColor whiteColor] andImage:nil];
    [self setNavigationRightBtnText:@"兑换记录" andTextColor:[UIColor whiteColor]];
    
    [self setUpTableView];
}

#pragma mark -- 导航栏右边按钮被按下的触发事件
- (void)navigationRightBtnClick:(UIButton *)btn{
    TYForRecordViewController *forVc = [[TYForRecordViewController alloc] init];
    [self.navigationController pushViewController:forVc animated:YES];
}

//初始化TableView
-(void)setUpTableView{
    
    self.titleArr = [NSArray arrayWithObjects:@"季度销售记录", @"豪车奖励", nil];
    
    self.myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.myTableView.tableFooterView = [UIView new];
    self.myTableView.showsVerticalScrollIndicator = NO;
    self.limit = 10;
    
    __weak typeof(&*self)weakSelf = self;
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf.modelArray removeAllObjects];
        //网络请求
        [weakSelf requestGetEventDetailList];
    }];
    
    self.myTableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [weakSelf requestGetEventDetailList];
    }];
    
    self.myTableView.mj_footer.hidden = YES;
    [self.myTableView.mj_header beginRefreshing];
    //请求经销中心 豪车达标后销售金额明细
    [self requestGetEventAmountByQu];
    //经销中心 豪车达标后销售金额
    [self requestGetEventSaleAmount];
}

#pragma mark -- <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.yearArr.count + 1;
        
    }else{
        return self.modelArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        TYShareBonusCell *cell = [TYShareBonusCell CellTableView:self.myTableView];
        if (indexPath.row == 0) {
            cell.quarterLabel.text = @"年份";
            cell.salesAmountLabel.text = @"季度";
            cell.myBonusLabel.text = @"销售金额";
        }else{
            cell.carModel = self.yearArr[indexPath.row - 1];
        }
        return cell;
    }else {
        TYLuxuryCarCell *cell = [TYLuxuryCarCell CellTableView:self.myTableView];
        cell.model = self.modelArray[indexPath.row];
        return cell;
    }
}

#pragma mark -- <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 ) {
        return 50;
    }else{
        TYLuxuryEventDetail *model = self.modelArray[indexPath.row];
        return model.cellH;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
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
    headerView.titleLab.text = self.titleArr[section];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        TYChoosePrizeViewController *chooseVc = [[TYChoosePrizeViewController alloc] init];
        chooseVc.model = self.modelArray[indexPath.row];
        [self.navigationController pushViewController:chooseVc animated:YES];
    }
    
}

#pragma mark --- 网络请求
//77 经销中心 豪车达标后销售金额明细
-(void)requestGetEventAmountByQu{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = @([TYLoginModel getPrimaryId]);//分销商ID
    
    NSString *url = [NSString stringWithFormat:@"%@MAPI/MCus/GetEventAmountByQu",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            NSArray *arr = [TYLuxuryCarYear mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"d"]];
            [self.yearArr addObjectsFromArray:arr];
            
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
        [self.myTableView reloadData];
    } orFailBlock:^(id error) {
        
    }];
}

//76 经销中心 豪车达标后销售金额
-(void)requestGetEventSaleAmount{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = @([TYLoginModel getPrimaryId]);//分销商ID
    
    NSString *url = [NSString stringWithFormat:@"%@MAPI/MCus/GetEventSaleAmount",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            self.priceLabel.text = [NSString stringWithFormat:@"￥%@",[[respondObject objectForKey:@"c"] objectForKey:@"d"]];
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
        
    } orFailBlock:^(id error) {
    }];
}

//68 经销中心 获取活动明细
-(void)requestGetEventDetailList{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = @(self.model.da);//活动PKID
    params[@"c"] = @(self.page);//分页index
    params[@"d"] = @(self.limit);//分页size
    params[@"e"] = @([TYLoginModel getPrimaryId]);//分销商ID
    
    NSString *url = [NSString stringWithFormat:@"%@MAPI/MCus/GetEventDetailList",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            
            NSArray *arr = [TYLuxuryEventDetail mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"d"]];
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

#pragma mark -- 懒加载
- (NSMutableArray *) yearArr
{
    if (!_yearArr) {
        _yearArr = [NSMutableArray array];
    }
    return _yearArr;
}

@end
