//
//  TYShareBonusViewController.m
//  美界联盟
//
//  Created by LY on 2017/11/1.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYShareBonusViewController.h"
#import "TYShareBonusCell.h"
#import "TYShareBonusFoorView.h"
#import "TYHistoryShareBonusViewController.h"

@interface TYShareBonusViewController ()<UITableViewDelegate, UITableViewDataSource, TYShareBonusFoorViewDelegate>
//时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//金额
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
//我的首充金额
@property (weak, nonatomic) IBOutlet UILabel *firstAmountLabel;
//我的首充分红
@property (weak, nonatomic) IBOutlet UILabel *firstFullRedLabel;
//年
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
//中间需要影藏的View
@property (weak, nonatomic) IBOutlet UIView *middleView;
//中间需要影藏的View的高
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleViewH;
//需要影藏的分割线
@property (weak, nonatomic) IBOutlet UIView *lineView;
//需要影藏的分割线的高
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewH;


@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation TYShareBonusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    if (self.type == 1) {
        [self setNavigationBarTitle:@"我的分红" andTitleColor:[UIColor whiteColor] andImage:nil];
    }else{
        [self setNavigationBarTitle:@"团队分红" andTitleColor:[UIColor whiteColor] andImage:nil];
        self.middleView.hidden = YES;
        self.middleViewH.constant = 0;
        self.lineView.hidden = YES;
        self.lineViewH.constant = 0;
    }
    
    //给头部控件赋值
    self.timeLabel.text = [NSString stringWithFormat:@"%@-%@",self.amountModle.h,self.amountModle.i];
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%0.2lf",self.amountModle.j];
    self.firstAmountLabel.text = [NSString stringWithFormat:@"￥%0.2lf",self.amountModle.n];
    self.firstFullRedLabel.text = [NSString stringWithFormat:@"￥%0.2lf",self.amountModle.m];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    static NSString *identifyHead = @"TYShareBonusFoorView";
    TYShareBonusFoorView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifyHead];
    if (!headerView) {
        headerView = [[TYShareBonusFoorView CreatTYShareBonusFoorView] initWithReuseIdentifier:identifyHead];
        [headerView setFrame:CGRectMake(0, 0, KScreenWidth, 50)];
    }
    headerView.delegate = self;
    headerView.contentView.backgroundColor = [UIColor whiteColor];
    return headerView;
}

#pragma mark -- <TYShareBonusFoorViewDelegate>--查看历史
-(void)ClickSeeProductionHistory{
    TYHistoryShareBonusViewController *historyVc = [[TYHistoryShareBonusViewController alloc] init];
    historyVc.type = self.type;
    [self.navigationController pushViewController:historyVc animated:YES];
}

#pragma mark --- 返回当前年份
-(NSString *) getDateYearNow{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy"];
    //用[NSDate date]可以获取系统当前时间年份
    return [dateFormatter stringFromDate:[NSDate date]];
}

#pragma mark --- 网络请求
//经销中心 个人分红金额明细
-(void)requestGetSelfDetailList{
   
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = @([TYLoginModel getPrimaryId]);//分销商ID
    params[@"c"] = [self getDateYearNow];//默认当前年
    
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
            
            self.yearLabel.text = [NSString stringWithFormat:@"%@",[[respondObject objectForKey:@"c"] objectForKey:@"da"]];
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
