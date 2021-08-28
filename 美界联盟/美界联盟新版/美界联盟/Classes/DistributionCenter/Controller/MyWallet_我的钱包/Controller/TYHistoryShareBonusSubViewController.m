//
//  TYHistoryShareBonusSubViewController.m
//  美界联盟
//
//  Created by LY on 2017/11/1.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYHistoryShareBonusSubViewController.h"
#import "TYShareBonusCell.h"

@interface TYHistoryShareBonusSubViewController ()

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation TYHistoryShareBonusSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpTableView];
}

//初始化TableView
-(void)setUpTableView{
    
    self.myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.myTableView.tableFooterView = [UIView new];
    self.myTableView.showsVerticalScrollIndicator = NO;
    
    __weak typeof(&*self)weakSelf = self;
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.modelArray removeAllObjects];
        //网络请求
        [weakSelf requestGetSelfDetailList];
    }];
    self.myTableView.mj_footer.hidden = YES;
    [self.myTableView.mj_header beginRefreshing];
}


#pragma mark -- <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TYShareBonusCell *cell = [TYShareBonusCell CellTableView:self.myTableView];
    if (self.modelArray.count == 0) {
        return cell;
    }
    cell.model = self.modelArray[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark --- 网络请求
//经销中心 个人分红金额明细
-(void)requestGetSelfDetailList{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = @([TYLoginModel getPrimaryId]);//分销商ID
    params[@"c"] = self.year;//默认当前年
    
    NSString *url;
    if (self.type == 1) {
        url = [NSString stringWithFormat:@"%@MAPI/MCus/GetSelfDetailList",APP_REQUEST_URL];
    }else{
        url = [NSString stringWithFormat:@"%@MAPI/MCus/GetTeamDetailList",APP_REQUEST_URL];
    }
    
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            
            NSArray *arr = [TYShareBonusModel mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"d"]];
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
