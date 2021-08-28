//
//  DECategoryController.m
//  美界联盟
//
//  Created by Glory_iMac on 2019/9/12.
//  Copyright © 2019 刘燚. All rights reserved.
//

#import "DECategoryController.h"
#import "DEIntegralMallModel.h"
#import "DEHotProductCollectionViewCell.h"
#import "DEProductDetailsViewController.h"

@interface DECategoryController ()<UICollectionViewDelegate, UICollectionViewDataSource,DEHotProductCollectionViewCellDelegate>

@property (nonatomic, strong) UICollectionView *MyCollectionView;

/** 分页 */
@property (nonatomic, assign) NSInteger page;
/** 每页数量 */
@property (nonatomic, assign) NSInteger limit;

@end

@implementation DECategoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.width = KScreenWidth;
    
    [self setUpMyCollectionView];
}

-(void)setUpMyCollectionView{
    
    self.limit = 10;
    self.page = 1;
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
    DEHotProductCollectionViewCell *cell = [self.MyCollectionView dequeueReusableCellWithReuseIdentifier:@"DEHotProductCollectionViewCell" forIndexPath:indexPath];
    cell.model = self.modelArray[indexPath.row];
    cell.type = self.type;
    cell.delegate = self;
    return cell;
}

-(void)shopping:(UIButton *)btn
{
    DEHotProductCollectionViewCell *cell =(DEHotProductCollectionViewCell *) [[[btn superview] superview] superview];
    NSIndexPath *path = [self.MyCollectionView indexPathForCell:cell];
    
    DEIntegralMallModel *model = self.modelArray[path.row];
    TYShareView *shareV = [TYShareView CreatTYShareView];
    shareV.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    if ([TYLoginModel getPrimaryId] > 0) {
        //表示已经登录
        shareV.distributionID = [TYLoginModel getPrimaryId];
    }else{
        shareV.distributionID = 0;
    }
    shareV.prodcutID = [model.goodsCode integerValue];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:shareV];
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
    DEIntegralMallModel *model = self.modelArray[indexPath.row];
    DEProductDetailsViewController *detailsVc = [[DEProductDetailsViewController alloc] init];
    detailsVc.type = self.type;
    detailsVc.IModel = model;
    [self.navigationController pushViewController:detailsVc animated:YES];
}

#pragma mark -- 网络请求
//产品列表
-(void)requestProdlist{
    NSDictionary* p =[NSDictionary dictionary];
    
    p = @{@"page":@(self.page),
          @"type":self.type,
          @"text":@"",
          };
    NSString* url =[NSString stringWithFormat:@"%@mapi/Intergral/GetGoodsIntergralList",APP_REQUEST_URL];
    
    [TYNetworking postRequestURL:url parameters:p andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            NSArray *arr = [NSArray arrayWithArray:respondObject[@"c"][@"List"]];
            for (NSDictionary* dict in arr) {
                DEIntegralMallModel* model = [[DEIntegralMallModel alloc]initWithDict:dict];
                [self.modelArray addObject:model];
            }
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
        [self.MyCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DEHotProductCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"DEHotProductCollectionViewCell"];
        _MyCollectionView.backgroundColor = RGB(238, 238, 238);
    }
    return _MyCollectionView;
}

@end
