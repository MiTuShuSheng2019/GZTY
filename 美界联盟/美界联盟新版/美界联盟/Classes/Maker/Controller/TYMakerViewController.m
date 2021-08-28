//
//  TYMakerViewController.m
//  美界联盟
//
//  Created by LY on 2017/10/23.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYMakerViewController.h"
#import "TYMakerTitleView.h"
#import "TYMakerCell.h"
#import "TYCircleFriendVC.h"
#import "TYMakerDealerCell.h"
#import "TYSchoolViewController.h"
#import "TYGetDisStyleModel.h"
#import "TYLoginChooseViewController.h"

@interface TYMakerViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, SDPhotoBrowserDelegate>

@property (nonatomic, strong) UICollectionView *MyCollectionView;
/** 头部标题数组 */
@property (nonatomic, strong) NSArray *headTitleArr;
/** cell的标题数组1 */
@property (nonatomic, strong) NSArray *cellTitleArr1;
/** cell的内容数组1 */
@property (nonatomic, strong) NSArray *cellContentArr1;
/** cell的图片数组1 */
@property (nonatomic, strong) NSArray *cellImageArr1;

/** cell的标题数组2 */
@property (nonatomic, strong) NSArray *cellTitleArr2;
/** cell的内容数组2 */
@property (nonatomic, strong) NSArray *cellContentArr2;
/** cell的图片数组2 */
@property (nonatomic, strong) NSArray *cellImageArr2;

@end

@implementation TYMakerViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.MyCollectionView reloadData];
    //在没有数据的时候去请求 请求一次就可以了
    if (self.modelArray.count == 0) {
        [self requestGetDisStyle];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self IsNeedLogin];
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


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"创客" andTitleColor:[UIColor whiteColor] andImage:nil];
    
    [self.view addSubview:self.MyCollectionView];
    self.headTitleArr = [NSArray arrayWithObjects:@"推广", @"学堂", @"经销商风采", nil];
//    self.cellTitleArr1 = [NSArray arrayWithObjects:@"朋友圈推广", @"口碑推广", @"视频推广", @"文章推广", @"线下推广", @"", nil];
    self.cellTitleArr1 = [NSArray arrayWithObjects:@"朋友圈推广", @"视频推广",nil];
//    self.cellContentArr1 = [NSArray arrayWithObjects:@"在朋友圈宣传", @"分享产品使用情况", @"公司产品介绍", @"分享产品的介绍", @"线下海报打印专用", @"", nil];
    self.cellContentArr1 = [NSArray arrayWithObjects:@"在朋友圈宣传", @"公司产品介绍",nil];
//    self.cellImageArr1 = [NSArray arrayWithObjects:@"circle_promotion", @"mouth_promotion", @"video_promotion", @"articles_promotion", @"offline_promotion", @"", nil];
     self.cellImageArr1 = [NSArray arrayWithObjects:@"circle_promotion", @"video_promotion",nil];
    
//    self.cellTitleArr2 = [NSArray arrayWithObjects:@"新手教程", @"高手进阶", @"经销制度", @"常见问题", nil];
    self.cellTitleArr2 = [NSArray arrayWithObjects:@"新手教程", @"经销制度", @"常见问题", nil];
//    self.cellContentArr2 = [NSArray arrayWithObjects:@"基础入门功能讲解", @"营销推广扩展市场", @"公司制度经销准则", @"常见问题疑难解答",nil];
    self.cellContentArr2 = [NSArray arrayWithObjects:@"基础入门功能讲解", @"公司制度经销准则", @"常见问题疑难解答",nil];
//    self.cellImageArr2 = [NSArray arrayWithObjects:@"novice_ tutorial", @"master_advanced", @"distribution_system", @"common_ question",nil];
     self.cellImageArr2 = [NSArray arrayWithObjects:@"novice_ tutorial", @"distribution_system", @"common_ question",nil];
}

#pragma mark ---<UICollectionViewDelegate,UICollectionViewDataSource>
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return self.cellTitleArr1.count;
    }else if (section == 1){
        return self.cellTitleArr2.count;
    }else{
        return self.modelArray.count;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //加载cell
    TYMakerCell *cell = [self.MyCollectionView dequeueReusableCellWithReuseIdentifier:@"TYMakerCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.cellTitleLabel.text = self.cellTitleArr1[indexPath.row];
        cell.contentLabel.text = self.cellContentArr1[indexPath.row];
        cell.icon.image = [UIImage imageNamed:self.cellImageArr1[indexPath.row]];
        return cell;
    }else if (indexPath.section == 1){
        cell.cellTitleLabel.text = self.cellTitleArr2[indexPath.row];
        cell.contentLabel.text = self.cellContentArr2[indexPath.row];
        cell.icon.image = [UIImage imageNamed:self.cellImageArr2[indexPath.row]];
        return cell;
    }else{
        TYMakerDealerCell *cell = [self.MyCollectionView dequeueReusableCellWithReuseIdentifier:@"TYMakerDealerCell" forIndexPath:indexPath];
        cell.model = self.modelArray[indexPath.row];
        return cell;
    }
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.headTitleArr.count;
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
    if (indexPath.section == 2) {
        TYGetDisStyleModel *model = self.modelArray[indexPath.row];
        return CGSizeMake(KScreenWidth, model.cellH);
    }else{
        return CGSizeMake((KScreenWidth - 1)/2, 90);
    }
}

//绘制头视图或尾视图 头视图或尾视图上可以添加任意控件
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    //头视图或尾视图 遵循复用机制
    UICollectionReusableView *crv = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TYMakerTitleView" forIndexPath:indexPath];
    TYMakerTitleView *headView = [TYMakerTitleView CreatTYMakerTitleView];
    headView.frame = CGRectMake(0, 0, KScreenWidth, 50);
    headView.titleLab.text = self.headTitleArr[indexPath.section];
    [crv addSubview:headView];
    return crv;
}

//设置头视图的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 2 && self.modelArray.count == 0) {
        return CGSizeMake(0, 0);
    }else{
        return CGSizeMake(KScreenWidth, 50);
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //朋友圈推广
            TYCircleFriendVC *friendVc = [[TYCircleFriendVC alloc] init];
            [self.navigationController pushViewController:friendVc animated:YES];
        }else if (indexPath.row == 1){
            //口碑推广
//            TYSchoolViewController *schoolVc = [[TYSchoolViewController alloc] init];
//            schoolVc.categoryID = 4;
//            schoolVc.title = @"口碑推广";
//            [self.navigationController pushViewController:schoolVc animated:YES];
            
            TYSchoolViewController *schoolVc = [[TYSchoolViewController alloc] init];
            schoolVc.categoryID = 5;
            schoolVc.title = @"视频推广";
            [self.navigationController pushViewController:schoolVc animated:YES];
            
        }else if (indexPath.row == 2){
            //视频推广
//            TYSchoolViewController *schoolVc = [[TYSchoolViewController alloc] init];
//            schoolVc.categoryID = 5;
//            schoolVc.title = @"视频推广";
//            [self.navigationController pushViewController:schoolVc animated:YES];
            
        }else if (indexPath.row == 3){
            //文章推广
//            TYSchoolViewController *schoolVc = [[TYSchoolViewController alloc] init];
//            schoolVc.categoryID = 6;
//            schoolVc.title = @"文章推广";
//            [self.navigationController pushViewController:schoolVc animated:YES];
            
        }else if (indexPath.row == 4){
            //线下推广
//            TYSchoolViewController *schoolVc = [[TYSchoolViewController alloc] init];
//            schoolVc.categoryID = 7;
//            schoolVc.title = @"线下推广";
//            [self.navigationController pushViewController:schoolVc animated:YES];
        }
        
    }else if (indexPath.section == 1){
        TYSchoolViewController *schoolVc = [[TYSchoolViewController alloc] init];
        if (indexPath.row == 0) {
            //新手教程
            schoolVc.categoryID = 8;
            schoolVc.title = @"新手教程";
        }else if (indexPath.row == 1){
//            //高手进阶
//            schoolVc.categoryID = 9;
//            schoolVc.title = @"高手进阶";
            //经销制度
            schoolVc.categoryID = 10;
            schoolVc.title = @"经销制度";
        }else if (indexPath.row == 2){
//            //经销制度
//            schoolVc.categoryID = 10;
//            schoolVc.title = @"经销制度";
            //常见问题
            schoolVc.categoryID = 11;
            schoolVc.title = @"常见问题";
        }else if (indexPath.row == 3){
//            //常见问题
//            schoolVc.categoryID = 11;
//            schoolVc.title = @"常见问题";
        }
        [self.navigationController pushViewController:schoolVc animated:YES];
    }else{
        SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
        photoBrowser.delegate = self;
        photoBrowser.currentImageIndex = 0;
        photoBrowser.imageCount = 1;
        TYMakerDealerCell *cell = (TYMakerDealerCell *)[self.MyCollectionView cellForItemAtIndexPath:indexPath];
        photoBrowser.sourceImagesContainerView = cell.contentView;
        [photoBrowser show];
    }
}

#pragma mark - SDPhotoBrowserDelegate
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:2];
    
    TYMakerDealerCell *cell = (TYMakerDealerCell *)[self.MyCollectionView cellForItemAtIndexPath:indexPath];
    return cell.iconImageView.image;
}


#pragma mark 懒加载
- (UICollectionView *) MyCollectionView
{
    if (!_MyCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat tabH;
        if ([TYDevice systemVersion] < 11.0) {
            tabH = KScreenHeight - 104;
        }else{
            tabH = KScreenHeight - 64;
        }
        _MyCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, tabH) collectionViewLayout:flowLayout];
        _MyCollectionView.delegate = self;
        _MyCollectionView.dataSource = self;
        _MyCollectionView.alwaysBounceVertical = YES;
        _MyCollectionView.showsVerticalScrollIndicator = NO;
        _MyCollectionView.backgroundColor = RGB(238, 238, 238);
        //注册cell
        [_MyCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([TYMakerCell class]) bundle:nil] forCellWithReuseIdentifier:@"TYMakerCell"];
        [_MyCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([TYMakerDealerCell class]) bundle:nil] forCellWithReuseIdentifier:@"TYMakerDealerCell"];
        
        //注册头视图
        [_MyCollectionView registerClass:[TYMakerTitleView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TYMakerTitleView"];
    }
    return _MyCollectionView;
}

#pragma mark -- 网络请求
//110 创客 获取经销商风采
-(void)requestGetDisStyle{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"c"] = @(1);//分页index
    params[@"d"] = @(10);//分页size
    //此时取10条即可，可根据后期需求在更改
    NSString *url = [NSString stringWithFormat:@"%@MAPI/mcus/GetDisStyle",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            NSArray *arr = [TYGetDisStyleModel mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"d"]];
            [self.modelArray addObjectsFromArray:arr];
        }
        [self.MyCollectionView reloadData];
        
    } orFailBlock:^(id error) {
    }];
}

@end
