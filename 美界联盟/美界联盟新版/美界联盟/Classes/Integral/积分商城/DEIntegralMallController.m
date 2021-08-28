//
//  DEIntegralMallController.m
//  美界联盟
//
//  Created by Glory_iMac on 2019/9/10.
//  Copyright © 2019 刘燚. All rights reserved.
//

#import "DEIntegralMallController.h"
#import "DECategoryController.h"

@interface DEIntegralMallController ()< UIScrollViewDelegate>

/** 存储主键id */
@property (nonatomic, strong) NSMutableArray *idArr;

@property (nonatomic, strong) NSMutableArray *dataArry;

@property (nonatomic, weak) UIView *titleView;
@property (nonatomic, weak) UIScrollView *titleScr;
@property (nonatomic, weak) UIScrollView *contentView;
@property (nonatomic, weak) UIView *indView;

/** 分页 */
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSDictionary *oneList;
@property (nonatomic, strong) NSDictionary *twoList;

@end

@implementation DEIntegralMallController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = RGB(238, 238, 238);
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"积分商城" andTitleColor:[UIColor whiteColor] andImage:nil];
    //先请求数据
    [self requestProdtype];
}

-(void)requestProdtype
{
    for (int i=0 ; i<2; i++) {
        DECategoryController *vc = [[DECategoryController alloc] init];
        [self addChildViewController:vc];
        if (i == 0) {
            vc.type = @"2";
        }else {
            vc.type = @"1";
        }
        // 设置顶部的标签栏
        [self setupTitlesViewChildIndex:i];
    }
     [self setupContentView];   
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

// 添加第一个控制器的view
- (void)setupTitlesViewChildIndex:(NSInteger)index
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = index;
    if (index == 0) {
        [button setTitle:@"金币" forState:UIControlStateNormal];
    }else {
        [button setTitle:@"银币" forState:UIControlStateNormal];
    }
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(index * KScreenWidth/2, 0, KScreenWidth/2, 49);
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleScr addSubview:button];
}

// 按钮点击
- (void)buttonAction:(UIButton *)button{
    CGFloat buttonW = KScreenWidth/2;
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

- (UIScrollView*)titleScr
{
    if (!_titleScr) {
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
        [self.view addSubview:titleView];
        self.titleView = titleView;
        UIScrollView *titleScr = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
        titleScr.backgroundColor = [UIColor whiteColor];
        [titleView addSubview:titleScr];
        UIView *indView = [[UIView alloc] initWithFrame:CGRectMake((KScreenWidth/2-52)/2, 38, 52, 2)];
        indView.backgroundColor = [UIColor blueColor];
        [titleView addSubview:indView];
        self.indView = indView;
        _titleScr = titleScr;
    }
    return _titleScr;
}

@end
