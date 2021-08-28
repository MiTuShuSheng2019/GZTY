//
//  TYCargoViewController.m
//  美界联盟
//
//  Created by LY on 2017/12/1.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYCargoViewController.h"
#import "TYQRCodeViewController.h"
#import "TYCargoCell.h"
#import "TYCargoView.h"

@interface TYCargoViewController ()<UITableViewDelegate, UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

//@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
/** 分页 */
@property (nonatomic, assign) NSInteger page;
/** 请求的条数 */
@property (nonatomic, assign) NSInteger limit;


@end

@implementation TYCargoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"防窜货查询" andTitleColor:[UIColor whiteColor] andImage:nil];
    
    //接收通知传值
    NSNotificationCenter * center =[NSNotificationCenter defaultCenter];    [center addObserver:self selector:@selector(RefreshCodeTextFieldData:) name:@"backTYAuthorizationQueryViewController" object:nil];
    
    [self setUpTableView];
    self.page = 1;
    self.limit = 10;
}

//初始化TableView
-(void)setUpTableView{
//    [self requestOutStorageInfoAdd];
    
//    __weak typeof(&*self)weakSelf = self;
//    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        weakSelf.page = 1;
//        [weakSelf.modelArray removeAllObjects];
//
////        [weakSelf requestGetOutStorageDetailList];
//    }];
//
//    self.myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
////        [weakSelf requestGetOutStorageDetailList];
//    }];
//    self.myTableView.mj_footer.hidden = YES;
    
    self.myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.myTableView.tableFooterView = [UIView new];
    self.myTableView.showsVerticalScrollIndicator = NO;
}

-(void)RefreshCodeTextFieldData:(NSNotification *)not{
    self.codeTextField.text = [not.userInfo objectForKey:@"metadataObject"];
    [self requestOutStorageInfoAdd];
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
    
    [self requestOutStorageInfoAdd];
}


#pragma mark -- <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TYCargoCell *cell = [TYCargoCell CellTableView:self.myTableView];
    cell.model = self.modelArray[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 135;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TYCargoModel *model = self.modelArray[indexPath.row];
    
    TYCargoView *shareV = [TYCargoView CreatTTYCargoView];
    shareV.model = model;
    shareV.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:shareV];
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
-(void)requestOutStorageInfoAdd{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sid"] = [TYLoginModel getSessionID];//回话session
    params[@"index"] = @(self.page);//订单id
    params[@"size"] = @(self.limit); //
    params[@"code"] = self.codeTextField.text; //
    params[@"key"] = @""; //
    NSString *url = [NSString stringWithFormat:@"%@mapi/psi/GetOriginLogList",APP_REQUEST_URL];

    [TYNetworking getRequestURL:url parameters:params andProgress:^(double progress) {

    } withSuccessBlock:^(id respondObject) {

         if ([[respondObject objectForKey:@"Status"] integerValue] == 1) {
             NSArray *arr = [TYCargoModel mj_objectArrayWithKeyValuesArray:[respondObject objectForKey:@"Data"]];
             [self.modelArray addObjectsFromArray:arr];
         }
        [self.myTableView reloadData];

    } orFailBlock:^(id error) {

    }];
}


@end
