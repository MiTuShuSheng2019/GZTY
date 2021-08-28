//
//  TYDistributorsSearchVC.m
//  美界联盟
//
//  Created by LY on 2017/11/28.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYDistributorsSearchVC.h"
#import "TYDistributorsCell.h"
#import "TYOutboundGoodsViewController.h"
#import "TYLowerLevelRechargeViewController.h"

@interface TYDistributorsSearchVC ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic,strong) UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

/** 分页 */
//@property (nonatomic, assign) NSInteger page;
///** 请求的条数 */
//@property (nonatomic, assign) NSInteger limit;

@end

@implementation TYDistributorsSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationRightBtnText:@"取消" andTextColor:[UIColor whiteColor]];
    
    [self setUpTableView];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.searchBar endEditing:YES];
    [self.searchBar removeFromSuperview];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.autoresizingMask = UIViewAutoresizingNone;
    [self createSearchBar];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.searchBar endEditing:YES];
}
//------创建SearchBar-----
-(void)createSearchBar{
    
    self.navigationItem.hidesBackButton = YES;
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0.0, 0.0, KScreenWidth - 54.0, 44.0)];
    
    self.searchBar.delegate  = self;
    self.searchBar.barStyle = UIBarStyleDefault;
    self.searchBar.placeholder = @"请输入手机号查询";
    self.searchBar.searchBarStyle = UISearchBarStyleDefault;
    [self.searchBar becomeFirstResponder];
    [self.navigationController.navigationBar addSubview:self.searchBar];
}

//导航栏右边按钮被按下的触发事件
- (void)navigationRightBtnClick:(UIButton *)btn{
    [self.searchBar endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark <UISearchBarDelegate>----------开始搜索
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
        if (searchText.length >= 1) {
            [self.modelArray removeAllObjects];
//            self.siginaLab.hidden = YES;
//            self.listTableView.hidden = NO;
            [self requestGetLowerCus:searchText];
        }
}

//初始化TableView
-(void)setUpTableView{
//    self.limit = 10;
//    __weak typeof(&*self)weakSelf = self;
//    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        weakSelf.page = 1;
//        [weakSelf.modelArray removeAllObjects];
//        [weakSelf requestGetLowerCus];
//    }];
//
//    self.myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        [weakSelf requestGetLowerCus];
//    }];
//
//    self.myTableView.mj_footer.hidden = YES;
//    [self.myTableView.mj_header beginRefreshing];
    self.myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.myTableView.tableFooterView = [UIView new];
    self.myTableView.showsVerticalScrollIndicator = NO;
}

#pragma mark --- <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        TYDistributorsCell *cell = [TYDistributorsCell CellTableView:self.myTableView];
        cell.model = self.modelArray[indexPath.row];
        return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 110;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TYDistributorsModel *model = self.modelArray[indexPath.row];
    if (self.type == 1) {
        NSNotification *not = [[NSNotification alloc] initWithName:@"backTYLowerLevelRechargeViewController" object:nil userInfo:@{@"name":model}];
        
        [[NSNotificationCenter defaultCenter] postNotification:not];
        
        //返回指定控制器
        NSArray *temArray = self.navigationController.viewControllers;
        for(UIViewController *temVC in temArray){
            if ([temVC isKindOfClass:[TYLowerLevelRechargeViewController class]]){
                TYLowerLevelRechargeViewController *tempVc = [[TYLowerLevelRechargeViewController alloc] init];
                tempVc = (TYLowerLevelRechargeViewController *)temVC;
                [self.navigationController popToViewController:tempVc animated:YES];
            }
        }
       
    }else{
        //返回指定控制器
        NSArray *temArray = self.navigationController.viewControllers;
        for(UIViewController *temVC in temArray){
            if ([temVC isKindOfClass:[TYOutboundGoodsViewController class]]){
                TYOutboundGoodsViewController *tempVc = [[TYOutboundGoodsViewController alloc] init];
                tempVc = (TYOutboundGoodsViewController *)temVC;
                tempVc.orderID = [NSString stringWithFormat:@"%ld",model.ea];
                [self.navigationController popToViewController:tempVc animated:YES];
            }
        }
        
//        TYOutboundGoodsViewController *outVc = [[TYOutboundGoodsViewController alloc] init];
//        outVc.orderID = [NSString stringWithFormat:@"%ld",model.ea];
//        [self.navigationController pushViewController:outVc animated:YES];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.searchBar endEditing:YES];
}

#pragma mark --- 网络请求
//13 经销中心-授权中心-获取下级分销商
-(void)requestGetLowerCus:(NSString *)searchStr{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = @(1);//分页页码
    params[@"c"] = @(100);//分页数量
    params[@"d"] = @([TYLoginModel getPrimaryId]);//分销商ID
    params[@"e"] = @(2);//下级分销商审核状态 0所有 1未审核、2已审核
    params[@"f"] = @(1);//下级分销商当前状态 0所有 1正常、2禁用
    params[@"g"] = @"";//等级 只获取某一个等级的分销商 0 所有
    //    params[@"h"] = @(1);//是否仅仅获取直属下级 1:只查询自己的直属分销商,2:查询自己和直属分销商,3:查询自己和所有下级分销商，4：查询直属下级非同等级分销商（用于推荐升级），5：查询所有下级分销商
    if (self.type == 1) {
        params[@"h"] = @(6);
    }else{
        params[@"h"] = @(4);
    }
    
    params[@"i"] = searchStr;//分销商筛选条件 分销商名称、电话，微信模糊查询
//    params[@"j"] = @"";//审核开始时间
//    params[@"k"] = @"";//审核开始时间
    
    NSString *url = [NSString stringWithFormat:@"%@mapi/mcus/getLowerCus",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            NSArray *arr = [TYDistributorsModel mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"e"]];
            [self.modelArray addObjectsFromArray:arr];
            
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
        [self.myTableView reloadData];
    } orFailBlock:^(id error) {

    }];
}


@end
