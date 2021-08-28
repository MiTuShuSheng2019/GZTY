//
//  TYLowerLevelRechargeViewController.m
//  美界联盟
//
//  Created by LY on 2017/10/31.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYLowerLevelRechargeViewController.h"
#import "TYLowerLevelRechargeCell.h"
#import "TYDistributorsViewController.h"
#import "PassWordView.h"
#import "TYDistributorsModel.h"

@interface TYLowerLevelRechargeViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,TYGlobalSearchViewDelegate>

//头像
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
//可充值金额
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
//下级分销商
@property (weak, nonatomic) IBOutlet UITextField *distributorsTextFiled;
//充值金额
@property (weak, nonatomic) IBOutlet UITextField *rechargeTextField;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

/** 分页 */
@property (nonatomic, assign) NSInteger page;
/** 请求的条数 */
@property (nonatomic, assign) NSInteger limit;
//密码弹框View
@property (strong, nonatomic) PassWordView *passWordV;
/** 记录从分销商返回的模型 */
@property (nonatomic, strong)  TYDistributorsModel *model;

@property (nonatomic, assign) double money;

@end

@implementation TYLowerLevelRechargeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestUpgradeApply];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"给下级充值" andTitleColor:[UIColor whiteColor] andImage:nil];
    [self setNavigationRightBtnImage:@"search"];
    
    //初始化TableView
    [self setUpTableView];
    
    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.headImageView.clipsToBounds = YES;
    //给头部的控件赋值
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoUrl,[TYLoginModel getPhoto]]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
    
    //接收通知传值
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(refreshName:) name:@"backTYLowerLevelRechargeViewController" object:nil];
}

//初始化TableView
-(void)setUpTableView{
    self.limit = 10;
    __weak typeof(&*self)weakSelf = self;
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf.modelArray removeAllObjects];
        [weakSelf requestGetRecharge];
    }];
    
    self.myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestGetRecharge];
    }];
    
    self.myTableView.mj_footer.hidden = YES;
    [self.myTableView.mj_header beginRefreshing];
    self.myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.myTableView.tableFooterView = [UIView new];
}

-(void)refreshName:(NSNotification *)not{
    TYDistributorsModel *model = [not.userInfo objectForKey:@"name"];
    self.model = model;
    self.distributorsTextFiled.text = model.eb;
}

#pragma mark -- 搜索
- (void)navigationRightBtnClick:(UIButton *)btn{
    TYGlobalSearchView *SearchView = [TYGlobalSearchView CreatTYGlobalSearchView];
    SearchView.delegate = self;
    SearchView.frame = CGRectMake(0, 20, KScreenWidth, KScreenHeight);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:SearchView];
    
}

#pragma mark -- <TYGlobalSearchViewDelegate>
-(void)ClickSearch:(NSString *)KeyWord andStartTime:(NSString *)startTime andEndTime:(NSString *)endTime{
    self.keyWord = KeyWord;
    self.startTime = startTime;
    self.endTime = endTime;
    [self.myTableView.mj_header beginRefreshing];
}

#pragma mark -- 点击分销商
- (IBAction)ClickDistributors {
    [self.view endEditing:YES];
    TYDistributorsViewController *distributorsVc = [[TYDistributorsViewController alloc] init];
    distributorsVc.type = 1;
    [self.navigationController pushViewController:distributorsVc animated:YES];
}

#pragma mark -- 点击充值
- (IBAction)ClickRecharge {
    
    if (self.distributorsTextFiled.text.length == 0) {
        [TYShowHud showHudErrorWithStatus:@"请选择分销商"];
        return;
    }
    if (self.rechargeTextField.text.length == 0) {
        [TYShowHud showHudErrorWithStatus:@"请输入充值金额"];
        return;
    }
    if ([self.rechargeTextField.text doubleValue] > self.money) {
        [TYShowHud showHudErrorWithStatus:@"可充值货币不足"];
        return;
    }else{
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.passWordV];
        
        __weak typeof(&*self)weakSelf = self;
        
        self.passWordV.viewCancelBlock = ^(){
            NSLog(@"消失了");
        };
        
        self.passWordV.viewConfirmBlock=^(NSString *text){
            
            if (text.length == 6 && [text isEqualToString:[TYLoginModel getPayPassword]]) {
                [weakSelf requestRechargeAdd];
            }else if (text.length == 6 && [text isEqualToString:[TYLoginModel getPayPassword]] == NO){
                [TYShowHud showHudErrorWithStatus:@"密码输入错误请重新输入"];
                [weakSelf.passWordV removeFromSuperview];
            }
        };
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark -- <UITextFieldDelegate>
-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == _distributorsTextFiled) {
        [self ClickDistributors];
        return false;
    }
    return true;
}

#pragma mark -- <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TYLowerLevelRechargeCell *cell = [TYLowerLevelRechargeCell CellTableView:self.myTableView];
    cell.model = self.modelArray[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
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
//获取历史记录
-(void)requestGetRecharge{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = @(self.page);//分页页码
    params[@"c"] = @(self.limit);//分页数量
    params[@"d"] = @([TYLoginModel getPrimaryId]);//分销商ID
    params[@"e"] = @(1);//操作类型 1:充值 2、扣减 3、发货新增 4 退货扣减
    params[@"f"] = self.startTime;//查询开始时间
    params[@"g"] = self.endTime;//查询结束时间
    
    NSString *url = [NSString stringWithFormat:@"%@mapi/recharge/GetMyLowerLog",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            NSArray *arr = [TYRechargeModel mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"e"]];
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

//【50 经销中心 充值管理 给下级充值】
-(void)requestRechargeAdd{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = @([TYLoginModel getPrimaryId]);//操作分销商编号
    params[@"c"] = @(self.model.ea);//下级分销商编号
    params[@"d"] = self.rechargeTextField.text;//金额
    
    NSString *url = [NSString stringWithFormat:@"%@mapi/recharge/RechargeAdd",APP_REQUEST_URL];
     __weak typeof(&*self)weakSelf = self;
    
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            
            if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
                [TYShowHud showHudSucceedWithStatus:@"充值成功"];
                [weakSelf.passWordV removeFromSuperview];
                [weakSelf.myTableView.mj_header beginRefreshing];
                
                weakSelf.money = weakSelf.money - [weakSelf.rechargeTextField.text doubleValue];
                weakSelf.moneyLabel.text = [NSString stringWithFormat:@"可充值货币：￥%0.2lf",weakSelf.money];
            }
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
        
    } orFailBlock:^(id error) {
        
    }];
}

//请求可充值余额
-(void)requestUpgradeApply{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"CusID"] = @([TYLoginModel getPrimaryId]);
    
    NSString *url = [NSString stringWithFormat:@"%@SAPI/User/SurplusAmount",APP_REQUEST_URL];
    __weak typeof(&*self)weakSelf = self;
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        if ([[respondObject objectForKey:@"Status"] boolValue] == true) {
            weakSelf.money = [[[respondObject objectForKey:@"Data"] objectForKey:@"Sur"] doubleValue];
            weakSelf.moneyLabel.text = [NSString stringWithFormat:@"可充值货币：￥%0.2lf",weakSelf.money];
        }
        
    } orFailBlock:^(id error) {
        [TYShowHud showHudErrorWithStatus:@"接口请求失败"];
    }];
}

#pragma mark -- 懒加载
- (PassWordView *)passWordV
{
    if (!_passWordV) {
        _passWordV = [[PassWordView instance] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    }
    return _passWordV;
}

@end
