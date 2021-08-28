//
//  TYTeamManagementViewController.m
//  美界联盟
//
//  Created by LY on 2017/11/7.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYTeamManagementViewController.h"
#import "TYTeamManagementModel.h"
#import "TYTeamManagementCell.h"
#import "TYMySuperiorViewController.h"
#import "TYTeamDetailsViewController.h"

@interface TYTeamManagementViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
//我的上级视图
@property (weak, nonatomic) IBOutlet UIView *MySupervisorView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *MySupervisorH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabViewH;

@end

@implementation TYTeamManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"团队管理" andTitleColor:[UIColor whiteColor] andImage:nil];
    
    [self requestGetLowerGradeStatistics];
    //赋值头像
    [self.headImageView setHead:[NSString stringWithFormat:@"%@%@",PhotoUrl,[TYLoginModel getPhoto]]];
    
    self.myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.myTableView.tableFooterView = [UIView new];
    self.myTableView.showsVerticalScrollIndicator = NO;
    
    //    if ([TYLoginModel getWhetherHeadquarters] == 1) {
    //总部是没有上级的
    //客服需求现在全部隐藏
    self.MySupervisorView.hidden = YES;
    self.MySupervisorH.constant = 0;
    self.tabViewH.constant = 0;
    //    }
}

#pragma mark -- <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TYTeamManagementCell *cell = [TYTeamManagementCell CellTableView:self.myTableView];
    cell.model = self.modelArray[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TYTeamDetailsViewController *teamVc = [[TYTeamDetailsViewController alloc] init];
    teamVc.model = self.modelArray[indexPath.row];
    [self.navigationController pushViewController:teamVc animated:YES];
}

- (UIImage *)xy_noDataViewImage {
    return [UIImage imageNamed:@"no_data"];
}

- (NSString *)xy_noDataViewMessage {
    return @"抱歉，暂无相关数据";
}

- (UIColor *)xy_noDataViewMessageColor {
    return RGB(170, 170, 170);
}

#pragma mark -- 点击我的上级
- (IBAction)ClickMySupervisor {
    TYMySuperiorViewController *myVc = [[TYMySuperiorViewController alloc] init];
    [self.navigationController pushViewController:myVc animated:YES];
}

#pragma mark --- 网络请求
//10 经销中心-授权中心-获取我的所有下级等级的人数统计
-(void)requestGetLowerGradeStatistics{
    [LoadManager showLoadingView:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = @([TYLoginModel getPrimaryId]);//分销商ID
    
    NSString *url = [NSString stringWithFormat:@"%@mapi/mcus/GetLowerGradeStatistics",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            
            NSArray *arr = [TYTeamManagementModel mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"f"]];
            [self.modelArray addObjectsFromArray:arr];
            
            self.numberLabel.text = [NSString stringWithFormat:@"团队总人数：（%@）",[[respondObject objectForKey:@"c"] objectForKey:@"d"]];
        }else{
            
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
        [self.myTableView reloadData];
        [LoadManager hiddenLoadView];
    } orFailBlock:^(id error) {
        [LoadManager hiddenLoadView];
    }];
}


@end
