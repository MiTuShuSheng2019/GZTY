//
//  TYDistributorsViewController.m
//  美界联盟
//
//  Created by LY on 2017/10/31.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYDistributorsViewController.h"
#import "TYDistributorsCell.h"
#import "TYOutboundGoodsViewController.h"
#import "TYDistributorsSearchVC.h"

@interface TYDistributorsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

/** 分页 */
@property (nonatomic, assign) NSInteger page;
/** 请求的条数 */
@property (nonatomic, assign) NSInteger limit;

@end

@implementation TYDistributorsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"分销商" andTitleColor:[UIColor whiteColor] andImage:nil];
    [self setNavigationRightBtnImage:@"search"];
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
        [weakSelf requestGetLowerCus];
    }];
    
    self.myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestGetLowerCus];
    }];
    
    self.myTableView.mj_footer.hidden = YES;
    [self.myTableView.mj_header beginRefreshing];
    self.myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.myTableView.tableFooterView = [UIView new];
    self.myTableView.showsVerticalScrollIndicator = NO;
}

#pragma mark -- 搜索
- (void)navigationRightBtnClick:(UIButton *)btn{
    
    TYDistributorsSearchVC *SearchVC = [[TYDistributorsSearchVC alloc] init];
    SearchVC.type = self.type;
    [self.navigationController pushViewController:SearchVC animated:YES];
}

#pragma mark --- <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TYDistributorsCell *cell = [TYDistributorsCell CellTableView:self.myTableView];
    cell.model = self.modelArray[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TYDistributorsModel *model = self.modelArray[indexPath.row];
    if (self.type == 1) {
        NSNotification *not = [[NSNotification alloc] initWithName:@"backTYLowerLevelRechargeViewController" object:nil userInfo:@{@"name":model}];
        
        [[NSNotificationCenter defaultCenter] postNotification:not];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        TYOutboundGoodsViewController *outVc = [[TYOutboundGoodsViewController alloc] init];
        outVc.orderID = [NSString stringWithFormat:@"%ld",model.ea];
        [self.navigationController pushViewController:outVc animated:YES];
    }
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
//13 经销中心-授权中心-获取下级分销商
-(void)requestGetLowerCus{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = @(self.page);//分页页码
    params[@"c"] = @(self.limit);//分页数量
    params[@"d"] = @([TYLoginModel getPrimaryId]);//分销商ID
    params[@"e"] = @(2);//下级分销商审核状态 0所有 1未审核、2已审核
    params[@"f"] = @(1);//下级分销商当前状态 0所有 1正常、2禁用
    params[@"g"] = @(0);//等级 只获取某一个等级的分销商 0 所有
    //    params[@"h"] = @(1);//是否仅仅获取直属下级 1:只查询自己的直属分销商,2:查询自己和直属分销商,3:查询自己和所有下级分销商，4：查询直属下级非同等级分销商（用于推荐升级），5：查询所有下级分销商
    if (self.type == 1) {
        params[@"h"] = @(6);
    }else{
        params[@"h"] = @(4);
    }
    
    params[@"i"] = @"";//分销商筛选条件 分销商名称、电话，微信模糊查询
    //    params[@"j"] = self.startTime;//审核开始时间
    //    params[@"k"] = self.endTime;//审核开始时间
    
    NSString *url = [NSString stringWithFormat:@"%@mapi/mcus/getLowerCus",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            NSArray *arr = [TYDistributorsModel mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"e"]];
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
