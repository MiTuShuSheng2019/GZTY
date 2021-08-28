//
//  TYHistoryShareBonusViewController.m
//  美界联盟
//
//  Created by LY on 2017/11/1.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYHistoryShareBonusViewController.h"
#import "TYHistoryShareBonusSubViewController.h"

@interface TYHistoryShareBonusViewController ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIView *titleView;
@property (nonatomic, weak) UIScrollView *titleScr;
@property (nonatomic, weak) UIScrollView *contentView;
//指示条
@property (nonatomic, weak) UIView *indView;
/** 指示按钮 */
@property (nonatomic, strong) UIButton *button;
/** 当前年份的前三年数组 */
@property (nonatomic, strong) NSMutableArray *getDateLaterThreeYears;

@end

@implementation TYHistoryShareBonusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    if (self.type == 1) {
        [self setNavigationBarTitle:@"我的分红历史记录" andTitleColor:[UIColor whiteColor] andImage:nil];
    }else{
        [self setNavigationBarTitle:@"团队分红历史记录" andTitleColor:[UIColor whiteColor] andImage:nil];
    }
    
    self.view.backgroundColor = RGB(238, 238, 238);
    
    [self setUpTitleView];
    for (NSInteger i = 0; i < self.getDateLaterThreeYears.count; i++) {
        TYHistoryShareBonusSubViewController *vc = [[TYHistoryShareBonusSubViewController alloc] init];
        vc.year = self.getDateLaterThreeYears[i];
        vc.type = self.type;
        [self addChildViewController:vc];
        
        // 设置顶部的标签栏
        [self setupTitlesView:self.getDateLaterThreeYears childIndex:i];
    }
    [self setupContentView];
}


// 内容scrollview
- (void)setupContentView
{
    CGFloat linetopH = CGRectGetHeight(self.titleView.frame);
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.frame = CGRectMake(0, linetopH, KScreenWidth, KScreenHeight-linetopH - 64);
    contentView.showsHorizontalScrollIndicator = NO;
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
    UIView *indView = [[UIView alloc] initWithFrame:CGRectMake(0, 38, KScreenWidth/3, 2)];
    indView.backgroundColor = [UIColor blueColor];
    [titleView addSubview:indView];
    self.indView = indView;
    self.titleScr = titleScr;
}

// 添加第一个控制器的view
- (void)setupTitlesView:(NSMutableArray *)modelArry childIndex:(NSInteger)index
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button = button;
    button.tag = index;
    [button setTitle:self.getDateLaterThreeYears[index] forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
//    if (index == 0) {
//        button.selected = YES;
//    }
    
    button.frame = CGRectMake(index * KScreenWidth/3, 0, KScreenWidth/3, 49);
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleScr addSubview:button];
}

// 按钮点击
- (void)buttonAction:(UIButton *)button{
    CGFloat buttonW = KScreenWidth/3;
    [UIView animateWithDuration:0.25 animations:^{
        [self.indView setCenterX:button.frame.origin.x + buttonW/2];
    }];
    CGPoint offset = self.contentView.contentOffset;
    offset.x = button.tag * KScreenWidth;
    [self.contentView setContentOffset:offset animated:YES];
}

#pragma mark -- <UIScrollViewDelegate>
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / KScreenWidth;
    UIViewController *vc = self.childViewControllers[index];
    vc.view.x = scrollView.contentOffset.x;
    vc.view.y = 0;
    vc.view.height = scrollView.frame.size.height;
    [scrollView addSubview:vc.view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    NSInteger index = scrollView.contentOffset.x / KScreenWidth;
    UIButton *chooseButton = [self.titleView viewWithTag:index];
    [self buttonAction:chooseButton];
}

#pragma mark 当前年份的前三年
-(NSMutableArray *) getDateLaterThreeYears{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:100];
    NSInteger nowYear = [[self getDateYearNow] integerValue];
    for (NSInteger i = nowYear-1; i >= nowYear - 3; i--) {
        NSString *str = [NSString stringWithFormat:@"%lu",i];
        [array addObject:str];
    }
    return array;
}

#pragma mark 当前年份
-(NSString *) getDateYearNow{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy"];
    //用[NSDate date]可以获取系统当前时间年份
    return [dateFormatter stringFromDate:[NSDate date]];
}

@end
