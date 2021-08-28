//
//  TYAllProductsViewController.m
//  美界联盟
//
//  Created by LY on 2017/10/24.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYAllProductsViewController.h"
#import "TYHotProductCollectionViewCell.h"
#import "TYBannerModel.h"
#import "TYCategoryViewController.h"
#import "TYSMProdTypeModel.h"

@interface TYAllProductsViewController ()< UIScrollViewDelegate>

/** 存储主键id */
@property (nonatomic, strong) NSMutableArray *idArr;

@property (nonatomic, strong) NSMutableArray *dataArry;

@property (nonatomic, weak) UIView *titleView;
@property (nonatomic, weak) UIScrollView *titleScr;
@property (nonatomic, weak) UIScrollView *contentView;
@property (nonatomic, weak) UIView *indView;

@end

@implementation TYAllProductsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(238, 238, 238);
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"所有产品" andTitleColor:[UIColor whiteColor] andImage:nil];
    //先请求数据
    [self requestProdtype];
}

#pragma mark -- 网络请求
//请求产品分类
-(void)requestProdtype{
    [LoadManager showLoadingView:self.view];
    NSDictionary *params;NSString *url;
     if ([TYSingleton shareSingleton].consumer == 1) {
         params = @{
                    @"b":[NSNumber numberWithInteger:1]//目前传1
                    };
         url = [NSString stringWithFormat:@"%@MAPI/SM/SMProdType",APP_REQUEST_URL];
     }else{
         params = @{
                    @"a":[NSNumber numberWithInteger:0]//产品类型0表示所有产品
                    };
         url = [NSString stringWithFormat:@"%@mapi/mall/prodtype",APP_REQUEST_URL];
     }
    
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            NSArray *arr;
             if ([TYSingleton shareSingleton].consumer == 1) {
                 arr = [TYSMProdTypeModel mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"d"]];
                 [self.dataArry addObjectsFromArray:arr];
             }else{
                 arr = [TYBannerModel mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"e"]];
                 [self.dataArry addObjectsFromArray:arr];
             }
            if (arr.count == 0) {
                [LoadManager hiddenLoadView];
                return ;
            }
            
            [self setUpTitleView];
            for (NSInteger i = 0; i < arr.count; i++) {
                TYCategoryViewController *vc = [[TYCategoryViewController alloc] init];
                if ([TYSingleton shareSingleton].consumer == 1) {
                    vc.SModel = self.dataArry[i];
                }else{
                    vc.model = self.dataArry[i];
                }
                [self addChildViewController:vc];

                // 设置顶部的标签栏
                [self setupTitlesView:self.dataArry childIndex:i];
            }
            [self setupContentView];

        }
        [LoadManager hiddenLoadView];
    } orFailBlock:^(id error) {
        [LoadManager hiddenLoadView];
    }];
}

// 内容scrollview
- (void)setupContentView
{
    CGFloat linetopH = CGRectGetHeight(self.titleView.frame);
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.frame = CGRectMake(0, linetopH, KScreenWidth, KScreenHeight-linetopH-64);
    contentView.delegate = self;
    contentView.pagingEnabled = YES;
    contentView.showsHorizontalScrollIndicator = NO;
    [self.view insertSubview:contentView atIndex:0];
    contentView.contentSize = CGSizeMake(KScreenWidth * self.childViewControllers.count, 0);
    self.contentView = contentView;

    // 添加第一个控制器的view
    [self scrollViewDidEndScrollingAnimation:contentView];
}

- (void)setUpTitleView
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    [self.view addSubview:titleView];
    self.titleView = titleView;
    UIScrollView *titleScr = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    titleScr.backgroundColor = [UIColor whiteColor];
    [titleView addSubview:titleScr];
    UIView *indView = [[UIView alloc] initWithFrame:CGRectMake((KScreenWidth/4-52)/2, 38, 52, 2)];
    indView.backgroundColor = [UIColor blueColor];
    [titleView addSubview:indView];
    self.indView = indView;
    self.titleScr = titleScr;
}

// 添加第一个控制器的view
- (void)setupTitlesView:(NSMutableArray *)modelArry childIndex:(NSInteger)index
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = index;
    if ([TYSingleton shareSingleton].consumer == 1) {
        TYSMProdTypeModel *model = modelArry[index];
        [button setTitle:model.db forState:UIControlStateNormal];
    }else{
        TYBannerModel *model = modelArry[index];
        [button setTitle:model.eb forState:UIControlStateNormal];
    }
    
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(index * KScreenWidth/4, 0, KScreenWidth/4, 49);
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleScr addSubview:button];
}

// 按钮点击
- (void)buttonAction:(UIButton *)button{
    CGFloat buttonW = KScreenWidth/4;
    [UIView animateWithDuration:0.25 animations:^{
        [self.indView setCenterX:button.frame.origin.x + buttonW/2];
    }];
    CGPoint offset = self.contentView.contentOffset;
    offset.x = button.tag * KScreenWidth;
    [self.contentView setContentOffset:offset animated:YES];
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / KScreenWidth;
    UIViewController *vc = self.childViewControllers[index];
    vc.view.x = scrollView.contentOffset.x;
    vc.view.y = 0;
    vc.view.height = scrollView.frame.size.height;
    [scrollView addSubview:vc.view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];

    NSInteger index = scrollView.contentOffset.x / KScreenWidth;
    UIButton *chooseButton = [self.titleView viewWithTag:index];
    [self buttonAction:chooseButton];
}

#pragma mark -- 懒加载
- (NSMutableArray *) idArr
{
    if (!_idArr) {
        _idArr = [NSMutableArray array];
    }
    return _idArr;
}

- (NSMutableArray *)dataArry
{
    if (!_dataArry) {
        _dataArry = [NSMutableArray array];
    }
    return _dataArry;
}

@end
