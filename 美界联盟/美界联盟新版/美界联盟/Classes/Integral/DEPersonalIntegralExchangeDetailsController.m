//
//  DEPersonalIntegralExchangeDetailsController.m
//  美界联盟
//
//  Created by Glory_iMac on 2019/7/24.
//  Copyright © 2019年 刘燚. All rights reserved.
//

#import "DEPersonalIntegralExchangeDetailsController.h"
#import "DEIntegralHeadView.h"
#import "DEIntergralCell.h"
#import "DEIntegralExchangeController.h"

@interface DEPersonalIntegralExchangeDetailsController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel* nameLabel;//姓名
@property (weak, nonatomic) IBOutlet UILabel* phoneLabel;//手机号
@property (weak, nonatomic) IBOutlet UILabel* integralLabel;//积分
@property (strong, nonatomic) IBOutlet UITableView* myTableView;
/** UITableView数组 */
@property (nonatomic, strong) NSMutableArray *dataArr;
/** 分页 */
@property (nonatomic, assign) NSInteger page;
/** 请求的条数 */
@property (nonatomic, assign) NSInteger limit;

@property (nonatomic, strong) NSDictionary *params;

@end

@implementation DEPersonalIntegralExchangeDetailsController


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addNavigationBackBtn:@"back"];

    [self setNavigationBarTitle:@"积分兑换详情" andTitleColor:[UIColor whiteColor] andImage:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(238, 238, 238);
    [self myTableView];
    [self refreshData];
    [self creatView];
}

-(void)creatView
{
    NSString* phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneTextFieldText"];
    if (!phone) {
        phone = @"";
    }
    self.nameLabel.text = [self stringWithFormat:@"姓名" with:@""];
    self.phoneLabel.text = [self stringWithFormat:@"手机号" with:@""];
//    self.integralLabel.text = [self stringWithFormat:@" " with:@" "];
    
    _params = @{@"a":phone,
                @"b":@(self.page)
                };
    
    NSString* url =[NSString stringWithFormat:@"%@mapi/Intergral/MGetExchangeRecordByUser",APP_REQUEST_URL];
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
            self.nameLabel.text = [self stringWithFormat:@"姓名" with:[c objectForKey:@"h"]];
            self.phoneLabel.text = [self stringWithFormat:@"手机号" with:[c objectForKey:@"g"]];
            self.integralLabel.text = [NSString stringWithFormat:@"金币 : %@        银币 : %@",[c objectForKey:@"k"],[c objectForKey:@"i"]];
        }
        [_myTableView reloadData];
    } orFailBlock:^(id error) {
        //        [TYShowHud showHudErrorWithStatus:@"网络超时，请重新再试"];
    }];
}

-(NSString*)stringWithFormat:(NSString*)text with:(NSString*)string
{
    return [NSString stringWithFormat:@"%@:%@",text,string];
}

#pragma mark -- <UITableViewDelegate,UITableViewDataSource>
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    DEIntegralHeadView *headView=[[DEIntegralHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    headView.array=@[@"积分类型",@"花费积分",@"日期",@"备注"];
    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
//    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DEIntergralCell * cell = [DEIntergralCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary* dict = _dataArr[indexPath.row];
    NSMutableArray * muArr = [NSMutableArray array];
    if ([[dict objectForKey:@"fd"]isEqualToString:@"1"]) {
        [muArr addObject:@"银币"];
    }else {
        [muArr addObject:@"金币"];
    }
    NSString * ff = [[[dict objectForKey:@"ff"] componentsSeparatedByString:@" "] firstObject];
    [muArr addObject:[dict objectForKey:@"fc"]];
    [muArr addObject:ff];
    [muArr addObject:[dict objectForKey:@"fg"]];
    cell.array = muArr;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DEIntegralExchangeController *ieVc=[[DEIntegralExchangeController alloc]init];
    ieVc.myUserInteractionEnabled = NO;
    ieVc.infoDict = _dataArr[indexPath.row];
    [self.navigationController pushViewController:ieVc animated:YES];
}

#pragma mark -- 懒加载
- (UITableView *) myTableView
{
//    if (!_myTableView) {
    
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

        _myTableView.backgroundColor = RGB(238, 238, 238);
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
//        _myTableView.tableHeaderView = [UIView new];
        _myTableView.tableFooterView = [UIView new];
        _myTableView.showsVerticalScrollIndicator = NO;
        //去掉cell分割线
        //        _myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [self.view addSubview:_myTableView];
//    }
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
    [p setValue:@(self.page) forKey:@"b"];
    
    NSString *url = [NSString stringWithFormat:@"%@mapi/Intergral/MGetExchangeRecordByUser",APP_REQUEST_URL];
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
