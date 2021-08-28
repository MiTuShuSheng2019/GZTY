//
//  TYShopCartViewController.m
//  美界联盟
//
//  Created by LY on 2017/11/27.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYShopCartViewController.h"
#import "TYShopCartCell.h"
#import "TYHotProductModel.h"
#import "TYAddressManagementMdoel.h"
#import "TYWeChatPayment.h"
#import "TYAddressManagementVC.h"

@interface TYShopCartViewController ()<UITableViewDelegate,UITableViewDataSource,TYShopCartCellDelegate, TYWeChatPaymentDelegate>
//收货人
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//地址
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
//电话
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
//合计金额
@property (weak, nonatomic) IBOutlet UILabel *totleLabel;
//全选按钮
@property (weak, nonatomic) IBOutlet UIButton *allChooseBtn;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
/** 总价 */
@property (nonatomic, strong) NSString *totalPrices;
/** 是否全选数组 */
@property (nonatomic, strong) NSMutableArray *isAllSelectedArr;
/** 选择产品的产品id_数量_价格数组 */
@property (nonatomic, strong) NSMutableArray *idArr;
/** 收货信息模型 */
@property (nonatomic, strong) TYAddressManagementMdoel *model;

/** 订单号 */
@property (nonatomic, strong) NSString *orderNo;

//结算按钮
@property (weak, nonatomic) IBOutlet UIButton *settlementBtn;

/** 数据数组 */
@property (nonatomic, strong) NSMutableArray *dataArr;
//顶部视图的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewH;
@end

@implementation TYShopCartViewController

- (NSMutableArray *) dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"购物车" andTitleColor:[UIColor whiteColor] andImage:nil];
    self.myTableView.tableFooterView = [UIView new];
    [self requestAddress];
    
    self.settlementBtn.backgroundColor = RGB(238, 238, 238);
    self.settlementBtn.enabled = NO;
    
    //获取支付代理
    [TYWeChatPayment sharedManager].delegate = self;
    
//
//    for (NSInteger i = 0; i < [TYSingleton shareSingleton].shopArr.count; i++) {
//
//        for (NSInteger j = i + 1;j < [TYSingleton shareSingleton].shopArr.count; j++) {
//            TYHotProductModel *tempModel = [TYSingleton shareSingleton].shopArr[i];
//
//            TYHotProductModel *model = [TYSingleton shareSingleton].shopArr[j];
//
//            if (tempModel.ea == model.ea) {
//                tempModel.shopNumber = tempModel.shopNumber + model.shopNumber;
//                model.shopNumber = tempModel.shopNumber;
////                [[TYSingleton shareSingleton].shopArr removeObjectAtIndex:j];
//            }else{
//
//            }
//        }
//    }
    
//    //去重数组中的模型
//    NSMutableArray *listAry = [[NSMutableArray alloc] init];
//    for (NSString *str in [TYSingleton shareSingleton].shopArr) {
//        if (![listAry containsObject:str]) {
//            [listAry addObject:str];
//        }
//    }
//    
//    [TYSingleton shareSingleton].shopArr = listAry;
    
    //接收通知传值
    NSNotificationCenter * center =[NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(RefreshAddressData:) name:@"backTYShopCartViewController" object:nil];
}

-(void)RefreshAddressData:(NSNotification *)not{
    TYAddressManagementMdoel *model = [not.userInfo objectForKey:@"TYAddressManagementMdoel"];
    self.nameLabel.text = [NSString stringWithFormat:@"收货人:%@",[TYValidate IsNotNull:model.dc]];
    self.telLabel.text = model.dd;
    
    NSString *address = [NSString stringWithFormat:@"地址:%@%@%@%@",[TYValidate IsNotNull:model.de],[TYValidate IsNotNull:model.df],[TYValidate IsNotNull:model.dl],[TYValidate IsNotNull:model.dg]];
    // 计算文字的高度
    CGSize rec = [address boundingRectWithSize:CGSizeMake(KScreenWidth - 90, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:15]} context:nil].size;
    self.topViewH.constant = 45 + rec.height;
    self.addressLabel.text = address;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [TYSingleton shareSingleton].shopArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"dataArr"];
    if ([TYSingleton shareSingleton].shopArr.count == 0) {
        self.settlementBtn.backgroundColor = RGB(238, 238, 238);
        self.settlementBtn.enabled = NO;
        self.allChooseBtn.selected = NO;
    }
}

#pragma mark -- <TYWeChatPaymentDelegate>
//成功
-(void)paySucceed:(NSInteger)type{
    
    [self requestUnifiedOrderType:type];
}

//失败
-(void)PayFailure:(NSInteger)type{
    //    type = 1;普通失败 type =2;点击取消
    [self requestUnifiedOrderType:type];
}


-(void) leftNavigationButtonAction{
    for (TYHotProductModel *model in[TYSingleton shareSingleton].shopArr ) {
        model.isSelected = NO;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 点击顶部的收获地址
- (IBAction)ClickTopView {
    TYAddressManagementVC *vc = [[TYAddressManagementVC alloc] init];
    vc.isAddCar = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark -- <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [TYSingleton shareSingleton].shopArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TYShopCartCell *cell = [TYShopCartCell CellTableView:self.myTableView];
    if ([TYSingleton shareSingleton].shopArr.count == 0) {
        return cell;
    }
    cell.model = [TYSingleton shareSingleton].shopArr[indexPath.row];
    cell.delegate = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
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
        // 获取选中删除行索引值
        NSInteger row = [indexPath row];
        // 通过获取的索引值删除数组中的值
        [[TYSingleton shareSingleton].shopArr removeObjectAtIndex:row];
        // 删除单元格的某一行时，在用动画效果实现删除过程
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark -- <TYShopCartCellDelegate>
-(void)ClickChoose:(UIButton *)chooseBtn{
    chooseBtn.selected = !chooseBtn.selected;
    TYShopCartCell *cell = (TYShopCartCell *)[[chooseBtn superview] superview];
    NSIndexPath *path = [self.myTableView indexPathForCell:cell];
    TYHotProductModel *model = [TYSingleton shareSingleton].shopArr[path.row];
    //商品id
    NSInteger shopId = model.ea;
    //商品数量
    NSInteger shopNumber = model.shopNumber;
    //商品售价
    double shopPrice = [model.ec doubleValue] * 100;
    
    NSString *idStr = [NSString stringWithFormat:@"%ld_%ld_%0.0lf",(long)shopId,(long)shopNumber,shopPrice];
    
    NSString *totleP = [NSString stringWithFormat:@"%0.0lf",[model.ec doubleValue] * 100 * model.shopNumber];
    
    if (cell.chooseBtn.selected) {
        model.isSelected = YES;
        self.totalPrices = [NSString stringWithFormat:@"%0.0lf",[self.totalPrices doubleValue] + [totleP doubleValue]];
        [self.isAllSelectedArr addObject:[NSString stringWithFormat:@"%ld", (long)path.row]];
        [self.idArr addObject:idStr];
        
    }else{
        model.isSelected = NO;
        self.totalPrices = [NSString stringWithFormat:@"%0.0lf", [self.totalPrices doubleValue] - [totleP doubleValue]];
        [self.isAllSelectedArr removeObject:[NSString stringWithFormat:@"%ld", (long)path.row]];
        [self.idArr removeObject:idStr];
    }
    self.totleLabel.text = [NSString stringWithFormat:@"￥%0.2lf",[self.totalPrices doubleValue] / 100];
    
    if ([self.totalPrices intValue] > 0) {
        self.settlementBtn.backgroundColor =  RGB(32, 135, 238);
        self.settlementBtn.enabled = YES;
    }else{
        self.settlementBtn.backgroundColor = RGB(238, 238, 238);
        self.settlementBtn.enabled = NO;
    }
    
    if (self.isAllSelectedArr.count == [TYSingleton shareSingleton].shopArr.count) {
        self.allChooseBtn.selected = YES;
    }else{
        self.allChooseBtn.selected = NO;
    }
}


#pragma mark -- 全选
- (IBAction)ClickCheckAll:(UIButton *)sender {
    if ([TYSingleton shareSingleton].shopArr.count == 0) {
        return;
    }
    sender.selected = !sender.selected;
    if (sender.selected) {
        
        for (TYHotProductModel *model in [TYSingleton shareSingleton].shopArr) {
            //此处的判断是为了防止重复计算总金额
            if (self.idArr.count != 0 && model.isSelected) {
                
            }else{
                model.isSelected = YES;
                NSString *totleP = [NSString stringWithFormat:@"%0.0lf",[model.ec doubleValue] * 100 * model.shopNumber];
                self.totalPrices = [NSString stringWithFormat:@"%0.0lf",[self.totalPrices doubleValue] + [totleP doubleValue]];
            }
            
            //商品id
            NSInteger shopId = model.ea;
            //商品数量
            NSInteger shopNumber = model.shopNumber;
            //商品售价
            double shopPrice = [model.ec doubleValue] * 100;
            NSString *idStr = [NSString stringWithFormat:@"%ld_%ld_%0.0lf",(long)shopId,(long)shopNumber,shopPrice];
            
            [self.idArr addObject:idStr];
            
            //此循环是去掉数组中的重复元素
            NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:self.idArr.count];
            // 外层一个循环
            for (NSString *item in self.idArr) {
                // 调用-containsObject:本质也是要循环去判断，因此本质上是双层遍历
                if (![resultArray containsObject:item]) {
                    [resultArray addObject:item];
                }
            }
            self.idArr = resultArray;
            
        }
    }else{
        
        for (TYHotProductModel *model in [TYSingleton shareSingleton].shopArr) {
            model.isSelected = NO;
            self.totalPrices = 0;
            [self.idArr removeAllObjects];
        }
    }
    
    self.totleLabel.text = [NSString stringWithFormat:@"￥%0.2lf",[self.totalPrices doubleValue]/100];
    
    if ([self.totalPrices intValue] > 0) {
        self.settlementBtn.backgroundColor =  RGB(32, 135, 238);
        self.settlementBtn.enabled = YES;
    }else{
        self.settlementBtn.backgroundColor = RGB(238, 238, 238);
        self.settlementBtn.enabled = NO;
    }
    [self.myTableView reloadData];
}

#pragma mark -- 点击结算
- (IBAction)ClickCloseAccount {
    
    if (self.nameLabel.text.length == 0 || self.addressLabel.text.length == 0 || self.telLabel.text.length == 0) {
        [TYShowHud showHudErrorWithStatus:@"请完善收货地址"];
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认付款" message:[NSString stringWithFormat:@"￥%0.2lf元", [self.totalPrices doubleValue]/100] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self requestSMAddorder];
    }];
    
    [alert addAction:action];
    [alert addAction:action1];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -- 网路请求
#pragma mark -----//请求默认地址
-(void)requestAddress{
    
    NSDictionary *params = @{
                             @"a":[TYConsumerLoginModel  getSessionID], //回话session
                             @"b":[TYConsumerLoginModel  getPrimaryId],//用户ID
                             @"c":@(1),//分页index
                             @"d":@(1),//分页size
                             @"d":@(2)//传2 则获取默认地址
                             };
    
    NSString *url = [NSString stringWithFormat:@"%@MAPI/SM/GetSMAddressList",APP_REQUEST_URL];
    
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
        
    } withSuccessBlock:^(id respondObject) {
        
        NSArray *arr = [TYAddressManagementMdoel mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"d"]];
        TYAddressManagementMdoel *model = [arr firstObject];
        self.model = model;
        self.nameLabel.text = [NSString stringWithFormat:@"收货人:%@",[TYValidate IsNotNull:model.dc]];
        self.telLabel.text = model.dd;
        
        NSString *address = [NSString stringWithFormat:@"地址:%@%@%@%@",[TYValidate IsNotNull:model.de],[TYValidate IsNotNull:model.df],[TYValidate IsNotNull:model.dl],[TYValidate IsNotNull:model.dg]];
        // 计算文字的高度
        CGSize rec = [address boundingRectWithSize:CGSizeMake(KScreenWidth - 90, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:15]} context:nil].size;
        self.topViewH.constant = 45 + rec.height;
        self.addressLabel.text = address;
       
        
    } orFailBlock:^(id error) {
        
    }];
}

#pragma mark -----//请求下订单
//【101 购物商城 下订单
-(void)requestSMAddorder{
    
    NSString *idStr = [self.idArr componentsJoinedByString:@","];
    
    NSDictionary *params = @{
                             @"a":[TYConsumerLoginModel getSessionID], //回话session
                             @"b":[TYConsumerLoginModel getPrimaryId], //分销商ID
                             @"c":idStr, //订单拼接连接字符串：产品_数量_价格,2_100,3_2_200
                             @"d":self.model.dc,//收货联系人
                             @"e":self.telLabel.text,//收货电话
                             @"f":self.model.dg//收货地址
                             };
    
    NSString *url = [NSString stringWithFormat:@"%@MAPI/SM/SMAddorder",APP_REQUEST_URL];
    
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
        
    } withSuccessBlock:^(id respondObject) {
        NSLog(@"%@", respondObject);
        
        
        if ([[respondObject objectForKey:@"c"] isKindOfClass:[NSNull class]]) {
            [TYShowHud showHudErrorWithStatus:@"获取订单号失败"];
            return ;
        }else{
            [SVProgressHUD showWithStatus:@"正在支付"];
            self.orderNo = [[respondObject objectForKey:@"c"] objectForKey:@"orderNo"];
            [self requestUnifiedOrder];
        }
        
    } orFailBlock:^(id error) {
        
    }];
}

//【107 购物商城 支付信息回调】
-(void)requestUnifiedOrder{
    //    [NSString stringWithFormat:@"%ld",[self.totalPrices integerValue] * 100]
    NSDictionary *params = @{
                             @"a":[TYConsumerLoginModel getSessionID], //回话session
                             @"b":self.orderNo, //订单编号
                             @"c":self.totalPrices, //总金额
                             @"d":[TYConsumerLoginModel getPrimaryId]//分销商ID
                             };
    NSString *url = [NSString stringWithFormat:@"%@MAPI/SM/UnifiedOrder",APP_REQUEST_URL];
    
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        NSLog(@"%@", respondObject);
        [TYWeChatPayment jumpToBizPay:[respondObject objectForKey:@"c"]];
        [SVProgressHUD dismissWithDelay:1.0];
    } orFailBlock:^(id error) {
        [SVProgressHUD dismissWithDelay:1.0];
    }];
}

//108 购物商城 支付信息回调
-(void)requestUnifiedOrderType:(NSInteger)type{
    
    NSDictionary *params = @{
                             @"a":[TYConsumerLoginModel getSessionID], //回话session
                             @"b":self.orderNo, //订单编号
                             @"c":self.totalPrices, //总金额
                             @"e":@(type)//状态
                             };
    
    NSString *url = [NSString stringWithFormat:@"%@MAPI/SM/WeCharPayRecord",APP_REQUEST_URL];
    
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        for (TYHotProductModel *model in[TYSingleton shareSingleton].shopArr ) {
            model.isSelected = NO;
        }
        [self.myTableView reloadData];
        self.totleLabel.text = [NSString stringWithFormat:@"￥%0.2lf",0.00];
        self.allChooseBtn.selected = NO;
        
    } orFailBlock:^(id error) {
        
    }];
}
- (NSMutableArray *) isAllSelectedArr
{
    if (!_isAllSelectedArr) {
        _isAllSelectedArr = [NSMutableArray array];
    }
    return _isAllSelectedArr;
}

- (NSMutableArray *) idArr
{
    if (!_idArr) {
        _idArr = [NSMutableArray array];
    }
    return _idArr;
}

@end

