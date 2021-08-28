//
//  TYForRecordViewController.m
//  美界联盟
//
//  Created by LY on 2017/11/6.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYForRecordViewController.h"
#import "TYForRecordCell.h"

@interface TYForRecordViewController ()

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
/** 分页 */
@property (nonatomic, assign) NSInteger page;
/** 请求的条数 */
@property (nonatomic, assign) NSInteger limit;

@end

@implementation TYForRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"兑换记录" andTitleColor:[UIColor whiteColor] andImage:nil];
    
    [self setUpTableView];
}

//初始化TableView
-(void)setUpTableView{
    
    self.myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.myTableView.tableFooterView = [UIView new];
    self.myTableView.showsVerticalScrollIndicator = NO;
    self.limit = 10;
    
    __weak typeof(&*self)weakSelf = self;
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf.modelArray removeAllObjects];
        //网络请求
        [weakSelf requestGetDisEventList];
    }];
    
    self.myTableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [weakSelf requestGetDisEventList];
    }];
    
    self.myTableView.mj_footer.hidden = YES;
    [self.myTableView.mj_header beginRefreshing];
    
}

#pragma mark --  <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TYForRecordCell *cell = [TYForRecordCell CellTableView:self.myTableView];
    cell.model = self.modelArray[indexPath.row];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70 + (KScreenWidth * 9 /25);
    //图片比例25：9  后期可根据需求调整
    
}

#pragma mark --- 网络请求
//69 经销中心 获取分销商参与的活动
-(void)requestGetDisEventList{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = @([TYLoginModel getPrimaryId]);//分销商ID
    params[@"c"] = @(self.page);//分页index
    params[@"d"] = @(self.limit);//分页size
    
    NSString *url = [NSString stringWithFormat:@"%@MAPI/MCus/GetDisEventList",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            NSArray *arr = [TYForRecord mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"d"]];
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
