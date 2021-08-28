//
//  TYMessageViewController.m
//  美界联盟
//
//  Created by LY on 2017/10/26.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYMessageViewController.h"
#import "TYMessageCell.h"
#import "TYManageModel.h"

@interface TYMessageViewController ()<UITableViewDelegate, UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *MessageTableView;
/** 分页 */
@property (nonatomic, assign) NSInteger page;
/** 请求的条数 */
@property (nonatomic, assign) NSInteger limit;

@end

@implementation TYMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"消息" andTitleColor:[UIColor whiteColor] andImage:nil];
    
    [self setUpTableView];
}

//初始化TableView
-(void)setUpTableView{
    self.limit = 11;
    __weak typeof(&*self)weakSelf = self;
    self.MessageTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf.modelArray removeAllObjects];
        [weakSelf requestPushManageList];
    }];
    
    self.MessageTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestPushManageList];
    }];
    
    self.MessageTableView.mj_footer.hidden = YES;
    [self.MessageTableView.mj_header beginRefreshing];
    self.MessageTableView.tableFooterView = [UIView new];
    self.MessageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.MessageTableView.showsVerticalScrollIndicator = NO;
}


#pragma mark -- <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TYMessageCell *cell = [TYMessageCell CellTableView:self.MessageTableView];
    cell.model = self.modelArray[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TYManageModel *model = self.modelArray[indexPath.row];
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:model.ec preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self requestUpPushManage:model andPath:indexPath];
    }];
    
    [alertVc addAction:action1];
    [self presentViewController:alertVc animated:YES completion:nil];
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
//61 经销中心 系统消息（信鸽）列表
-(void)requestPushManageList{

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = @(self.page);//页码
    params[@"c"] = @(self.limit);//页大小
    
    NSString *url = [NSString stringWithFormat:@"%@MAPI/MSys/PushManageList",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {

            NSArray *arr = [TYManageModel mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"e"]];
            [self.modelArray addObjectsFromArray:arr];
            
            self.page = self.page + 1;
            
            if (arr.count == self.limit) {
                self.MessageTableView.mj_footer.hidden = NO;
            }else{
                self.MessageTableView.mj_footer.hidden = YES;
            }
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
        [self.MessageTableView.mj_header endRefreshing];
        [self.MessageTableView.mj_footer endRefreshing];
        [self.MessageTableView reloadData];
        
    } orFailBlock:^(id error) {
        [self.MessageTableView.mj_header endRefreshing];
        [self.MessageTableView.mj_footer endRefreshing];
    }];
}

//62 经销中心 更新系统消息（信鸽）已读状态
-(void)requestUpPushManage:(TYManageModel *)model andPath:(NSIndexPath *)path{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = @(model.ea);//消息ID
    
    NSString *url = [NSString stringWithFormat:@"%@MAPI/MSys/UpPushManage",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            model.ee = 3;
            //刷新当前的cell
            [self.MessageTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:path,nil] withRowAnimation:UITableViewRowAnimationNone];
            
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
        
    } orFailBlock:^(id error) {
    }];
}
@end
