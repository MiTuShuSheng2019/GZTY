//
//  MyExperienceStoreVC.m
//  美界联盟
//
//  Created by LY on 2017/11/25.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "MyExperienceStoreVC.h"
#import "TYMyExperienceStoreCell.h"
#import "TYDetailsTwoCell.h"
#import "TYHasExperienceCell.h"
#import "TYCommentModel.h"

@interface MyExperienceStoreVC ()<UITableViewDelegate, UITableViewDataSource, TYMyExperienceStoreCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
/** 分页 */
@property (nonatomic, assign) NSInteger page;
/** 请求的条数 */
@property (nonatomic, assign) NSInteger limit;

@end

@implementation MyExperienceStoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.width = KScreenWidth;
    [self setUpTableView];
}

//初始化TableView
-(void)setUpTableView{
    self.limit = 10;
    __weak typeof(&*self)weakSelf = self;
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf.modelArray removeAllObjects];
        
        if (self.type == 0) {
            [weakSelf requestExpOrderList:1];
        }else if (self.type == 1){
            [weakSelf requestExpOrderList:3];
        }else{
            [weakSelf requestCommentList];
        }
    }];
    
    self.myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.type == 0) {
            [weakSelf requestExpOrderList:1];
        }else if (self.type == 1){
            [weakSelf requestExpOrderList:3];
        }else{
            [weakSelf requestCommentList];
        }
    }];
    
    self.myTableView.mj_footer.hidden = YES;
    [self.myTableView.mj_header beginRefreshing];
    self.myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.myTableView.tableFooterView = [UIView new];
    self.myTableView.showsVerticalScrollIndicator = NO;
}

#pragma mark <UITableViewDelegate, UITableViewDataSource>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == 0 || self.type == 1) {
        return 150;
    }else{
        TYCommentModel *model = self.modelArray[indexPath.row];
        return model.cellH;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.type == 0) {
        TYMyExperienceStoreCell *cell = [TYMyExperienceStoreCell CellTableView:self.myTableView];
        cell.model = self.modelArray[indexPath.row];
        cell.delegate = self;
        return cell;
    }else if (self.type == 1){
        TYHasExperienceCell *cell = [TYHasExperienceCell CellTableView:self.myTableView];
        cell.model = self.modelArray[indexPath.row];
        return cell;
    }else{
        TYDetailsTwoCell *cell = [TYDetailsTwoCell CellTableView:self.myTableView];
        cell.model = self.modelArray[indexPath.row];
        return cell;
    }
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

#pragma mark -- <TYMyExperienceStoreCellDelegate>
//预约
-(void)ClickReception:(UIButton *)btn{
    TYMyExperienceStoreCell *cell = (TYMyExperienceStoreCell *)[[btn superview] superview];
    NSIndexPath *path = [self.myTableView indexPathForCell:cell];
    TYExpOrderListModel *model = self.modelArray[path.row];
    [self requestSetExpOrderStatusID:model.ea andType:2 andPath:path];
}

//取消
-(void)ClickCancel:(UIButton *)btn{
    TYMyExperienceStoreCell *cell = (TYMyExperienceStoreCell *)[[btn superview] superview];
    NSIndexPath *path = [self.myTableView indexPathForCell:cell];
    TYExpOrderListModel *model = self.modelArray[path.row];
    [self requestSetExpOrderStatusID:model.ea andType:9 andPath:path];
}

#pragma mark -- 网路请求
//78 线下体验 获取预约单列表
- (void)requestExpOrderList:(NSInteger)type{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//会话session
    params[@"b"] = @(self.page);//分页页码
    params[@"c"] = @(self.limit);//分页数量
    params[@"d"] = @([TYLoginModel getExperienceId]);//体验店ID
    params[@"e"] = @"";//预约人手机号码 可不填
    params[@"f"] = @(type);//预约单状态 状态：1：待接受，2：已接受，3：已体验，9：已取消
    params[@"g"] = @"";//设备ID 可不填
    NSString *url = [NSString stringWithFormat:@"%@MAPI/Exp/ExpOrderList",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            
            NSArray *arr = [TYExpOrderListModel mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"e"]];
            [self.modelArray addObjectsFromArray:arr];
            self.page = self.page + 1;
            if (arr.count < self.limit) {
                self.myTableView.mj_footer.hidden = YES;
            }else{
                self.myTableView.mj_footer.hidden = NO;
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

- (void)requestSetExpOrderStatusID:(NSInteger)ID andType:(NSInteger)type andPath:(NSIndexPath *)path{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"b"] = @(ID);//预约单主键ID
    params[@"c"] = @(type);//状态：1：待接受，2：已接受，3：已体验，9：已取消
    
    NSString *url = [NSString stringWithFormat:@"%@MAPI/Exp/SetExpOrderStatus",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            [SVProgressHUD showSuccessWithStatus:@"处理成功"];
            [SVProgressHUD dismissWithDelay:0.5];
            [self.modelArray removeObjectAtIndex:path.row];
            
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
        [self.myTableView reloadData];
    } orFailBlock:^(id error) {
        
    }];
}

//87 线下体验 获取评论列表
- (void)requestCommentList{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"b"] = @(self.page);//分页页码
    params[@"c"] = @(self.limit);//分页数量
    params[@"d"] = @([TYLoginModel getExperienceId]);//体验店ID
    NSString *url = [NSString stringWithFormat:@"%@MAPI/Exp/CommentList",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            NSArray *arr = [TYCommentModel mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"e"]];
            [self.modelArray addObjectsFromArray:arr];
            
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
