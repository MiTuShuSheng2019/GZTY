//
//  TYSelectProductViewController.m
//  美界APP
//
//  Created by TY-DENG on 17/8/7.
//  Copyright © 2017年 Lin. All rights reserved.
//

#import "TYSelectProductViewController.h"
#import "TYSelectProductMenuTableViewCell.h"
#import "TYSelectProductTableViewCell.h"
#import "TYProdtypeModel.h"
#import "TYSelectProduct.h"
#import "TYConfirmOrderVC.h"
#import "DESelectPackageTableViewCell.h"
#import "DEPackageDetailController.h"

@interface TYSelectProductViewController ()<UITableViewDataSource,UITableViewDelegate,TYSelectProductTableViewCellDelegate,DESelectPackageTableViewCellDelegate>
{
    NSString * productCellReuseIdentifier;
    NSString * menuCellReuseIdentifier;
    NSMutableArray *menuDataScoure;
    NSMutableDictionary *productDataScoure;
    NSInteger productSection;
    NSInteger productCount;
    CGFloat productPrice;
}
@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (weak, nonatomic) IBOutlet UITableView *pruductTableView;

//商品总价
@property (weak, nonatomic) IBOutlet UILabel *priceCountLabel;
//商品总数量
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
//去下单按钮
@property (weak, nonatomic) IBOutlet UIButton *goOrderBtn;

/** 分类数组 */
@property (nonatomic, strong) NSMutableArray *titleArr;
/** 分页 */
@property (nonatomic, assign) NSInteger page;
/** 请求的条数 */
@property (nonatomic, assign) NSInteger limit;
/** 记录分类id */
@property (nonatomic, assign) NSInteger ProdId;

/** 商品总件数 */
@property (nonatomic, assign) NSInteger totleNumber;
/** 商品总价格 */
@property (nonatomic, assign) double totleprice;
/** 存储选择商品的数组 */
@property (nonatomic, strong) NSMutableArray *dataArr;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *orderArr;

@end

@implementation TYSelectProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"选择商品" andTitleColor:[UIColor whiteColor] andImage:nil];
    
    //设置tableviw
    [self setMenuTableVIew];
    
    [self requestProdtype];
    
    self.numberLabel.hidden = YES;
    
    _productSelectedDictionary = [NSMutableDictionary dictionaryWithCapacity:100];
    productDataScoure = [NSMutableDictionary dictionary];
}

#pragma mark 设置菜单栏tableviw
-(void) setMenuTableVIew{
    self.menuTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.menuTableView.tableFooterView = [UIView new];
    self.menuTableView.showsVerticalScrollIndicator = NO;
    
    self.pruductTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.pruductTableView.tableFooterView = [UIView new];
    self.pruductTableView.showsVerticalScrollIndicator = NO;
}

//刷新数据
-(void)RefreshListData{
    self.limit = 1000;
    [self requestProdlist];
}


#pragma mark 点击去下单
- (IBAction)addToShoppingCartButtonAction:(id)sender {
    if (self.dataArr.count == 0) {
        [TYShowHud showHudErrorWithStatus:@"未选择商品"];
        return;
    }
    TYConfirmOrderVC *orderVc = [[TYConfirmOrderVC alloc] init];
    orderVc.modelArray = self.dataArr;
    orderVc.buyType = 1;
    [self.navigationController pushViewController:orderVc animated:YES];
}


#pragma mark -- <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _menuTableView) {
        return self.titleArr.count;
    }else{
        NSString *key = [NSString stringWithFormat:@"%ld",(long)section];
        NSArray *array = [productDataScoure objectForKey:key];
        return array.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _menuTableView) {
        TYSelectProductMenuTableViewCell *cell = [TYSelectProductMenuTableViewCell CellTableView:self.menuTableView];
        cell.model = self.titleArr[indexPath.row];
        return cell;
    } else {
        if (indexPath.section == 0 || indexPath.section == 1) {
            TYSelectProductTableViewCell *cell = [TYSelectProductTableViewCell CellTableView:self.pruductTableView cellForRowAtIndexPath:indexPath];
            cell.delegate = self;
            //根据key从字典中取出数据显示
            NSString *key = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
            NSArray *array = [productDataScoure objectForKey:key];
            cell.model = array[indexPath.row];
            return cell;
        } else {
            DESelectPackageTableViewCell *cell = [DESelectPackageTableViewCell CellTableView:self.pruductTableView cellForRowAtIndexPath:indexPath];
            cell.delegate = self;
            //根据key从字典中取出数据显示
            NSString *key = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
            NSArray *array = [productDataScoure objectForKey:key];
            cell.model = array[indexPath.row];
            return cell;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _menuTableView) {
        return 45;
    }else{
        return 110;
    }
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _pruductTableView) {
        return  self.titleArr.count;
    }else{
        return 1;
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _pruductTableView) {
        return 30;
    }
    return 0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    @try{
        if (tableView == _pruductTableView) {
            //默认选择
            NSIndexPath *select=[NSIndexPath indexPathForRow:section inSection:0];
            [_menuTableView selectRowAtIndexPath:select animated:YES scrollPosition:UITableViewScrollPositionBottom];
            TYProdtypeModel *model = self.titleArr[section];
            return  model.fb;
        }
    }@catch(NSException *e){
        [ABuyly buylyException:e methodName:NSStringFromSelector(_cmd)];
    };
    return nil;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _menuTableView) {
        TYProdtypeModel *model = self.titleArr[indexPath.row];
        self.ProdId = model.fa;
        [self.pruductTableView.mj_header beginRefreshing];
        [self selectProductPosition:indexPath.row];
    } else {
        if (indexPath.section == 2) {
            //根据key从字典中取出数据显示
            NSString *key = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
            NSArray *array = [productDataScoure objectForKey:key];
            TYSelectProduct *model = array[indexPath.row];
            
            DEPackageDetailController * packageD=[[DEPackageDetailController alloc]init];
            packageD.model = model;
            [self.navigationController pushViewController:packageD animated:YES];
        }
    }
}

#pragma mark 去掉UItableview headerview黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //去掉UItableview headerview黏性(sticky)
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

-(void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    [self.view endEditing:YES];
}

#pragma mark -- <TYSelectProductTableViewCellDelegate>
-(void)selectProductTableViewCell:(TYSelectProductTableViewCell *)cell Number:(NSInteger)number increaseStatus:(BOOL)increaseStatus{
    
    NSIndexPath *path = [self.pruductTableView indexPathForCell:cell];
    //根据key从字典中取出数据显示
    NSString *key = [NSString stringWithFormat:@"%ld",(long)path.section];
    NSArray *array = [productDataScoure objectForKey:key];
    TYSelectProduct *model = array[path.row];
    model.countNumber = number;
    
    //商品售价
    double shopPrice = [model.ee doubleValue];
    
    if (increaseStatus == YES) {
        //总数量
        self.totleNumber = [self.numberLabel.text integerValue] + 1;
        //总价
        self.totleprice = [self.priceCountLabel.text doubleValue] + shopPrice;
      
    }else{
        if ([self.numberLabel.text integerValue] == 0) {
            return;
        }
        self.totleNumber = [self.numberLabel.text integerValue] - 1;
        
        self.totleprice = [self.priceCountLabel.text doubleValue] - shopPrice;
        
    }
    
    if (number == 0) {
        [self.orderArr removeObject:model];
    }else{
        [self.orderArr addObject:model];
    }
    
    //去重数组中的模型
    NSMutableArray *listAry = [[NSMutableArray alloc] init];
    for (NSString *str in self.orderArr) {
        if (![listAry containsObject:str]) {
            [listAry addObject:str];
        }
    }
    self.dataArr = listAry;
    
    self.priceCountLabel.text = [NSString stringWithFormat:@"%0.2lf",self.totleprice];
    if (self.dataArr.count == 0) {
         self.numberLabel.hidden = YES;
    }else{
         self.numberLabel.hidden = NO;
    }
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)self.totleNumber];
}

#pragma mark -- <DESelectPackageTableViewCellDelegate>
-(void)selectPackageTableViewCell:(DESelectPackageTableViewCell *)cell
{
    NSIndexPath *path = [self.pruductTableView indexPathForCell:cell];
    //根据key从字典中取出数据显示
    NSString *key = [NSString stringWithFormat:@"%ld",(long)path.section];
    NSArray *array = [productDataScoure objectForKey:key];
    TYSelectProduct *model = array[path.row];
    model.countNumber = 1;
    
    TYConfirmOrderVC *orderVc = [[TYConfirmOrderVC alloc] init];
    orderVc.modelArray = [NSMutableArray arrayWithObjects:model, nil];
    orderVc.buyType = 2;
    [self.navigationController pushViewController:orderVc animated:YES];
}

#pragma mark 选择菜单中的类型，产品列表滑动到对应的位置
-(void) selectProductPosition:(NSInteger)position{
    @try{
        if (self.modelArray.count > 0) {
            [_pruductTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:position] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }@catch(NSException *e){
        [ABuyly buylyException:e methodName:NSStringFromSelector(_cmd)];
    };
}

#pragma mark -- 网络请求
//15 经销中心 产品分类
-(void)requestProdtype{
    [LoadManager showLoadingView:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = @(0);//品牌ID --默认传0
    
    NSString *url = [NSString stringWithFormat:@"%@mapi/mprod/prodtype",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            NSArray *arr = [TYProdtypeModel mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"f"]];
            
            [self.titleArr addObjectsFromArray:arr];
            
            //先获取到分类在进行数据请求
            [self RefreshListData];
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
        [LoadManager hiddenLoadView];
        [self.menuTableView reloadData];
    } orFailBlock:^(id error) {
        [LoadManager hiddenLoadView];
    }];
}

//16 经销中心 产品列表
-(void)requestProdlist{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = @(self.page);//分页页码
    params[@"c"] = @(self.limit);//分页数量
    params[@"d"] = @(0);//产品分类ID

    NSString *url = [NSString stringWithFormat:@"%@mapi/mprod/prodlist",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {

            NSArray *arr = [TYSelectProduct mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"e"]];
            [self.modelArray addObjectsFromArray:arr];
            
            //循环标题数组
            for (int j = 0; j < self.titleArr.count; ++j) {
                
                //分类数据数组
                NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:0];
                
                TYProdtypeModel *pModel = self.titleArr[j];
                
                for (int i = 0; i < self.modelArray.count; ++i) {
                    TYSelectProduct *model = self.modelArray[i];
                    
                    //根据分类id 拆分数据
                    if (pModel.fa == model.eh) {
                        [dataArray addObject:model];
                    }
                }
                //将拆分后的数据写入字典
                [productDataScoure setObject:dataArray forKey:[NSString stringWithFormat:@"%d",j]];
            }
            
        }else{
             [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
        [self.pruductTableView reloadData];
    } orFailBlock:^(id error) {
        
    }];
}

#pragma mark -- 懒加载
- (NSMutableArray *) titleArr
{
    if (!_titleArr) {
        _titleArr = [NSMutableArray array];
    }
    return _titleArr;
}

- (NSMutableArray *) dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (NSMutableArray *) orderArr
{
    if (!_orderArr) {
        _orderArr = [NSMutableArray array];
    }
    return _orderArr;
}


@end
