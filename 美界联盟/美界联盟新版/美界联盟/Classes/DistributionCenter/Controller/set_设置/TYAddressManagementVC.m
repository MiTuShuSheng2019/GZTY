//
//  TYAddressManagementVC.m
//  美界联盟
//
//  Created by LY on 2017/11/9.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYAddressManagementVC.h"
#import "TYNewShippingAddressVC.h"
#import "TYAddressManagementCell.h"

@interface TYAddressManagementVC ()<UITableViewDelegate, UITableViewDataSource, TYAddressManagementCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
/** 分页 */
@property (nonatomic, assign) NSInteger page;
/** 请求的条数 */
@property (nonatomic, assign) NSInteger limit;

/** 记录点击的是哪一行的模型 */
@property (nonatomic, strong) TYAddressManagementMdoel *model;

@end

@implementation TYAddressManagementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"管理收货地址" andTitleColor:[UIColor whiteColor] andImage:nil];
    
    [self setUpTableView];
    //接收到通知 刷新数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"BackTYAddressManagementVC" object:nil];
    
}

-(void)refreshData{
    [self.myTableView.mj_header beginRefreshing];
}

#pragma mark -- 新增收货地址
- (IBAction)ClickNewShippingAddress {
    TYNewShippingAddressVC *newVc = [[TYNewShippingAddressVC alloc] init];
    newVc.type = 2;
    [self.navigationController pushViewController:newVc animated:YES];
}

//初始化TableView
-(void)setUpTableView{
    self.limit = 100;
    __weak typeof(&*self)weakSelf = self;
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf.modelArray removeAllObjects];
        [weakSelf requestGetCusAddress];
    }];
    
    self.myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestGetCusAddress];
    }];
    
    self.myTableView.mj_footer.hidden = YES;
    [self.myTableView.mj_header beginRefreshing];
    self.myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.myTableView.tableFooterView = [UIView new];
    self.myTableView.showsVerticalScrollIndicator = NO;
}

#pragma mark -- <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TYAddressManagementCell *cell = [TYAddressManagementCell CellTableView:self.myTableView];
    cell.model = self.modelArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TYAddressManagementMdoel *model = self.modelArray[indexPath.row];
    return model.cellH;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isAddCar == YES) {
        
        TYAddressManagementMdoel *model = self.modelArray[indexPath.row];
        //通知传值
        NSNotification *not = [[NSNotification alloc] initWithName:@"backTYShopCartViewController" object:nil userInfo:@{@"TYAddressManagementMdoel":model}];
        [[NSNotificationCenter defaultCenter] postNotification:not];
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        
    }
    //    TYDealerDetailsViewController *detailsVc = [[TYDealerDetailsViewController alloc] init];
    //    detailsVc.model = self.modelArray[indexPath.row];
    //    [self.navigationController pushViewController:detailsVc animated:YES];
}

#pragma mark -- <TYAddressManagementCellDelegate>
#pragma mark -- 设为默认
- (void)ClickSetDefault:(UIButton *)btn{
    TYAddressManagementCell *cell = (TYAddressManagementCell *)[[[btn superview] superview] superview];
    NSIndexPath *path = [self.myTableView indexPathForCell:cell];
    self.model = self.modelArray[path.row];
    [self requestEditCusAddress];
}

#pragma mark -- 删除
- (void)ClickDeleteAddress:(UIButton *)btn{
    TYAddressManagementCell *cell = (TYAddressManagementCell *)[[[btn superview] superview] superview];
    NSIndexPath *path = [self.myTableView indexPathForCell:cell];
    self.model = self.modelArray[path.row];
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您确认删除地址吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self requestDelCusAddress:path];
    }];
    
    [alertVc addAction:action1];
    [alertVc addAction:action2];
    [self presentViewController:alertVc animated:YES completion:nil];
}

#pragma mark -- 编辑
- (void)ClickEditAddress:(UIButton *)btn{
    
    TYAddressManagementCell *cell = (TYAddressManagementCell *)[[[btn superview] superview] superview];
    NSIndexPath *path = [self.myTableView indexPathForCell:cell];
    TYNewShippingAddressVC *newVc = [[TYNewShippingAddressVC alloc] init];
    newVc.type = 1;
    newVc.model = self.modelArray[path.row];
    [self.navigationController pushViewController:newVc animated:YES];
}

#pragma mark --- 网络请求
//获取收获地址列表
-(void)requestGetCusAddress{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *url;
    if ([TYSingleton shareSingleton].consumer == 1) {
        params[@"a"] = [TYConsumerLoginModel getSessionID];//回话session
        params[@"b"] = [TYConsumerLoginModel getPrimaryId];//分销商id
        params[@"c"] = @(self.page);//分页页码
        params[@"d"] = @(self.limit);//分页数量
        url = [NSString stringWithFormat:@"%@MAPI/SM/GetSMAddressList",APP_REQUEST_URL];
        
    }else{
        params[@"a"] = [TYLoginModel getSessionID];//回话session
        params[@"b"] = @(self.page);//分页页码
        params[@"c"] = @(self.limit);//分页数量
        url = [NSString stringWithFormat:@"%@mapi/mcus/GetCusAddress",APP_REQUEST_URL];
    }
    
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            
            self.page = self.page + 1;
            NSArray *arr;
            if ([TYSingleton shareSingleton].consumer == 1) {
                 arr = [TYAddressManagementMdoel mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"d"]];
            }else{
                 arr = [TYAddressManagementMdoel mj_objectArrayWithKeyValuesArray:[respondObject objectForKey:@"c"]];
            }
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
//54 经销中心 收货地址编辑 请求设为默认地址
-(void)requestEditCusAddress{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *url;
    if ([TYSingleton shareSingleton].consumer == 1) {
        
        params[@"a"] = [TYConsumerLoginModel getSessionID];//回话session
        params[@"b"] = @(self.model.da);//地址PKID
        params[@"c"] = self.model.dc;//收货联系人
        params[@"d"] = self.model.dd;//电话
        params[@"e"] = self.model.de;//省份
        params[@"f"] = self.model.df;//城市
        params[@"g"] = self.model.dl;//区域
        params[@"h"] = self.model.dg;//详细地址
        params[@"i"] = self.model.dk;//邮政编码
        params[@"j"] = @(2);//是否默认地址
        
        url = [NSString stringWithFormat:@"%@MAPI/SM/EditSMAddress",APP_REQUEST_URL];
        
    }else{
        params[@"a"] = [TYLoginModel getSessionID];//回话session
        params[@"b"] = self.model.dc;//收货联系人
        params[@"c"] = self.model.dd;//收货电话
        params[@"d"] = self.model.de;//省份
        params[@"e"] = self.model.df;//城市
        params[@"f"] = self.model.dg;//区域
        params[@"i"] = @(2);//是否默认地址址1否，2是
        params[@"j"] = @(self.model.da);//PKID
        
        url = [NSString stringWithFormat:@"%@mapi/mcus/EditCusAddress",APP_REQUEST_URL];
    }
    
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            [self.myTableView.mj_header beginRefreshing];
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
        
    } orFailBlock:^(id error) {
        
    }];
}

//56 经销中心 删除收货地址
-(void)requestDelCusAddress:(NSIndexPath *)path{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *url;
    if ([TYSingleton shareSingleton].consumer == 1) {
        params[@"a"] = [TYConsumerLoginModel getSessionID];//回话session
        params[@"b"] = @(self.model.da);//PKID
        
        url = [NSString stringWithFormat:@"%@MAPI/SM/DelSMAddress",APP_REQUEST_URL];
        
    }else{
        params[@"a"] = [TYLoginModel getSessionID];//回话session
        params[@"b"] = @(self.model.da);//PKID
        
        url = [NSString stringWithFormat:@"%@mapi/mcus/DelCusAddress",APP_REQUEST_URL];
    }
    
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            [self.modelArray removeObjectAtIndex:path.row];
        }else{
             [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
        [self.myTableView reloadData];
    } orFailBlock:^(id error) {
        
    }];
}

@end
