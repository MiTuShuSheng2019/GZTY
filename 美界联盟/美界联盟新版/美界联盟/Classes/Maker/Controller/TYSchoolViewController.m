//
//  TYSchoolViewController.m
//  美界联盟
//
//  Created by LY on 2017/11/18.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYSchoolViewController.h"
#import "SchoolViewController.h"
#import "TYCategoryModel.h"

@interface TYSchoolViewController ()<UIScrollViewDelegate>
/** 存储主键id */
@property (nonatomic, strong) NSMutableArray *idArr;
@property (nonatomic, strong) NSMutableArray *dataArry;

@property (nonatomic, weak) UIView *titleView;
@property (nonatomic, weak) UIScrollView *titleScr;
@property (nonatomic, weak) UIScrollView *contentView;
//指示条目
@property (nonatomic, weak) UIView *indView;
/** 标题按钮 */
@property (nonatomic, strong) UIButton *button;

@end

@implementation TYSchoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
//    NSString *title;
//    if (self.categoryID == 4) {
//        title = @"口碑推广";
//    }else if (self.categoryID == 5){
//        title = @"视频推广";
//    }else if (self.categoryID == 6){
//        title = @"文章推广";
//    }else if (self.categoryID == 7){
//        title = @"线下推广";
//    }else if (self.categoryID == 8){
//        title = @"新手教程";
//    }else if (self.categoryID == 9){
//        title = @"高手进阶";
//    }else if (self.categoryID == 10){
//        title = @"经销制度";
//    }else if (self.categoryID == 11){
//        title = @"常见问题";
//    }
    [self setNavigationBarTitle:self.title andTitleColor:[UIColor whiteColor] andImage:nil];
    self.view.backgroundColor = RGB(238, 238, 238);
    
    //先请求数据
    [self requestProdtype];
}

// 内容scrollview
- (void)setupContentView
{
    CGFloat linetopH = CGRectGetHeight(self.titleView.frame);
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.frame = CGRectMake(0, linetopH, KScreenWidth, KScreenHeight-linetopH - 64);
    contentView.delegate = self;
    contentView.pagingEnabled = YES;
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
    self.button = button;
    TYCategoryModel *model = modelArry[index];
    [button setTitle:model.db forState:UIControlStateNormal];
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

#pragma mark  -- <UIScrollViewDelegate>
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

#pragma mark -- 网络请求
//112 创客 获取三级类别
-(void)requestProdtype{
    [LoadManager showLoadingView:self.view];
    NSDictionary *params = @{
                             @"a":[TYLoginModel getSessionID],//sessionID
                             @"b":@(self.categoryID)//二级类别ID
                             };
    NSString *url = [NSString stringWithFormat:@"%@MAPI/mcus/GetDetailType",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            NSArray *arr = [TYCategoryModel mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"d"]];
            [self.dataArry addObjectsFromArray:arr];
            [self setUpTitleView];
            for (NSInteger i = 0; i < arr.count; i++) {
                SchoolViewController *vc = [[SchoolViewController alloc] init];
                vc.model = self.dataArry[i];
                vc.categoryID = self.categoryID;
                [self addChildViewController:vc];
                
                // 设置顶部的标签栏
                [self setupTitlesView:self.dataArry childIndex:i];
            }
            [self setupContentView];
            
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
        [LoadManager hiddenLoadView];
    } orFailBlock:^(id error) {
        [LoadManager hiddenLoadView];
    }];
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
