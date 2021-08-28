//
//  TYRebateManagementViewController.m
//  美界联盟
//
//  Created by LY on 2017/10/31.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYRebateManagementViewController.h"
#import "TYRebateManagementOneCell.h"
#import "TYRebateManagementTwoCell.h"
#import "TYRebateManagementThreeCell.h"
#import "TYShareBonusViewController.h"
#import "TYLuxuryCarViewController.h"

@interface TYRebateManagementViewController ()<UITableViewDelegate, UITableViewDataSource, TYRebateManagementTwoCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
/** 差额汇总数组 */
@property (nonatomic, strong) NSMutableArray *oneArr;
/** 返利金额汇总数组 */
@property (nonatomic, strong) NSMutableArray *twoArr;
/** 获取活动列表(当前可认为只有豪车奖)数组 */
@property (nonatomic, strong) NSMutableArray *threeArr;

@end

@implementation TYRebateManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"返利管理" andTitleColor:[UIColor whiteColor] andImage:nil];
    
    self.myTableView.showsVerticalScrollIndicator = NO;
    self.myTableView.tableFooterView = [UIView new];
    self.myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    //请求差额汇总
    [self requestGetDiffPrice];
    //请求返利金额汇总
    [self requestGetAmountList];
    //获取活动列表(当前可认为只有豪车奖
    [self requestGetEventList];
    
    [LoadManager showLoadingView:self.view];
}

#pragma mark -- <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.oneArr.count;
    }else if (section == 1){
        return self.twoArr.count;
    }else{
        return self.threeArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        TYRebateManagementOneCell *cell = [TYRebateManagementOneCell CellTableView:self.myTableView];
        cell.model = self.oneArr[indexPath.row];
        cell.hidden = YES;
        return cell;
    }else if (indexPath.section == 1){
        TYRebateManagementTwoCell *cell = [TYRebateManagementTwoCell CellTableView:self.myTableView];
        cell.delegate = self;
        cell.model = self.twoArr[indexPath.row];
        return cell;
    }else{
        TYRebateManagementThreeCell *cell = [TYRebateManagementThreeCell CellTableView:self.myTableView];
        cell.model = self.threeArr[indexPath.row];

        //给总金额--时间--赋值
        TYAmountModel *amountModle = [self.twoArr firstObject];
        cell.totalAmountLabel.text = [NSString stringWithFormat:@"￥%0.2lf",amountModle.f];
        cell.timeLabel.text = [NSString stringWithFormat:@"%@-%@",amountModle.h,amountModle.i];
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
//         return 190;
        return 0;//根据需求隐藏了头部cell
    }else if (indexPath.section == 1){
        return 250;
    }else{
        TYEventModel *model = self.threeArr[indexPath.row];
        return model.cellH;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        TYLuxuryCarViewController *carVc = [[TYLuxuryCarViewController alloc] init];
        carVc.model = [self.threeArr firstObject];
        [self.navigationController pushViewController:carVc animated:YES];
    }
}

#pragma mark -- <TYRebateManagementTwoCellDelegate>
//点击我的分红
-(void)ClickMyDividend:(UIButton *)btn{
    
    TYShareBonusViewController *ShareVc = [[TYShareBonusViewController alloc] init];
    ShareVc.amountModle = [self.twoArr firstObject];
    ShareVc.type = 1;
    [self.navigationController pushViewController:ShareVc animated:YES];
    
}

//点击团队分红
-(void)ClickTeamDividend:(UIButton *)btn{
    TYShareBonusViewController *ShareVc = [[TYShareBonusViewController alloc] init];
    ShareVc.amountModle = [self.twoArr firstObject];
    ShareVc.type = 2;
    [self.navigationController pushViewController:ShareVc animated:YES];
}


#pragma mark -- 网络请求
//经销中心 差额汇总
-(void)requestGetDiffPrice{
    
    @try{
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"a"] = [TYLoginModel getSessionID];//回话session
        params[@"b"] = @([TYLoginModel getPrimaryId]);//分销商ID
        
        NSString *url = [NSString stringWithFormat:@"%@mapi/mpsi/GetDiffPrice",APP_REQUEST_URL];
        [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
            
        } withSuccessBlock:^(id respondObject) {
            if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
                
                NSArray *arr = [TYDiffPriceModel mj_objectArrayWithKeyValuesArray:[respondObject objectForKey:@"c"]];
                [self.oneArr addObjectsFromArray:arr];
                
            }else{
                [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
            }
            [self.myTableView reloadData];
        } orFailBlock:^(id error) {
            
        }];
    }@catch(NSException *e){
        [ABuyly buylyException:e methodName:NSStringFromSelector(_cmd)];
    };
}

//返利金额汇总
-(void)requestGetAmountList{
    @try{
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"a"] = [TYLoginModel getSessionID];//回话session
        params[@"b"] = @([TYLoginModel getPrimaryId]);//分销商ID
        
        NSString *url = [NSString stringWithFormat:@"%@MAPI/MCus/GetAmountList",APP_REQUEST_URL];
        [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
            
        } withSuccessBlock:^(id respondObject) {
            
            if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
                
                NSArray *arr = [TYAmountModel mj_objectArrayWithKeyValuesArray:[respondObject objectForKey:@"c"]];
                [self.twoArr addObjectsFromArray:arr];
                
            }else{
                [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
            }
            [self.myTableView reloadData];
        } orFailBlock:^(id error) {
            
        }];
    }@catch (NSException *e){
        [ABuyly buylyException:e methodName:NSStringFromSelector(_cmd)];
    };
}

//获取活动列表(当前可认为只有豪车奖)
-(void)requestGetEventList{
    @try{
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"a"] = [TYLoginModel getSessionID];//回话session
        params[@"c"] = @(1);//分页index
        params[@"d"] = @(10);//分页size
        //暂为做分页，后期调整，因为此处接口有问题
        
        NSString *url = [NSString stringWithFormat:@"%@MAPI/MCus/GetEventList",APP_REQUEST_URL];
        [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
            
        } withSuccessBlock:^(id respondObject) {
            
            if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
                
                NSArray *arr = [TYEventModel mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"d"]];
                [self.threeArr addObjectsFromArray:arr];
                
            }else{
                [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
            }
            [self.myTableView reloadData];
            [LoadManager hiddenLoadView];
        } orFailBlock:^(id error) {
            [LoadManager hiddenLoadView];
        }];
    }@catch (NSException *e){
        [ABuyly buylyException:e methodName:NSStringFromSelector(_cmd)];
        [LoadManager hiddenLoadView];
    };
}


#pragma mark -- 懒加载
- (NSMutableArray *) oneArr
{
    if (!_oneArr) {
        _oneArr = [NSMutableArray array];
    }
    return _oneArr;
}

- (NSMutableArray *) twoArr
{
    if (!_twoArr) {
        _twoArr = [NSMutableArray array];
    }
    return _twoArr;
}

- (NSMutableArray *) threeArr
{
    if (!_threeArr) {
        _threeArr = [NSMutableArray array];
    }
    return _threeArr;
}

@end
