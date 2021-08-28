//
//  TYCarPerformanceVC.m
//  美界联盟
//
//  Created by LY on 2018/11/11.
//  Copyright © 2018 刘燚. All rights reserved.
//

#import "TYCarPerformanceVC.h"
#import "TYCarOneCell.h"
#import "TYCarTwoCell.h"
#import "SZCalendarPicker.h"
#import "TYRebateModel.h"
#import "TYCarResultModel.h"

@interface TYCarPerformanceVC ()<UITableViewDelegate, UITableViewDataSource>
/** TYRebateModel */
@property (nonatomic, strong) TYRebateModel *model;
/** 时间 */
@property (nonatomic, strong) NSString *time;
/** 页码 */
@property (nonatomic, assign) NSInteger page;

@end

@implementation TYCarPerformanceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"车奖业绩" andTitleColor:[UIColor whiteColor] andImage:nil];
    [self setNavigationRightBtnImage:@"search"];
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 10.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
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
    [self requestGetEventList];
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
        TYCarOneCell *cell = [TYCarOneCell CellTableView:self.tableView];
        cell.model = self.model;
        return cell;
    }else{
        TYCarTwoCell *cell = [TYCarTwoCell CellTableView:self.tableView];
        cell.model = self.modelArray[indexPath.row - 1];
        return cell;
    }
}


#pragma mark -- 网络请求
//车奖业绩
-(void)requestCarPerformance{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"CusID"] = @([TYLoginModel getPrimaryId]);
    params[@"Time"] = self.time;
    NSString *url = [NSString stringWithFormat:@"%@SAPI/User/RebateCount7List",APP_REQUEST_URL];
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

//车将业绩-豪车奖励列表
-(void)requestGetEventList{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = @(self.page);
    params[@"c"] = @(10);
    NSString *url = [NSString stringWithFormat:@"%@mapi/MCus/GetEventList",APP_REQUEST_URL];
    __weak typeof(&*self)weakSelf = self;
    
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        if ([[respondObject objectForKey:@"a"] boolValue] == TYRequestSuccessful) {
            
            if (weakSelf.page == 1) {
                [weakSelf.modelArray removeAllObjects];
                [weakSelf requestCarPerformance];
            }
            NSArray *arr = [TYCarResultModel mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"d"]];
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
