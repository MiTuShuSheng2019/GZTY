//
//  TYShopMallOneCell.m
//  美界联盟
//
//  Created by LY on 2017/10/24.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYShopMallOneCell.h"
#import "TYShopCollectionCell.h"
#import "TYProductDetailsViewController.h"

@interface TYShopMallOneCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *backCollectionView;


@end

@implementation TYShopMallOneCell

static NSString *const MyFootViewId = @"MyFootView";

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYShopMallOneCell";
    TYShopMallOneCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //设置滚动方向
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //设置列与列之间的距离
//    flowLayout.minimumLineSpacing = 10;
    _myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(self.backCollectionView.frame.origin.x, 10, KScreenWidth, self.backCollectionView.frame.size.height - 10) collectionViewLayout:flowLayout];
    
    //设置代理
    _myCollectionView.delegate = self;
    _myCollectionView.dataSource = self;
    _myCollectionView.backgroundColor = [UIColor whiteColor];
    _myCollectionView.alwaysBounceHorizontal = YES;
    _myCollectionView.showsHorizontalScrollIndicator = NO;
    
    [self.myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([TYShopCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:@"TYShopCollectionCell"];
    //注册尾视图
//    [_myCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:MyFootViewId];
    
    [self.backCollectionView addSubview:_myCollectionView];
//    [self requestProdlist];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setDataArr:(NSMutableArray *)dataArr{
    _dataArr = dataArr;
    [self.myCollectionView reloadData];
}

#pragma mark -- <UICollectionViewDelegate, UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TYShopCollectionCell *cell = [self.myCollectionView dequeueReusableCellWithReuseIdentifier:@"TYShopCollectionCell" forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((KScreenWidth - 40)/3, (KScreenWidth - 40)/3 + 25 + 10);
}

//绘制头视图或尾视图 头视图或尾视图上可以添加任意控件
//-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//
//    UICollectionReusableView *crv = nil;
//    if (kind == UICollectionElementKindSectionFooter) {
//        UICollectionReusableView *footView  = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:MyFootViewId forIndexPath:indexPath];
//
//        crv = footView;
//    }
//    //头视图或尾视图 遵循复用机制
////    UICollectionReusableView *crv = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:MyHeadViewId forIndexPath:indexPath];
//
//    UIView *backView = [[UIView alloc] init];
//    backView.frame = CGRectMake(0, 0, 50, (KScreenWidth - 40)/3 + 25);
//    backView.backgroundColor = [UIColor redColor];
//
//    [crv addSubview:backView];
//    return crv;
//
//}

//设置头视图的大小
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//    return CGSizeMake(50, (KScreenWidth - 40)/3 + 25);
//}

//点击UICollectionView
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    TYProductDetailsViewController *detailsVc = [[TYProductDetailsViewController alloc] init];
    TYHotProductModel *model = self.dataArr[indexPath.row];
    
    UITabBarController *tabVc = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nagVC = [tabVc selectedViewController];
    
    detailsVc.model = model;
    
    [nagVC pushViewController:detailsVc animated:YES];
}

#pragma mark -- 网络请求
////产品列表
//-(void)requestProdlist{
//  
//    NSString *url;NSDictionary *params;
//    if ([TYSingleton shareSingleton].consumer == 1) {
//        params = @{
//                   @"c":[NSNumber numberWithInteger:1], //产品类型：1 最新2 热门
//                   @"e":[NSNumber numberWithInteger:1], //分页
//                   @"f":[NSNumber numberWithInteger:10], //分页size
//                   @"g":@"1"//PID
//                   };
//        url = [NSString stringWithFormat:@"%@MAPI/SM/SMProdList",APP_REQUEST_URL];
//    }else{
//        params = @{
//                   @"a":[NSNumber numberWithInteger:1], //分页
//                   @"b":[NSNumber numberWithInteger:10], //每页大小
//                   @"c":@"0", //产品分类
//                   @"d":[NSNumber numberWithInteger:1],//产品类型：1 最新2 热门
//                   @"e":@"0", //PID
//                   @"f":@"0" //结束时间
//                   };
//        url = [NSString stringWithFormat:@"%@mapi/mall/prodlist",APP_REQUEST_URL];
//        
//    }
//    
//    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
//        
//    } withSuccessBlock:^(id respondObject) {
//        
//        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
//            [self.dataArr removeAllObjects];
//            NSArray *arr = [TYHotProductModel mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"e"]];
//            [self.dataArr addObjectsFromArray:arr];
//            
//        }else{
//            [SVProgressHUD showSuccessWithStatus:[respondObject objectForKey:@"b"]];
//        }
//        
//        [self.myCollectionView reloadData];
//    } orFailBlock:^(id error) {
//    }];
//}
//#pragma mark -- 懒加载
//- (NSMutableArray *) dataArr
//{
//    if (!_dataArr) {
//        _dataArr = [NSMutableArray array];
//    }
//    return _dataArr;
//}

@end
