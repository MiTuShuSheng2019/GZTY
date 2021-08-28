//
//  DealerManagementViewController.m
//  美界联盟
//
//  Created by LY on 2017/11/7.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "DealerManagementViewController.h"
#import "TYDealerManagementCell.h"
#import "TYLowerCusModel.h"
#import "TYDealerDetailsViewController.h"

@interface DealerManagementViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *auditLabel;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
/** 分页 */
@property (nonatomic, assign) NSInteger page;
/** 请求的条数 */
@property (nonatomic, assign) NSInteger limit;

@end

@implementation DealerManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.width = KScreenWidth;
    [self setUpTableView];
    
    //接收到搜索的通知 搜索数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchData:) name:@"searchDealerManagementViewController" object:nil];
}

-(void)searchData:(NSNotification *)not{
    
    self.keyWord = [not.userInfo objectForKey:@"keyWord"];
    self.startTime = [not.userInfo objectForKey:@"startTime"];
    self.endTime = [not.userInfo objectForKey:@"endTime"];
    [self.myTableView.mj_header beginRefreshing];
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

#pragma mark -- <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TYDealerManagementCell *cell = [TYDealerManagementCell CellTableView:self.myTableView];
    if (self.type == 1) {
        [cell.isThroughBtn setTitle:@"待审核" forState:UIControlStateNormal];
    }else{
        [cell.isThroughBtn setTitle:@"已通过" forState:UIControlStateNormal];
    }
    cell.model = self.modelArray[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TYDealerDetailsViewController *detailsVc = [[TYDealerDetailsViewController alloc] init];
    detailsVc.model = self.modelArray[indexPath.row];
    [self.navigationController pushViewController:detailsVc animated:YES];
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
    params[@"e"] = @(self.type);//下级分销商审核状态 0所有 1未审核、2已审核
    params[@"f"] = @"0";//下级分销商当前状态0所有 1正常、2禁用
    params[@"g"] = @"0";//等级只获取某一个等级的分销商-- 0所有
    params[@"h"] = @(1);//是否仅仅获取直属下级1:只查询自己的直属分销商,2:查询自己和直属分销商,3:查询自己和所有下级分销商，4：查询直属下级非同等级分销商（用于推荐升级），5：查询所有下级分销商 默认1
    params[@"i"] = self.keyWord;//分销商筛选条件 分销商名称、电话，微信模糊查询
    params[@"j"] = self.startTime;//审核开始时间
    params[@"k"] = self.endTime;//审核结束时间
    
    NSString *url = [NSString stringWithFormat:@"%@mapi/mcus/getLowerCus",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            self.page = self.page + 1;
            
            NSArray *arr = [TYLowerCusModel mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"e"]];
            [self.modelArray addObjectsFromArray:arr];
            
            if (arr.count == self.limit) {
                self.myTableView.mj_footer.hidden = NO;
            }else{
                self.myTableView.mj_footer.hidden = YES;
            }
            if (self.type == 1) {
                self.auditLabel.text = [NSString stringWithFormat:@"待审核%@单", [[respondObject objectForKey:@"c"] objectForKey:@"count"]];
            }else if (self.type == 2){
                self.auditLabel.text = [NSString stringWithFormat:@"已审核%@单", [[respondObject objectForKey:@"c"] objectForKey:@"count"]];
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
