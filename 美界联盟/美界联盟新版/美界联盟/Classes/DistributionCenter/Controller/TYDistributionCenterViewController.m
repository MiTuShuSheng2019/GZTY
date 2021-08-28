//
//  TYDistributionCenterViewController.m
//  美界联盟
//
//  Created by LY on 2017/10/23.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYDistributionCenterViewController.h"
#import "TYDistributionHeadCell.h"
#import "TYDistributionCenterCell.h"
#import "TYDistributionTitleView.h"
#import "TYLoginChooseViewController.h"
#import "TYCusPriceModel.h"
#import "TYRechargeManagementViewController.h"
#import "TYTransactionRecordViewController.h"
#import "TYRebateManagementViewController.h"
#import "TYContactUsViewController.h"
#import "TYSystemFeedbackViewController.h"
#import "TYMyOrderViewController.h"
#import "TYLowerOrderViewController.h"
#import "TYAuthoriseViewController.h"
#import "TYDealerManagementViewController.h"
#import "TYTeamManagementViewController.h"
#import "TYAuthorizationQueryViewController.h"
#import "TYRecommendUpgradeViewController.h"
#import "TYShippingViewController.h"
#import "TYDeliveryRecordVC.h"
#import "TYRetailDeliveryVC.h"
#import "TYMyInventoryVC.h"
#import "TYAwaitingDeliveryViewController.h"
#import "TYCargoViewController.h"
#import "TYTeamResultsVC.h"
#import "TYPersonResultsVC.h"
#import "TYCashWalletVC.h"
#import "TYUpgradeApplyVC.h"
#import "TYTeamPerformanceVC.h"
#import "TYCarPerformanceVC.h"

#import "DEIntegralQueryController.h"
#import "DEIntegralExchangeQueryController.h"
#import "DEPersonalIntegralExchangeDetailsController.h"
#import "DEConversionIntegralViewController.h"
#import "TYOpenWXVC.h"

@interface TYDistributionCenterViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *MyCollectionView;
/** 头部标题数组 */
@property (nonatomic, strong) NSArray *headTitleArr;
/** 头部图标数组 */
@property (nonatomic, strong) NSArray *headImageArr;
/** 标题数组1 */
@property (nonatomic, strong) NSArray *titleArr1;
/** 标题数组2 */
@property (nonatomic, strong) NSArray *titleArr2;
/** 标题数组3 */
@property (nonatomic, strong) NSArray *titleArr3;
/** 标题数组4 */
@property (nonatomic, strong) NSArray *titleArr4;
/** 标题数组5 */
@property (nonatomic, strong) NSArray *titleArr5;

/** 图标数组1 */
@property (nonatomic, strong) NSArray *imgArr1;
/** 图标数组2 */
@property (nonatomic, strong) NSArray *imgArr2;
/** 图标数组3 */
@property (nonatomic, strong) NSArray *imgArr3;
/** 图标数组4 */
@property (nonatomic, strong) NSArray *imgArr4;
/** 图标数组5 */
@property (nonatomic, strong) NSArray *imgArr5;

/** TYCusPriceModel金额总接口模型 */
@property (nonatomic, strong) TYCusPriceModel *model;

/** 记录消息读书Label */
@property (nonatomic, strong) UILabel *msgLabel;

/** 差额汇总数组 */
@property (nonatomic, strong) NSMutableArray *oneArr;
/** 可充值余额 */
@property (nonatomic, assign) double money;

@end

@implementation TYDistributionCenterViewController

static NSString *const TYDistributionCenterCellId = @"TYDistributionCenterCell";
static NSString *const TYDistributionHeadCellId = @"TYDistributionHeadCell";
static NSString *const MyHeadViewId = @"TYDistributionTitleView";

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [self.view addSubview:self.MyCollectionView];
    //请求消息数量
    [self requestMSysListCount];
    //经销中心 金额总接口
    [self requestCusPriceList];
    
    [self requestGetDiffPrice];
    
    [self requestUpgradeApply];
    
    if ([TYSingleton shareSingleton].consumer == 1) {
        self.headTitleArr = [NSArray arrayWithObjects:@"我的订单",@"小游戏",nil];
        self.headImageArr = [NSArray arrayWithObjects:@"订单管理",@"小游戏",nil];
        
        self.titleArr1 = [NSArray arrayWithObjects:@"待发货", @"待收货",@"已完成", nil];
        self.titleArr2 = [NSArray arrayWithObjects:@"天降红包",@"", @"",nil];;
        self.titleArr3 = nil;
        self.titleArr4 = nil;
        self.titleArr5 = nil;
        self.imgArr1 = [NSArray arrayWithObjects:@"send_goods",@"awaiting_delivery",@"completed", nil];
        self.imgArr2 = [NSArray arrayWithObjects:@"天降红包",@"", @"",nil];;
        self.imgArr3 = nil;
        self.imgArr4 = nil;
        self.imgArr5 = nil;
    }else{
        NSString* phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneTextFieldText"];
        
        self.headTitleArr = [NSArray arrayWithObjects:@"我的钱包",@"分销管理",@"订单管理",@"小游戏",@"其他", nil];
        self.headImageArr = [NSArray arrayWithObjects:@"我的钱包",@"分销管理",@"订单管理",@"小游戏",@"其他", nil];
        
        //在数组中加 @"" 是为了凑为3的倍数，让空的cell显示为白色
        self.titleArr1 = [NSArray arrayWithObjects:@"交易记录", @"现金钱包", @"",  nil];
        if ([TYLoginModel getGradeId] == 9) {
            //等级为9才有推荐升级
            //            self.titleArr2 = [NSArray arrayWithObjects:@"授权生成",@"经销商管理",@"团队管理",@"授权查询",@"推荐升级", @"团队业绩",@"个人业绩",nil];
            //             self.titleArr2 = [NSArray arrayWithObjects:@"授权生成",@"经销商管理",@"团队管理",@"授权查询",@"推荐升级", @"",nil];
            if ([phone isEqualToString:@"17612492497"]) {
                self.titleArr2 = [NSArray arrayWithObjects:@"授权生成",@"经销商管理",@"授权查询",@"推荐升级", @"积分查询",@"积分兑换查询",@"积分转换",@"",@"", nil];
            }else {
                self.titleArr2 = [NSArray arrayWithObjects:@"授权生成",@"经销商管理",@"授权查询",@"推荐升级",@"积分兑换查询",@"积分转换", nil];
            }
            //            self.titleArr2 = [NSArray arrayWithObjects:@"授权生成",@"经销商管理",@"授权查询",@"推荐升级", @"积分查询",@"积分兑换查询",@"积分转换",@"",@"", nil];
        }else{
            
            if ([TYLoginModel getPrimaryId] == 2) {//是总部
                //                 self.titleArr2 = [NSArray arrayWithObjects:@"授权生成",@"经销商管理",@"团队管理",@"授权查询", @"升级申请", @"", nil];
                if ([phone isEqualToString:@"17612492497"]) {
                    self.titleArr2 = [NSArray arrayWithObjects:@"授权生成",@"经销商管理",@"授权查询", @"升级申请", @"积分查询",@"积分兑换查询",@"积分转换",@"",@"",nil];
                }else {
                    self.titleArr2 = [NSArray arrayWithObjects:@"授权生成",@"经销商管理",@"授权查询", @"升级申请",@"积分兑换详情",@"积分转换",nil];
                }
                //                self.titleArr2 = [NSArray arrayWithObjects:@"授权生成",@"经销商管理",@"授权查询", @"升级申请", @"", @"",nil];
            }else{
                if ([phone isEqualToString:@"17612492497"]) {
                    self.titleArr2 = [NSArray arrayWithObjects:@"授权生成",@"经销商管理",@"授权查询", @"积分查询",@"积分兑换查询",@"积分转换",nil];
                }else {
                    self.titleArr2 = [NSArray arrayWithObjects:@"授权生成",@"经销商管理",@"授权查询",@"积分兑换详情",@"积分转换",@"",nil];
                }
                //                 self.titleArr2 = [NSArray arrayWithObjects:@"授权生成",@"经销商管理",@"授权查询",  nil];
            }
        }
        
        self.titleArr3 = [NSArray arrayWithObjects:@"我的订单",@"防窜货查询", @"",nil];
        //        self.titleArr4 = [NSArray arrayWithObjects:@"零售发货",@"我的库存", @"", @"",nil];
        
        self.titleArr4 = [NSArray arrayWithObjects:@"天降红包",@"", @"",nil];
        
        self.titleArr5 = [NSArray arrayWithObjects:@"系统反馈",@"联系我们",@"",nil];
        
        self.imgArr1 = [NSArray arrayWithObjects:@"交易记录", @"现金钱包", @"", nil];
        if ([TYLoginModel getGradeId] == 9) {
            //            self.imgArr2 = [NSArray arrayWithObjects:@"授权生成",@"经销商管理",@"团队管理",@"授权查询", @"推荐升级", @"", @"", nil];
            if ([phone isEqualToString:@"17612492497"]) {
                self.self.imgArr2 = [NSArray arrayWithObjects:@"授权生成",@"经销商管理",@"授权查询",@"推荐升级", @"积分查询",@"积分兑换查询",@"积分兑换",@"",@"", nil];
            }else {
                self.self.imgArr2 = [NSArray arrayWithObjects:@"授权生成",@"经销商管理",@"授权查询",@"推荐升级",@"积分兑换查询",@"积分兑换", nil];
            }
            //            self.imgArr2 = [NSArray arrayWithObjects:@"授权生成",@"经销商管理",@"授权查询", @"推荐升级", @"", @"", nil];
        }else{
            if ([TYLoginModel getPrimaryId] == 2) {//是总部
                //                self.imgArr2 = [NSArray arrayWithObjects:@"授权生成",@"经销商管理",@"团队管理",@"授权查询", @"升级申请", @"团队业绩", nil];
                //                 self.imgArr2 = [NSArray arrayWithObjects:@"授权生成",@"经销商管理",@"团队管理",@"授权查询", @"升级申请", @"", nil];
                if ([phone isEqualToString:@"17612492497"]) {
                    self.imgArr2 = [NSArray arrayWithObjects:@"授权生成",@"经销商管理",@"授权查询", @"升级申请", @"积分查询",@"积分兑换查询",@"积分兑换",@"",@"",nil];
                }else {
                    self.imgArr2 = [NSArray arrayWithObjects:@"授权生成",@"经销商管理",@"授权查询", @"升级申请",@"积分兑换详情",@"积分兑换",nil];
                }
                //                self.imgArr2 = [NSArray arrayWithObjects:@"授权生成",@"经销商管理",@"授权查询", @"升级申请", @"", @"", nil];
            }else{
                //                self.imgArr2 = [NSArray arrayWithObjects:@"授权生成",@"经销商管理",@"团队管理",@"授权查询",@"",@"", nil];
                if ([phone isEqualToString:@"17612492497"]) {
                    self.imgArr2 = [NSArray arrayWithObjects:@"授权生成",@"经销商管理",@"授权查询", @"积分查询",@"积分兑换查询",@"积分兑换",nil];
                }else {
                    self.imgArr2 = [NSArray arrayWithObjects:@"授权生成",@"经销商管理",@"授权查询",@"积分兑换详情",@"积分兑换",@"",nil];
                }
                //                 self.imgArr2 = [NSArray arrayWithObjects:@"授权生成",@"经销商管理",@"授权查询",nil];
            }
            
        }
        self.imgArr3 = [NSArray arrayWithObjects:@"我的订单",@"防窜货查询", @"",nil];
        //        self.imgArr4 = [NSArray arrayWithObjects:@"零售发货",@"我的库存", @"", @"",nil];
        self.imgArr4 = [NSArray arrayWithObjects:@"天降红包",@"", @"",nil];
        
        self.imgArr5 = [NSArray arrayWithObjects:@"系统反馈",@"联系我们",@"",nil];
    }
    
    [self.MyCollectionView reloadData];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self IsNeedLogin];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarTitle:nil andTitleColor:[UIColor whiteColor] andImage:nil];
    self.view.backgroundColor = [UIColor whiteColor];
}


#pragma mark --- 判断是否需要登陆
-(void)IsNeedLogin{
    if ([TYSingleton shareSingleton].consumer == 1) {
        //消费者登录
        if ([TYConsumerLoginModel getPrimaryId] > 0) {
            return;
        }else{
            TYLoginChooseViewController *loginVc = [[TYLoginChooseViewController alloc] init];
            [self.navigationController pushViewController:loginVc animated:YES];
        }
    }else{
        //分销商登录
        if ([TYLoginModel getPrimaryId] > 0) {
            return;
        }else{
            TYLoginChooseViewController *loginVc = [[TYLoginChooseViewController alloc] init];
            [self.navigationController pushViewController:loginVc animated:YES];
        }
    }
    
}

#pragma mark ---<UICollectionViewDelegate,UICollectionViewDataSource>
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return self.titleArr1.count;
    }else if (section == 2){
        return self.titleArr2.count;
    }else if (section == 3){
        return self.titleArr3.count;
    }else if (section == 4){
        return self.titleArr4.count;
    }else{
        return self.titleArr5.count;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        //加载头部的cell
        TYDistributionHeadCell *cell = [self.MyCollectionView dequeueReusableCellWithReuseIdentifier:TYDistributionHeadCellId forIndexPath:indexPath];
        if ([TYSingleton shareSingleton].consumer == 1) {
            cell.consumerModel = [TYConsumerLoginModel new];
        }else{
            cell.model = [TYLoginModel new];
            //            cell.PriceModel = self.model;
            cell.diffModel = [self.oneArr firstObject];
            self.msgLabel = cell.mesLabel;
        }
        
        return cell;
    }else{
        //加载其他类型的cell
        TYDistributionCenterCell *cell = [self.MyCollectionView dequeueReusableCellWithReuseIdentifier:TYDistributionCenterCellId forIndexPath:indexPath];
        if (indexPath.section == 1) {
            cell.explainLabel.text = self.titleArr1[indexPath.row];
            cell.icon.image = [UIImage imageNamed:self.imgArr1[indexPath.row]];
        }else if (indexPath.section == 2){
            cell.explainLabel.text = self.titleArr2[indexPath.row];
            cell.icon.image = [UIImage imageNamed:self.imgArr2[indexPath.row]];
        }else if (indexPath.section == 3){
            cell.explainLabel.text = self.titleArr3[indexPath.row];
            cell.icon.image = [UIImage imageNamed:self.imgArr3[indexPath.row]];
        }
        else if (indexPath.section == 4){
            cell.explainLabel.text = self.titleArr4[indexPath.row];
            cell.icon.image = [UIImage imageNamed:self.imgArr4[indexPath.row]];
        }
        else{
            cell.explainLabel.text = self.titleArr5[indexPath.row];
            cell.icon.image = [UIImage imageNamed:self.imgArr5[indexPath.row]];
        }
        return cell;
    }
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if ([TYSingleton shareSingleton].consumer == 1) {
        return 2;
    }else{
        return self.headTitleArr.count + 1;
    }
}

//定义每个UICollectionView ,横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

//纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if ([TYSingleton shareSingleton].consumer == 1) {
            return CGSizeMake(KScreenWidth, 240);
        }else{
            return CGSizeMake(KScreenWidth, 220);
        }
    }else{
        return CGSizeMake((KScreenWidth-2)/3, KScreenWidth/3 - 20);
    }
}

//绘制头视图或尾视图 头视图或尾视图上可以添加任意控件
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    //头视图或尾视图 遵循复用机制
    
    UICollectionReusableView *crv = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MyHeadViewId forIndexPath:indexPath];
    TYDistributionTitleView *headView = [TYDistributionTitleView CreatTYDistributionTitleView];
    headView.width = KScreenWidth;
    if (indexPath.section == 0) {
        return nil;
    }else{
        headView.headImageView.image = [UIImage imageNamed:self.headImageArr[indexPath.section - 1]];
        headView.title.text = self.headTitleArr[indexPath.section - 1];
        if (indexPath.section == 1) {
            headView.moneyLabel.text = [NSString stringWithFormat:@"可充值货币￥%0.2lf",self.money];
            
            if ([TYSingleton shareSingleton].consumer == 1) {
                headView.moneyLabel.hidden = YES;
            }else{
                headView.moneyLabel.hidden = NO;
            }
        }else{
            headView.moneyLabel.hidden = YES;
        }
    }
    [crv addSubview:headView];
    return crv;
}

//设置头视图的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(0, 0);
    }else{
        return CGSizeMake(KScreenWidth, 45);
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            if ([TYSingleton shareSingleton].consumer == 1) {
                //1表示从待收货进入
                TYAwaitingDeliveryViewController *DeliveryVc = [[TYAwaitingDeliveryViewController alloc] init];
                DeliveryVc.isWho = 1;
                [self.navigationController pushViewController:DeliveryVc animated:YES];
            }else{
                //交易记录
                TYRechargeManagementViewController *RechargeVc = [[TYRechargeManagementViewController alloc] init];
                [self.navigationController pushViewController:RechargeVc animated:YES];
            }
        }else if(indexPath.row == 1){
            if ([TYSingleton shareSingleton].consumer == 1) {
                //待收货
                TYAwaitingDeliveryViewController *DeliveryVc = [[TYAwaitingDeliveryViewController alloc] init];
                DeliveryVc.isWho = 2;
                [self.navigationController pushViewController:DeliveryVc animated:YES];
            }else{
                //现金钱包
                TYCashWalletVC *vc = [[TYCashWalletVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else{
            if ([TYSingleton shareSingleton].consumer == 1) {
                //已完成
                TYAwaitingDeliveryViewController *DeliveryVc = [[TYAwaitingDeliveryViewController alloc] init];
                DeliveryVc.isWho = 3;
                [self.navigationController pushViewController:DeliveryVc animated:YES];
            }else{
                return;
            }
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            if ([TYSingleton shareSingleton].consumer == 1) {
                //天降红包
                NSString* phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneTextFieldText"];
                if (!phone) {
                    phone = @"";
                }
                NSString* urlStr = [NSString stringWithFormat:@"%@game/gamepage/index.html?userCode=%@",APP_REQUEST_URL,phone];
                TYOpenWXVC *vc = [[TYOpenWXVC alloc] init];
                vc.titleText = @"天降红包";
                vc.url = urlStr;
                [self.navigationController pushViewController:vc animated:YES];
                
            } else {//授权生成
                TYAuthoriseViewController *authoriseVc = [[TYAuthoriseViewController alloc] init];
                [self.navigationController pushViewController:authoriseVc animated:YES];
            }
        }else if (indexPath.row == 1){//经销商管理
            
            TYDealerManagementViewController *ManagementVc = [[TYDealerManagementViewController alloc] init];
            [self.navigationController pushViewController:ManagementVc animated:YES];
        }else if (indexPath.row == 2){
            //团队管理
            //            TYTeamManagementViewController *TeamVc = [[TYTeamManagementViewController alloc] init];
            //            [self.navigationController pushViewController:TeamVc animated:YES];
            //授权查询
            TYAuthorizationQueryViewController *AuthorizationVc = [[TYAuthorizationQueryViewController alloc] init];
            [self.navigationController pushViewController:AuthorizationVc animated:YES];
        }else if (indexPath.row == 3){
            //推荐升级
            if ([TYLoginModel getGradeId] == 9){
                TYRecommendUpgradeViewController *recommendVc = [[TYRecommendUpgradeViewController alloc] init];
                [self.navigationController pushViewController:recommendVc animated:YES];
            }if ([TYLoginModel getPrimaryId] == 2) {//是总部
                //升级申请
                TYUpgradeApplyVC *vc = [[TYUpgradeApplyVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                
            }else{
                //团队业绩
                //                TYTeamResultsVC *vc = [[TYTeamResultsVC alloc] init];
                //                [self.navigationController pushViewController:vc animated:YES];
            }
        }else if (indexPath.row == 4){
            NSString* phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneTextFieldText"];
            if ([phone isEqualToString:@"17612492497"]) {
                //积分查询
                
                DEIntegralQueryController *iqvc=[[DEIntegralQueryController alloc]init];
                [self.navigationController pushViewController:iqvc animated:YES];
            } else {
                //个人积分兑换查询
                DEPersonalIntegralExchangeDetailsController *iqvc=[[DEPersonalIntegralExchangeDetailsController alloc]init];
                [self.navigationController pushViewController:iqvc animated:YES];
            }
            //            if ([TYLoginModel getGradeId] == 9 || [TYLoginModel getPrimaryId] == 2) {
            //                //团队业绩
            //                //                TYTeamResultsVC *vc = [[TYTeamResultsVC alloc] init];
            //                //                [self.navigationController pushViewController:vc animated:YES];
            //                //新
            //                //                TYTeamPerformanceVC *vc = [[TYTeamPerformanceVC alloc] init];
            //                //                [self.navigationController pushViewController:vc animated:YES];
            //
            //                //                TYCarPerformanceVC *vc = [[TYCarPerformanceVC alloc] init];
            //                //                [self.navigationController pushViewController:vc animated:YES];
            //
            //            }else{
            //                //个人业绩
            //                TYPersonResultsVC *vc = [[TYPersonResultsVC alloc] init];
            //                [self.navigationController pushViewController:vc animated:YES];
            //            }
            
            //            if ([TYLoginModel getGradeId] == 9) {
            //                //个人业绩
            //                TYPersonResultsVC *vc = [[TYPersonResultsVC alloc] init];
            //                [self.navigationController pushViewController:vc animated:YES];
            //            }else{
            //                return;
            //            }
            
        }else if (indexPath.row == 5){
            NSString* phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneTextFieldText"];
            if ([phone isEqualToString:@"17612492497"]) {
                //积分兑换查询
                DEIntegralExchangeQueryController *iqvc=[[DEIntegralExchangeQueryController alloc]init];
                [self.navigationController pushViewController:iqvc animated:YES];
            } else {
                //积分兑换
                DEConversionIntegralViewController *civc=[[DEConversionIntegralViewController alloc]init];
                [self.navigationController pushViewController:civc animated:YES];
            }
        
        //            if ([TYLoginModel getGradeId] == 9 || [TYLoginModel getPrimaryId] == 2) {
        //                //团队业绩
        ////                TYTeamResultsVC *vc = [[TYTeamResultsVC alloc] init];
        ////                [self.navigationController pushViewController:vc animated:YES];
        //                //新
        ////                TYTeamPerformanceVC *vc = [[TYTeamPerformanceVC alloc] init];
        ////                [self.navigationController pushViewController:vc animated:YES];
        //
        ////                TYCarPerformanceVC *vc = [[TYCarPerformanceVC alloc] init];
        ////                [self.navigationController pushViewController:vc animated:YES];
        //
        //            }else{
        //                //个人业绩
        //                TYPersonResultsVC *vc = [[TYPersonResultsVC alloc] init];
        //                [self.navigationController pushViewController:vc animated:YES];
        //            }
        //
        //
        //        }else{
        //            if ([TYLoginModel getGradeId] == 9) {
        //                //个人业绩
        //                TYPersonResultsVC *vc = [[TYPersonResultsVC alloc] init];
        //                [self.navigationController pushViewController:vc animated:YES];
        //            }else{
        //                return;
        //            }
        //        }
        
        }else if (indexPath.row == 6){
            //积分兑换
            DEConversionIntegralViewController *civc=[[DEConversionIntegralViewController alloc]init];
            [self.navigationController pushViewController:civc animated:YES];
        }
    }else if (indexPath.section == 3){
        if (indexPath.row == 0) {//我的订单
            TYMyOrderViewController *myOrderVc = [[TYMyOrderViewController alloc] init];
            [self.navigationController pushViewController:myOrderVc animated:YES];
        }else{
            //            TYLowerOrderViewController *lowerOrderVc = [[TYLowerOrderViewController alloc] init];
            //            [self.navigationController//下级订单 pushViewController:lowerOrderVc animated:YES];
            if (indexPath.row == 1) {
                //防窜货货查询
                TYCargoViewController *lowerOrderVc = [[TYCargoViewController alloc] init];
                [self.navigationController pushViewController:lowerOrderVc animated:YES];
            }
        }
        
    }
    else if (indexPath.section == 4){
        if (indexPath.row == 0) {
            
            NSString* phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneTextFieldText"];
            if (!phone) {
                phone = @"";
            }
            NSString* urlStr = [NSString stringWithFormat:@"%@game/gamepage/index.html?userCode=%@",APP_REQUEST_URL,phone];
            TYOpenWXVC *vc = [[TYOpenWXVC alloc] init];
            vc.titleText = @"天降红包";
            vc.url = urlStr;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if (indexPath.section == 5){
        if (indexPath.row == 0) {
            //系统反馈
            TYSystemFeedbackViewController *systemVc = [[TYSystemFeedbackViewController alloc] init];
            [self.navigationController pushViewController:systemVc animated:YES];
        }else if(indexPath.row == 1){
            //联系我们
            TYContactUsViewController *contactVc = [[TYContactUsViewController alloc] init];
            [self.navigationController pushViewController:contactVc animated:YES];
        }else if(indexPath.row == 2){
            
        }else if(indexPath.row == 3){
            
        }else if(indexPath.row == 4){
            
        }
    }
}

#pragma mark -- 网络请求
//60 经销中心 金额总接口
-(void)requestCusPriceList{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = @([TYLoginModel getPrimaryId]);//分销商ID
    
    NSString *url = [NSString stringWithFormat:@"%@mapi/mpsi/GetCusPriceList",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            [self.modelArray removeAllObjects];
            NSArray *arr = [TYCusPriceModel mj_objectArrayWithKeyValuesArray:[respondObject objectForKey:@"c"]];
            [self.modelArray addObjectsFromArray:arr];
            self.model = [self.modelArray firstObject];
            //传给下一界面赋值
            [TYSingleton shareSingleton].totalSales = self.model.m;
            [TYSingleton shareSingleton].totalAwaiting = self.model.f;
            [TYSingleton shareSingleton].totalDelivery = self.model.d;
            [TYSingleton shareSingleton].totalRetailValue = self.model.e;
            
            [TYLoginModel savePrepaidBalance:[NSString stringWithFormat:@"%lf",self.model.h]];
            [TYLoginModel savePrerechargeUseAmount:[NSString stringWithFormat:@"%lf",self.model.l]];
            
        }
        [self.MyCollectionView reloadData];
    } orFailBlock:^(id error) {
        
    }];
}

//63 经销中心 获取系统消息（信鸽）未读信息总数
-(void)requestMSysListCount{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = @([TYLoginModel getPrimaryId]);//分销商ID
    
    NSString *url = [NSString stringWithFormat:@"%@MAPI/MSys/ListCount",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            //c消息数量
            if ([[respondObject objectForKey:@"c"] integerValue] == 0) {
                self.msgLabel.hidden = YES;
            }else{
                self.msgLabel.hidden = NO;
                self.msgLabel.text = [NSString stringWithFormat:@"%ld",(long)[[respondObject objectForKey:@"c"] integerValue]];
            }
        }
        
    } orFailBlock:^(id error) {
    }];
}

//经销中心 差额汇总
-(void)requestGetDiffPrice{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = @([TYLoginModel getPrimaryId]);//分销商ID
    
    NSString *url = [NSString stringWithFormat:@"%@mapi/mpsi/GetDiffPrice",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            [self.oneArr removeAllObjects];
            NSArray *arr = [TYDiffPriceModel mj_objectArrayWithKeyValuesArray:[respondObject objectForKey:@"c"]];
            [self.oneArr addObjectsFromArray:arr];
        }
        [self.MyCollectionView reloadData];
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
        }
        
    } orFailBlock:^(id error) {
        [TYShowHud showHudErrorWithStatus:@"接口请求失败"];
    }];
    
}


#pragma mark -- 懒加载
- (UICollectionView *) MyCollectionView
{
    if (!_MyCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _MyCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, -20, KScreenWidth, KScreenHeight) collectionViewLayout:flowLayout];
        _MyCollectionView.delegate = self;
        _MyCollectionView.dataSource = self;
        _MyCollectionView.alwaysBounceVertical = YES;
        _MyCollectionView.showsVerticalScrollIndicator = NO;
        //注册cell
        [_MyCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([TYDistributionHeadCell class]) bundle:nil] forCellWithReuseIdentifier:TYDistributionHeadCellId];
        //注册cell
        [_MyCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([TYDistributionCenterCell class]) bundle:nil] forCellWithReuseIdentifier:TYDistributionCenterCellId];
        
        //注册头视图
        [_MyCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MyHeadViewId];
        
        _MyCollectionView.backgroundColor = RGB(238, 238, 238);
    }
    return _MyCollectionView;
}

- (NSMutableArray *) oneArr
{
    if (!_oneArr) {
        _oneArr = [NSMutableArray array];
    }
    return _oneArr;
}
@end


