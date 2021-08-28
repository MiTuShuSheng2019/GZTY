//
//  TYOutboundGoodsViewController.m
//  美界联盟
//
//  Created by LY on 2017/11/10.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYOutboundGoodsViewController.h"
#import "TYOutboundGoodsModel.h"
#import "TYQRCodeViewController.h"
#import "TYOutboundGoodsCell.h"
#import "TYOutboundGoodsView.h"

@interface TYOutboundGoodsViewController ()<UITableViewDelegate, UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

/** 分页 */
@property (nonatomic, assign) NSInteger page;
/** 请求的条数 */
@property (nonatomic, assign) NSInteger limit;
/** 出库流水号 */
@property (nonatomic, strong) NSString *OutletNumber;
/** 出库id */
@property (nonatomic, strong) NSString *OutboundID;


@end

@implementation TYOutboundGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"商品出库" andTitleColor:[UIColor whiteColor] andImage:nil];
    
    [self setUpTableView];
    
    //接收通知传值
    NSNotificationCenter * center =[NSNotificationCenter defaultCenter];    [center addObserver:self selector:@selector(RefreshCodeTextFieldData:) name:@"backTYAuthorizationQueryViewController" object:nil];
    
}
//初始化TableView
-(void)setUpTableView{
    [self requestOutStorageInfoAdd];
    
    __weak typeof(&*self)weakSelf = self;
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf.modelArray removeAllObjects];
        
        [weakSelf requestGetOutStorageDetailList];
    }];
    
    self.myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestGetOutStorageDetailList];
    }];
    self.myTableView.mj_footer.hidden = YES;
    
    self.myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.myTableView.tableFooterView = [UIView new];
    self.myTableView.showsVerticalScrollIndicator = NO;
}

-(void)RefreshCodeTextFieldData:(NSNotification *)not{
    self.codeTextField.text = [not.userInfo objectForKey:@"metadataObject"];
     [self requestAddOutStorageDetail:1];
}

#pragma mark -- 点击扫描
- (IBAction)ClickScan {
    [self.view endEditing:YES];
    TYQRCodeViewController *qrVc = [[TYQRCodeViewController alloc] init];
    [self.navigationController pushViewController:qrVc animated:YES];
}

#pragma mark -- 点击查询
- (IBAction)ClickEnquiries {
    if (self.codeTextField.text.length == 0) {
        [TYShowHud showHudErrorWithStatus:@"条码不能为空"];
        return;
    }
    
    [self requestAddOutStorageDetail:1];
    
}

#pragma mark -- 点击出库信息
- (IBAction)ClickDeliveryInformation {
    TYOutboundGoodsView *outView = [TYOutboundGoodsView CreatTYOutboundGoodsView];
    outView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    outView.OutletNumber = self.OutletNumber;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:outView];
}

#pragma mark -- 确定出库
- (IBAction)ClickDetermineOutbound {
    [TYAlertAction showTYAlertActionTitle:@"温馨提示" andMessage:@"您确认出库吗？" andVc:nil andClick:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [self requestAddOutStorageDetail:2];
        }
    }];
}

#pragma mark -- <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TYOutboundGoodsCell *cell = [TYOutboundGoodsCell CellTableView:self.myTableView];
    cell.model = self.modelArray[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

//单元格返回的编辑风格，包括删除 添加 和 默认  和不可编辑三种风格
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
//修改左滑的按钮的字
-(NSString*)tableView:(UITableView*)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath*)indexpath {
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        TYOutboundGoodsModel  *model = self.modelArray[indexPath.row];
        // 获取选中删除行索引值
        NSInteger row = [indexPath row];
        // 通过获取的索引值删除数组中的值
        [self.modelArray removeObjectAtIndex:row];
        // 删除单元格的某一行时，在用动画效果实现删除过程
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self requestOutStorageDetailDeleted:model.eb];
    }
}

#pragma mark --- 网络请求
//根据订单id请求出库流水号id
-(void)requestOutStorageInfoAdd{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = self.orderID;//订单id
    params[@"c"] = @([TYLoginModel getPrimaryId]); //分销商ID
    
    NSString *url = [NSString stringWithFormat:@"%@mapi/mpsi/OutStorageInfoAdd",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            
            self.OutboundID = [[respondObject objectForKey:@"c"] objectForKey:@"d"];
            self.OutletNumber = [[respondObject objectForKey:@"c"] objectForKey:@"e"];
            
             [self.myTableView.mj_header beginRefreshing];
            
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
    } orFailBlock:^(id error) {
        
    }];
}

//26 经销中心-发货管理-发货明细记录
-(void)requestGetOutStorageDetailList{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = @(1);//页码
    params[@"c"] = @(100);//页大小
    params[@"d"] = self.OutletNumber;//出库流水号
    
    NSString *url = [NSString stringWithFormat:@"%@mapi/mpsi/GetOutStorageDetailList",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            
            NSArray *arr = [TYOutboundGoodsModel mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"e"]];
            [self.modelArray addObjectsFromArray:arr];
            
            if (arr.count == 100) {
                self.myTableView.mj_footer.hidden = NO;
            }else{
                self.myTableView.mj_footer.hidden = YES;
            }
            self.totalLabel.text = [NSString stringWithFormat:@"已扫描%@件",[[respondObject objectForKey:@"c"] objectForKey:@"d"]];
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

//请求查询条码 type = 1 表示查询 type = 2表示出库  主要用于移动端处理操作
-(void)requestAddOutStorageDetail:(NSInteger )type{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = self.OutboundID;//出库ID
    params[@"c"] = self.OutletNumber;//出库流水号
    params[@"d"] = self.codeTextField.text;//条码
    
    NSString *url = [NSString stringWithFormat:@"%@mapi/mpsi/AddOutStorageDetail",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            if (type == 1) {
                 [self.myTableView.mj_header beginRefreshing];
            }else{
                //发送通知给订单发货界面刷新数据
                [[NSNotificationCenter defaultCenter] postNotificationName:@"backShippingViewController" object:nil];
            }
            
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
    } orFailBlock:^(id error) {
        
    }];
}
//【30 经销中心-发货管理-发货-预出库删除】
-(void)requestOutStorageDetailDeleted:(NSString *)code{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = code;//条码
   
    NSString *url = [NSString stringWithFormat:@"%@mapi/mpsi/OutStorageDetailDeleted",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            [TYShowHud showHudSucceedWithStatus:@"删除成功"];
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
    } orFailBlock:^(id error) {
        
    }];
}


@end
