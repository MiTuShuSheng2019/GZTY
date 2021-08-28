//
//  TYProductDetailsViewController.m
//  美界联盟
//
//  Created by LY on 2017/10/24.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYProductDetailsViewController.h"
#import "TYProductDetailsHeadView.h"
#import "TYProductDetailsCell.h"
#import "TYProductDetailsModel.h"
#import "TYDetailsModel.h"
#import "TYProductCell.h"
#import "TYAddCartView.h"
#import "TYLoginChooseViewController.h"

@interface TYProductDetailsViewController ()<UITableViewDelegate, UITableViewDataSource, TYAddCartViewDelagate>
{
    TYAddCartView *addView;
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
//分享按钮
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

/** 头部视图 */
@property (nonatomic, strong) TYProductDetailsHeadView *headView;
/** 轮播图片数组 */
@property (nonatomic, strong) NSMutableArray *photoArr;


@end

@implementation TYProductDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"产品详情" andTitleColor:[UIColor whiteColor] andImage:nil];
    
    [self setUpTableView];
    [self addTableViewHead];
    
    if ([TYSingleton shareSingleton].consumer == 1) {
        [self.shareBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    }else{
        [self.shareBtn setTitle:@"去分享" forState:UIControlStateNormal];
    }
    
    //网络请求
    [self requestProdlist];
}

#pragma mark -- 设置tableview的基本属性
-(void)setUpTableView{
    self.myTableView.tableFooterView = [UIView new];
    self.myTableView.showsVerticalScrollIndicator = NO;
    self.myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark -- 添加头部视图
-(void)addTableViewHead{
    TYProductDetailsHeadView *headView = [TYProductDetailsHeadView CreatTYProductDetailsHeadView];
    self.headView = headView;
    headView.model = self.model;
    headView.height = KScreenWidth * 9 / 16 + 60;
    self.myTableView.tableHeaderView = headView;
}

#pragma mark --- <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        TYProductCell *cell = [TYProductCell CellTableView:self.myTableView];
        if ([TYSingleton shareSingleton].consumer == 1) {
            if ([TYConsumerLoginModel getPrimaryId] > 0) {//消费者登录页
                cell.consumerModel = [[TYConsumerLoginModel alloc] init];
            }
        }else{
            if ([TYLoginModel getPrimaryId] > 0) {
                cell.model = [[TYLoginModel alloc] init];
            }
        }
        return cell;
        
    }else{
        TYProductDetailsCell *cell = [TYProductDetailsCell CellTableView:self.myTableView];
        cell.model = self.modelArray[indexPath.row - 1];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if ([TYLoginModel getPrimaryId] > 0 || [TYConsumerLoginModel getPrimaryId] > 0) {
            return 90;
        }else{
            return 0;
        }
    }else{
        TYDetailsModel *model = self.modelArray[indexPath.row - 1];
        return model.cellH;
    }
}

#pragma mark -- 点击去分享或加入购物车
- (IBAction)ClickButton {
    
    if ([TYSingleton shareSingleton].consumer == 1) {
        addView = [TYAddCartView CreatTYAddCartView];
        addView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        addView.delegate = self;
        addView.model = self.model;
        addView.shopNumberBtn.decreaseTitle = @"-";
        addView.shopNumberBtn.increaseTitle = @"+";
        // 设置最小值
        addView.shopNumberBtn.minValue = 1;
        // 设置最大值
        addView.shopNumberBtn.maxValue = 999;
        addView.shopNumberBtn.editing = NO;
        addView.shopNumberBtn.buttonTitleFont = 18;
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:addView];
        
    }else{
        //分销商登录
        if ([TYLoginModel getPrimaryId] > 0) {
            TYShareView *shareV = [TYShareView CreatTYShareView];
            shareV.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
            //表示已经登录
            shareV.distributionID = [TYLoginModel getPrimaryId];
            shareV.prodcutID = self.model.ea;
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [window addSubview:shareV];
        }else{
            //未登录提示先去登录
            [TYAlertAction showTYAlertActionTitle:nil andMessage:@"未登录不能分享请先登录" andVc:[[TYLoginChooseViewController alloc] init] andClick:^(NSInteger buttonIndex) {
                
            }];
        }
    }
}

#pragma mark -- <TYAddCartViewDelagate>--点击确定
-(void)addCar{
    
    
    self.model.shopNumber = addView.shopNumberBtn.currentNumber;
    
    NSMutableArray *arr = [NSMutableArray array];
    
    [arr addObjectsFromArray:[TYSingleton shareSingleton].shopArr];
    [arr addObject:self.model];
//    [TYSingleton shareSingleton].shopArr = arr;
    
    //去重数组中的模型
    NSMutableArray *listAry = [[NSMutableArray alloc] init];
    for (NSString *str in arr) {
        if (![listAry containsObject:str]) {
            [listAry addObject:str];
        }
    }
    [TYSingleton shareSingleton].shopArr = listAry;
    
    // 去除数组中model重复
//    for (NSInteger i = 0; i < [TYSingleton shareSingleton].shopArr.count; i++) {
//        
//        for (NSInteger j = i + 1;j < [TYSingleton shareSingleton].shopArr.count; j++) {
//            TYHotProductModel *tempModel = [TYSingleton shareSingleton].shopArr[i];
//            
//            TYHotProductModel *model = [TYSingleton shareSingleton].shopArr[j];
//            
//            if ([[NSString stringWithFormat:@"%ld",tempModel.ea] isEqualToString:[NSString stringWithFormat:@"%ld",model.ea]]) {
//                tempModel.shopNumber = tempModel.shopNumber + model.shopNumber;
//                [[TYSingleton shareSingleton].shopArr removeObjectAtIndex:j];
//            }else{
//                
//            }
//        }
//   }
    
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
    [SVProgressHUD showSuccessWithStatus:@"添加成功"];
    [SVProgressHUD dismissWithDelay:2.0];
    [addView removeFromSuperview];
}

#pragma mark -- 网络请求
// 4、产品详情
-(void)requestProdlist{
    [LoadManager showLoadingView:self.view];
    NSDictionary *params;NSString *url;
    if ([TYSingleton shareSingleton].consumer == 1) {
        params = @{
                   @"b":[NSNumber numberWithInteger:self.model.ea], //产品id
                   };
        url = [NSString stringWithFormat:@"%@MAPI/SM/SMProdDetail",APP_REQUEST_URL];
        
    }else{
        params = @{
                   @"a":[NSNumber numberWithInteger:self.model.ea], //产品id
                   };
        url = [NSString stringWithFormat:@"%@mapi/mall/proddetail",APP_REQUEST_URL];
    }
    
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            //解析详情列表
            NSArray *detailsArr = [TYDetailsModel mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"e"]];
            
            [self.modelArray addObjectsFromArray:detailsArr];
            
            //解析轮播图
            NSArray *arr = [TYProductDetailsModel mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"d"]];
            for (TYProductDetailsModel *model in arr) {
                
                [self.photoArr addObject:[NSString stringWithFormat:@"%@%@%@",PhotoUrl,model.da,kAliPicStr_300_300]];
            }
            
            //添加轮播图
            SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.headView.PhotoView.frame.size.width, self.headView.PhotoView.frame.size.height) delegate:nil placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
            cycleScrollView.imageURLStringsGroup = self.photoArr;
            cycleScrollView.currentPageDotColor = [UIColor blueColor];
            cycleScrollView.pageDotColor = [UIColor blackColor];
            cycleScrollView.backgroundColor = RGB(183, 183, 183);
            [self.headView.PhotoView addSubview:cycleScrollView];
            
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
        [LoadManager hiddenLoadView];
        [self.myTableView reloadData];
    } orFailBlock:^(id error) {
        [LoadManager hiddenLoadView];
    }];
}

#pragma mark -- 懒加载
- (NSMutableArray *) photoArr
{
    if (!_photoArr) {
        _photoArr = [NSMutableArray array];
    }
    return _photoArr;
}

@end
