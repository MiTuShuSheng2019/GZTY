//
//  TYConfirmOrderVC.m
//  美界联盟
//
//  Created by LY on 2017/11/28.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYConfirmOrderVC.h"
#import "TYAddressManagementMdoel.h"
#import "TYAddressManagementVC.h"
#import "TYOrderDetailsTableViewCell.h"
#import "TYMyOrderViewController.h"

@interface TYConfirmOrderVC ()

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
//收货姓名
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//收货电话
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
//收货地址
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
//头部视图的高
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewH;
//共计
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
/** TYAddressManagementMdoel */
@property (nonatomic, strong) TYAddressManagementMdoel *addModel;
/** 下单总数 */
@property (nonatomic, assign) NSInteger totalNumber;
/** 下单总价 */
@property (nonatomic, assign) double totalPrice;
/** 存储序列化id */
@property (nonatomic, strong) NSMutableArray *idArr;
/** 收货人 */
@property (nonatomic, strong) NSString *name;
/** 地址 */
@property (nonatomic, strong) NSString *address;
@end

@implementation TYConfirmOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    
    [self setNavigationBarTitle:@"确认下单" andTitleColor:[UIColor whiteColor] andImage:nil];
    self.myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.myTableView.tableFooterView = [UIView new];
    self.myTableView.showsVerticalScrollIndicator = NO;
    [self.myTableView reloadData];
    
    [self requestGetCusAddress];
    //总数
    self.totalNumber = 0;
    //总价
    self.totalPrice = 0.0;
    NSString *idStr;
    for (TYSelectProduct *model in self.modelArray) {
        self.totalNumber = self.totalNumber + model.countNumber;
        self.totalPrice = self.totalPrice + [model.ee doubleValue] * model.countNumber;
        idStr = [NSString stringWithFormat:@"%ld-%ld",model.ea, model.countNumber];
        [self.idArr addObject:idStr];
    }
    
    switch ([self.type integerValue]) {
        case 2:
            self.totalLabel.text = [NSString stringWithFormat:@"共%ld件商品  总计:%0.2lf金币",self.totalNumber, self.totalPrice];
            break;
        case 1:
            self.totalLabel.text = [NSString stringWithFormat:@"共%ld件商品  总计:%0.2lf银币",self.totalNumber, self.totalPrice];
            break;
            
        default:
            self.totalLabel.text = [NSString stringWithFormat:@"共%ld件商品  总计:￥%0.2lf",self.totalNumber, self.totalPrice];
            break;
    }
//    self.totalLabel.text = [NSString stringWithFormat:@"共%ld件商品  总计:￥%0.2lf",self.totalNumber, self.totalPrice];
    //接收通知传值
    NSNotificationCenter * center =[NSNotificationCenter defaultCenter];    [center addObserver:self selector:@selector(RefreshAddressData:) name:@"backTYShopCartViewController" object:nil];
}

-(void)RefreshAddressData:(NSNotification *)not{
    TYAddressManagementMdoel *model = [not.userInfo objectForKey:@"TYAddressManagementMdoel"];
    self.addModel = model;
    self.nameLabel.text = [NSString stringWithFormat:@"收货人:%@",[TYValidate IsNotNull:model.dc]];
    self.name = [NSString stringWithFormat:@"%@",[TYValidate IsNotNull:model.dc]];
    self.phoneLabel.text = [NSString stringWithFormat:@"%@",[TYValidate IsNotNull:model.dd]];
    self.addressLabel.text = [NSString stringWithFormat:@"地址:%@%@%@%@",[TYValidate IsNotNull:model.de],[TYValidate IsNotNull:model.df],[TYValidate IsNotNull:model.dl],[TYValidate IsNotNull:model.dg]];
    CGSize rec = [self.addressLabel.text boundingRectWithSize:CGSizeMake(KScreenWidth - 55, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:15]} context:nil].size;
    //10是间距 35是地址顶部的y值
    self.headViewH.constant = 35 + rec.height + 10;
    self.address = [NSString stringWithFormat:@"%@%@%@%@",[TYValidate IsNotNull:model.de],[TYValidate IsNotNull:model.df],[TYValidate IsNotNull:model.dl],[TYValidate IsNotNull:model.dg]];
}

#pragma mark -- 点击头部的View
- (IBAction)ClickHeadView {
    TYAddressManagementVC *addressVc = [[TYAddressManagementVC alloc] init];
    addressVc.isAddCar = YES;
    [self.navigationController pushViewController:addressVc animated:YES];
}

#pragma mark -- <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TYOrderDetailsTableViewCell *cell = [TYOrderDetailsTableViewCell CellTableView:self.myTableView];
    
    cell.productModel = self.modelArray[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

#pragma mark -- 点击提交订单
- (IBAction)ClickSubmitOrders {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您确认提交订单吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self requestOrderAdd];
    }];
    
    [alert addAction:action];
    [alert addAction:action1];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark --- 网络请求
//获取默认收获地址列表
-(void)requestGetCusAddress{
    
    [LoadManager showLoadingView:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = @(1);//分页页码
    params[@"c"] = @(1);//分页数量
    params[@"d"] = @(2);//传2获取默认地址
    NSString *url = [NSString stringWithFormat:@"%@mapi/mcus/GetCusAddress",APP_REQUEST_URL];
    
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
           
            NSArray *arr = [TYAddressManagementMdoel mj_objectArrayWithKeyValuesArray:[respondObject objectForKey:@"c"]];
            TYAddressManagementMdoel *model = [arr firstObject];
            self.addModel = model;
            self.nameLabel.text = [NSString stringWithFormat:@"收货人：%@",[TYValidate IsNotNull:model.dc]];
             self.phoneLabel.text = [NSString stringWithFormat:@"%@",[TYValidate IsNotNull:model.dd]];
            self.addressLabel.text = [NSString stringWithFormat:@"地址:%@%@%@%@",[TYValidate IsNotNull:model.de],[TYValidate IsNotNull:model.df],[TYValidate IsNotNull:model.dl],[TYValidate IsNotNull:model.dg]];
            self.address = [NSString stringWithFormat:@"%@%@%@%@",[TYValidate IsNotNull:model.de],[TYValidate IsNotNull:model.df],[TYValidate IsNotNull:model.dl],[TYValidate IsNotNull:model.dg]];
            self.name = [NSString stringWithFormat:@"%@",[TYValidate IsNotNull:model.dc]];
            CGSize rec = [self.addressLabel.text boundingRectWithSize:CGSizeMake(KScreenWidth - 55, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:15]} context:nil].size;
            //10是间距 35是地址顶部的y值
            self.headViewH.constant = 35 + rec.height + 10;
            
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
        [LoadManager hiddenLoadView];
    } orFailBlock:^(id error) {
        [LoadManager hiddenLoadView];
    }];
}

//确认下单 23 经销中心-订单管理-分销商下单
-(void)requestOrderAdd{
    [LoadManager showLoadingView:self.view];
    NSString *idStr = [self.idArr componentsJoinedByString:@","];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] =@([TYLoginModel getPrimaryId]);//分销商id
    params[@"c"] = idStr;//序列化的产品和数量信息
    params[@"d"] = @(self.totalNumber);//下单产品总数
    params[@"e"] = [NSString stringWithFormat:@"%0.2lf", self.totalPrice];//下单产品总价格
    params[@"f"] = self.name;//收货人
    params[@"g"] = self.phoneLabel.text;//收货人电话
    params[@"h"] = self.address;//收货人地址
    params[@"i"] = @(self.addModel.da);//收货地址主键id
    params[@"buyType"] = @(self.buyType);
    
    NSString* url;
    if (self.isIntergral) {
        url = [NSString stringWithFormat:@"%@mapi/Intergral/OrderIntergralAdd",APP_REQUEST_URL];
        
        params[@"mobile"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneTextFieldText"];
        switch ([self.type integerValue]) {
            case 2:
                params[@"intergral"] = [NSString stringWithFormat:@"%0.lf", self.totalPrice];
                params[@"type"] = @"2";
                params[@"e"] = @"0";
                break;
            case 1:
                params[@"intergral"] = [NSString stringWithFormat:@"%0.lf", self.totalPrice];
                params[@"type"] = @"1";
                params[@"e"] = @"0";
                break;
            default:
                break;
        }
    } else {
        url = [NSString stringWithFormat:@"%@mapi/order/orderAdd",APP_REQUEST_URL];
    }
    
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            //发送通知刷新数据
            [[NSNotificationCenter defaultCenter] postNotificationName:@"backMyOrderViewController" object:nil];
            //返回指定控制器
            NSArray *temArray = self.navigationController.viewControllers;
            for(UIViewController *temVC in temArray){
                if ([temVC isKindOfClass:[TYMyOrderViewController class]]){
                    TYMyOrderViewController *tempVc = [[TYMyOrderViewController alloc] init];
                    tempVc = (TYMyOrderViewController *)temVC;
                    [self.navigationController popToViewController:tempVc animated:YES];
                    break;
                }
            }
            
            if (self.type) {
                TYMyOrderViewController *tempVc = [[TYMyOrderViewController alloc] init];
                [self.navigationController pushViewController:tempVc animated:YES];
            }
            
//            [TYShowHud showHudSucceedWithStatus:[respondObject objectForKey:@"b"]];
        }else{
             [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
       [LoadManager hiddenLoadView];
    } orFailBlock:^(id error) {
        [LoadManager hiddenLoadView];
    }];
}

#pragma mark -- 懒加载
- (NSMutableArray *) idArr
{
    if (!_idArr) {
        _idArr = [NSMutableArray array];
    }
    return _idArr;
}

@end
