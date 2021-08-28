//
//  TYCategoryViewController.m
//  美界联盟
//
//  Created by LY on 2017/10/24.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYCategoryViewController.h"
#import "TYHotProductCollectionViewCell.h"
#import "TYBannerModel.h"
#import "TYProductDetailsViewController.h"
#import "TYSMProdTypeModel.h"

@interface TYCategoryViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, TYHotProductCollectionViewCellDelegate>

//@property (weak, nonatomic) IBOutlet UICollectionView *MyCollectionView;
/** <#注释#> */
@property (nonatomic, strong) UICollectionView *MyCollectionView;
/** 类型 */
@property (nonatomic, assign) NSInteger type;
/** 分页 */
@property (nonatomic, assign) NSInteger page;
/** 每页数量 */
@property (nonatomic, assign) NSInteger limit;

@end

@implementation TYCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.width = KScreenWidth;
    if ([TYSingleton shareSingleton].consumer == 1) {
        self.type = self.SModel.da;
    }else{
        self.type = self.model.ea;
    }
    
    [self setUpMyCollectionView];
}

-(void)setUpMyCollectionView{
    
    self.limit = 10;
    __weak typeof(&*self)weakSelf = self;
    self.MyCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf.modelArray removeAllObjects];
        [weakSelf requestProdlist];
    }];
    
    self.MyCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestProdlist];
    }];
    
    self.MyCollectionView.mj_footer.hidden = YES;
    [self.MyCollectionView.mj_header beginRefreshing];
    [self.view addSubview:self.MyCollectionView];
}

#pragma mark -- <UICollectionViewDelegate, UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.modelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TYHotProductCollectionViewCell *cell = [self.MyCollectionView dequeueReusableCellWithReuseIdentifier:@"TYHotProductCollectionViewCell" forIndexPath:indexPath];
    cell.model = self.modelArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 15, 0);
}

//定义每个UICollectionView ,横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 15;
}

//纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((KScreenWidth-15)/2, (KScreenWidth-15)/2 * 9/8 + 50);
}

//点击UICollectionView
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    TYHotProductModel *model = self.modelArray[indexPath.row];
    TYProductDetailsViewController *detailsVc = [[TYProductDetailsViewController alloc] init];
    detailsVc.model = model;
    [self.navigationController pushViewController:detailsVc animated:YES];
}


#pragma mark ---<TYHotProductCollectionViewCellDelegate>-- 点击分享
-(void)share:(UIButton *)btn{
    
    TYHotProductCollectionViewCell *cell =(TYHotProductCollectionViewCell *) [[[btn superview] superview] superview];
    NSIndexPath *path = [self.MyCollectionView indexPathForCell:cell];
   
    TYHotProductModel *model = self.modelArray[path.row];
    TYShareView *shareV = [TYShareView CreatTYShareView];
    shareV.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    if ([TYLoginModel getPrimaryId] > 0) {
        //表示已经登录
        shareV.distributionID = [TYLoginModel getPrimaryId];
    }else{
        shareV.distributionID = 0;
    }
    shareV.prodcutID = model.ea;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:shareV];
}

#pragma mark -- 网络请求
//产品列表
-(void)requestProdlist{
    NSDictionary *params;NSString *url;
    if ([TYSingleton shareSingleton].consumer == 1) {
        params = @{
                   @"b":@(self.type), //产品类别ID
                   @"e":@(self.page), //分页
                   @"f":@(self.limit), //分页size
                   @"g":@"1"//PID
                   };
        url = [NSString stringWithFormat:@"%@MAPI/SM/SMProdList",APP_REQUEST_URL];
    }else{
        params = @{
                   @"a":[NSNumber numberWithInteger:self.page], //分页
                   @"b":[NSNumber numberWithInteger:self.limit], //每页大小
                   @"c":[NSNumber numberWithInteger:self.type], //产品分类
                   @"d":@"0",//0全部：1 热门 2 最新
                   @"e":@"0", //PID
                   @"f":@"0" //结束时间
                   };
        
        url = [NSString stringWithFormat:@"%@mapi/mall/prodlist",APP_REQUEST_URL];
    }
   
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
         if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            NSArray *arr = [TYHotProductModel mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"e"]];
            [self.modelArray addObjectsFromArray:arr];
            self.page = self.page + 1;
            if (arr.count < self.limit) {
                self.MyCollectionView.mj_footer.hidden = YES;
            }else{
                self.MyCollectionView.mj_footer.hidden = NO;
            }
        }else{
            
        }
        [self.MyCollectionView.mj_header endRefreshing];
        [self.MyCollectionView.mj_footer endRefreshing];
        [self.MyCollectionView reloadData];
        
    } orFailBlock:^(id error) {
        [self.MyCollectionView.mj_header endRefreshing];
        [self.MyCollectionView.mj_footer endRefreshing];
    }];
}

#pragma mark -- 懒加载
- (UICollectionView *) MyCollectionView
{
    if (!_MyCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat tabH;
        if (KIsiPhoneX == YES) {
            tabH = KScreenHeight - 88 - 40;
        }else{
            tabH = KScreenHeight - 64 - 40;
        }
        _MyCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, tabH) collectionViewLayout:flowLayout];
        _MyCollectionView.delegate = self;
        _MyCollectionView.dataSource = self;
        _MyCollectionView.alwaysBounceVertical = YES;
        _MyCollectionView.showsVerticalScrollIndicator = NO;
        //注册
        [self.MyCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([TYHotProductCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"TYHotProductCollectionViewCell"];
        _MyCollectionView.backgroundColor = RGB(238, 238, 238);
    }
    return _MyCollectionView;
}


@end
