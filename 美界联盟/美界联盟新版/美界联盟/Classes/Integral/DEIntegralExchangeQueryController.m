//
//  DEIntegralExchangeQueryController.m
//  美界联盟
//
//  Created by Glory_iMac on 2019/7/24.
//  Copyright © 2019年 刘燚. All rights reserved.
//

#import "DEIntegralExchangeQueryController.h"
#import "DEIntegralExchangeController.h"
#import "DEIntegralExchangeQueryHeadView.h"
#import "DEIntegralHeadView.h"
#import "DEIntergralCell.h"

@interface DEIntegralExchangeQueryController ()<UITableViewDelegate, UITableViewDataSource,DEIntegralExchangeQueryHeadViewDelegate>

/** UITableView */
@property (nonatomic, strong) UITableView *myTableView;
/** UITableView数组 */
@property (nonatomic, strong) NSMutableArray *dataArr;
/** 分页 */
@property (nonatomic, assign) NSInteger page;
/** 请求的条数 */
@property (nonatomic, assign) NSInteger limit;

@property (nonatomic, strong) NSDictionary *params;

@end

@implementation DEIntegralExchangeQueryController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"积分兑换查询" andTitleColor:[UIColor whiteColor] andImage:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(238, 238, 238);
    
    [self myTableView];
    [self refreshData];
}

-(void)queryName:(NSString *)name phone:(NSString *)phone Date:(NSString *)date1 witnDate:(NSString *)date2 type:(NSInteger)type
{
    [self.view endEditing:YES];
    NSString* t ;
    if (type == 1) {
        t = @"1";
    }else {
        t = @"2";
    }
    _params = @{@"a":phone,
                @"b":name,
                @"c":date1,
                @"d":date2,
                @"e":@(self.page),
                @"f":t
                };
    
    NSString* url =[NSString stringWithFormat:@"%@mapi/Intergral/MGetExchangeRecord",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:_params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        _dataArr = [NSMutableArray array];
        if ([[respondObject objectForKey:@"a"]integerValue] == TYRequestSuccessful) {
            NSDictionary* c = [respondObject objectForKey:@"c"];
            NSArray* arr = [c objectForKey:@"f"];
            
            [_dataArr addObjectsFromArray:arr];
            self.page = self.page + 1;
            if (arr.count < self.limit) {
                self.myTableView.mj_footer.hidden = YES;
            }else{
                self.myTableView.mj_footer.hidden = NO;
            }
        }
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
        [_myTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    } orFailBlock:^(id error) {
        //        [TYShowHud showHudErrorWithStatus:@"网络超时，请重新再试"];
    }];
}

#pragma mark -- <UITableViewDelegate,UITableViewDataSource>
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        DEIntegralExchangeQueryHeadView* headView=[DEIntegralExchangeQueryHeadView CreatDEIntegralExchangeQueryHeadView];
        headView.frame = CGRectMake(0, 0, KScreenWidth, 140);
        headView.delegate = self;
        return headView;
    }
    DEIntegralHeadView *headView=[[DEIntegralHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    headView.array=@[@"姓名",@"手机号",@"花费积分",@"日期"];
    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 140;
    }
    return 45;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return self.dataArr.count;
//    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DEIntergralCell * cell = [DEIntergralCell cellWithTableView:tableView];
    
    NSDictionary* dict = _dataArr[indexPath.row];
    NSString * ff = [[[dict objectForKey:@"ff"] componentsSeparatedByString:@" "] firstObject];
    cell.array=@[[dict objectForKey:@"fb"],
                 [dict objectForKey:@"fa"],
                 [dict objectForKey:@"fc"],
                 ff];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DEIntegralExchangeController* ieVc=[[DEIntegralExchangeController alloc]init];
    ieVc.myUserInteractionEnabled = NO;
    ieVc.infoDict = _dataArr[indexPath.row];
    [self.navigationController pushViewController:ieVc animated:YES];
}


#pragma mark -- 懒加载
- (UITableView *) myTableView
{
    if (!_myTableView) {
        
        CGFloat tabH;
        if (KIsiPhoneX == YES) {
            tabH = KScreenHeight - 88;
        }else{
            if ( [TYDevice systemVersion] < 11.0) {
                tabH = KScreenHeight - 104;
            }else{
                tabH = KScreenHeight - 64;
            }
        }
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, tabH) style:UITableViewStylePlain];
        _myTableView.backgroundColor = RGB(238, 238, 238);
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.tableFooterView = [UIView new];
        _myTableView.showsVerticalScrollIndicator = NO;
        //去掉cell分割线
//        _myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [self.view addSubview:_myTableView];
    }
    return _myTableView;
}

-(void)refreshData{
    self.limit = 50;
    self.page = 1;
    __weak typeof(&*self)weakSelf = self;
    
    self.myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestExpCenterList];
    }];
    
    self.myTableView.mj_footer.hidden = YES;
    [self.myTableView.mj_header beginRefreshing];
    self.myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.myTableView.tableFooterView = [UIView new];
    self.myTableView.showsVerticalScrollIndicator = NO;
}

- (void)requestExpCenterList{
    
    NSMutableDictionary* p =[NSMutableDictionary dictionaryWithDictionary:_params];
    [p setValue:@(self.page) forKey:@"e"];
    
    NSString *url = [NSString stringWithFormat:@"%@mapi/Intergral/MGetExchangeRecord",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:p andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            NSDictionary* c = [respondObject objectForKey:@"c"];
            NSArray* arr = [c objectForKey:@"f"];
            [_dataArr addObjectsFromArray:arr];
            
            self.page = self.page + 1;
            if (arr.count < self.limit) {
                self.myTableView.mj_footer.hidden = YES;
            }else{
                self.myTableView.mj_footer.hidden = NO;
            }
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
        [self.myTableView.mj_footer endRefreshing];
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
        [_myTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    } orFailBlock:^(id error) {
        [self.myTableView.mj_footer endRefreshing];
    }];
}

-(NSMutableArray*) dataArr
{
    if (!_dataArr) {
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
