//
//  TYTeamPerformanceVC.m
//  美界联盟
//
//  Created by LY on 2018/11/11.
//  Copyright © 2018 刘燚. All rights reserved.
//

#import "TYTeamPerformanceVC.h"
#import "TYTeamOneCell.h"
#import "TYTeamTwoCell.h"
#import "SZCalendarPicker.h"
#import "TYRebateModel.h"
#import "TYResultDetailModel.h"

@interface TYTeamPerformanceVC ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tabView;
/** 时间 */
@property (nonatomic, strong) NSString *time;
/** TYRebateModel */
@property (nonatomic, strong) TYRebateModel *model;
/** 页码 */
@property (nonatomic, assign) NSInteger page;

@end

@implementation TYTeamPerformanceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"团队业绩" andTitleColor:[UIColor whiteColor] andImage:nil];
    [self setNavigationRightBtnImage:@"search"];
    
    self.tabView.tableFooterView = [UIView new];
    self.tabView.estimatedRowHeight = 10.f;
    self.tabView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.mj_footer.hidden = YES;
    //获取当前年月日
    self.time = [self YearMonthDay];
}

//搜索
- (void)navigationRightBtnClick:(UIButton *)btn{
    
    SZCalendarPicker *calendarPicker = [SZCalendarPicker showOnView:self.view];
    calendarPicker.today = [NSDate date];
    calendarPicker.date = calendarPicker.today;
    calendarPicker.frame = CGRectMake(0, 100, KScreenWidth, 352);
     __weak typeof(&*self)weakSelf = self;
    calendarPicker.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year) {
        weakSelf.time = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)year,(long)month,(long)day];
        weakSelf.page = 1;
        [weakSelf.tableView.mj_header beginRefreshing];
    };
}

-(void)loadMore:(BOOL)isMore{
    if (isMore) {
        self.page = self.page + 1;
    }else{
        self.page = 1;
    }
    [self requestRebateList];
}


#pragma mark -- <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.model) {
        return self.modelArray.count + 1;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        TYTeamOneCell *cell = [TYTeamOneCell CellTableView:self.tabView];
        cell.model = self.model;
        return cell;
    }else{
        
        TYTeamTwoCell *cell = [TYTeamTwoCell CellTableView:self.tabView];
        cell.model = self.modelArray[indexPath.row - 1];
        return cell;
    }
    
}

#pragma mark -- 网络请求
//团队业绩
-(void)requestTeamPerformance{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"CusID"] = @([TYLoginModel getPrimaryId]);
    params[@"Time"] = self.time;
    NSString *url = [NSString stringWithFormat:@"%@SAPI/User/RebateCount3List",APP_REQUEST_URL];
    __weak typeof(&*self)weakSelf = self;
    
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        if ([[respondObject objectForKey:@"Status"] boolValue] == true) {
            weakSelf.model = [TYRebateModel mj_objectWithKeyValues:[respondObject objectForKey:@"Data"]];
        }
        [weakSelf endHeaderFooterRefreshing];
       
    } orFailBlock:^(id error) {
        [TYShowHud showHudErrorWithStatus:@"接口请求失败"];
    }];
}

//业绩明细
-(void)requestRebateList{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"CusID"] = @([TYLoginModel getPrimaryId]);
    params[@"Index"] = @(self.page);
     params[@"Size"] = @(10);
    NSString *url = [NSString stringWithFormat:@"%@SAPI/User/Rebate3List",APP_REQUEST_URL];
    __weak typeof(&*self)weakSelf = self;
    
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        if ([[respondObject objectForKey:@"Status"] boolValue] == true) {
            
            if (weakSelf.page == 1) {
                [weakSelf.modelArray removeAllObjects];
                [weakSelf requestTeamPerformance];
            }
            NSArray *arr = [TYResultDetailModel mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"Data"] objectForKey:@"list"]];
            [weakSelf.modelArray addObjectsFromArray:arr];
            
            if (arr.count < 10) {
                weakSelf.tableView.mj_footer.hidden = YES;
            }else{
                weakSelf.tableView.mj_footer.hidden = NO;
            }
            
            if (weakSelf.page != 1) {
                [weakSelf endHeaderFooterRefreshing];
            }
        }
        
    } orFailBlock:^(id error) {
        [weakSelf endHeaderFooterRefreshing];
        [TYShowHud showHudErrorWithStatus:@"接口请求失败"];
    }];
}


@end
