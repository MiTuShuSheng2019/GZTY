//
//  TYSendGoodsViewController.m
//  美界联盟
//
//  Created by LY on 2017/10/30.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYSendGoodsViewController.h"
#import "TYCommonHeadView.h"
#import "TYSendGoodsCell.h"


@interface TYSendGoodsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

/** 分页 */
@property (nonatomic, assign) NSInteger page;
/** 请求的条数 */
@property (nonatomic, assign) NSInteger limit;

@end

@implementation TYSendGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"待发货" andTitleColor:[UIColor whiteColor] andImage:nil];
    
    [self setUpTableView];
}

//初始化TableView
-(void)setUpTableView{
    self.myTableView.tableFooterView = [UIView new];
    self.myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.myTableView.showsHorizontalScrollIndicator = NO;
    
    TYCommonHeadView *headView = [TYCommonHeadView CreatTYCommonHeadView];
    headView.height = 75;
    headView.priceLabel.text = [NSString stringWithFormat:@"%0.2lf",[TYSingleton shareSingleton].totalAwaiting];
    self.myTableView.tableHeaderView = headView;
    
    self.limit = 10;
    __weak typeof(&*self)weakSelf = self;
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf.modelArray removeAllObjects];
        [weakSelf requestLowerOrderList];
    }];
    
    self.myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestLowerOrderList];
    }];
    
    self.myTableView.mj_footer.hidden = YES;
    [self.myTableView.mj_header beginRefreshing];
}

#pragma mark -- <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TYSendGoodsCell *cell = [TYSendGoodsCell CellTableView:self.myTableView];
    if (self.modelArray.count == 0) {
        return cell;
    }
    cell.model = self.modelArray[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}

#pragma mark --- 网络请求
-(void)requestLowerOrderList{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = @(self.page);//分页页码
    params[@"c"] = @(self.limit);//分页数量
    params[@"d"] = @([TYLoginModel getPrimaryId]);//分销商id
    params[@"e"] = @"2";//订单状态 1未审核,2:审核通过;3:未通过;4:订单出库;5:订单入库;6:订单完成;7:订单作废
    params[@"f"] = @"";//开始时间
    params[@"g"] = @"";//结束时间
    
    NSString *url = [NSString stringWithFormat:@"%@mapi/order/lowerOrderList",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            
            NSArray *arr = [TYAwaitingModel mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"e"]];
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
        [self.myTableView reloadData];
    } orFailBlock:^(id error) {
        [self.myTableView.mj_header endRefreshing];
    }];
}

@end
