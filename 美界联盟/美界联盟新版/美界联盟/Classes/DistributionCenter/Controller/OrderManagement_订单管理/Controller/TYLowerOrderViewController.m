//
//  TYLowerOrderViewController.m
//  美界联盟
//
//  Created by LY on 2017/11/6.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYLowerOrderViewController.h"
#import "LowerOrderViewController.h"

@interface TYLowerOrderViewController ()<UIScrollViewDelegate, TYGlobalSearchViewDelegate>

@property (nonatomic, weak) UIView *titleView;
@property (nonatomic, weak) UIScrollView *titleScr;
@property (nonatomic, weak) UIScrollView *contentView;
//指示条
@property (nonatomic, weak) UIView *indView;
/** 指示按钮 */
@property (nonatomic, strong) UIButton *button;

@end

@implementation TYLowerOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"下级订单" andTitleColor:[UIColor whiteColor] andImage:nil];
    [self setNavigationRightBtnImage:@"search"];
     self.view.backgroundColor = RGB(238, 238, 238);
    self.modelArray = [NSMutableArray arrayWithObjects:@"未审核", @"已审核", @"全部",nil];
    
    [self setUpTitleView];
    for (NSInteger i = 0; i < self.modelArray.count; i++) {
        LowerOrderViewController *vc = [[LowerOrderViewController alloc] init];
        vc.type = i + 1;
        if (i == 2) {
            vc.type = -1;
        }
        [self addChildViewController:vc];
        
        // 设置顶部的标签栏
        [self setupTitlesView:self.modelArray childIndex:i];
    }
    [self setupContentView];
}

#pragma mark -- 搜索
- (void)navigationRightBtnClick:(UIButton *)btn{
    TYGlobalSearchView *SearchView = [TYGlobalSearchView CreatTYGlobalSearchView];
    SearchView.delegate = self;
    SearchView.frame = CGRectMake(0, 20, KScreenWidth, KScreenHeight);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:SearchView];
}

#pragma mark -- <TYGlobalSearchViewDelegate>
-(void)ClickSearch:(NSString *)KeyWord andStartTime:(NSString *)startTime andEndTime:(NSString *)endTime{
    //通知传值
    NSNotification *not = [[NSNotification alloc] initWithName:@"searchLowerOrderViewController" object:nil userInfo:@{@"keyWord":KeyWord,@"startTime":startTime,@"endTime":endTime}];
    [[NSNotificationCenter defaultCenter] postNotification:not];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"searchLowerOrderViewController" object:nil];
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
    indView.backgroundColor = RGB(20, 132, 240);
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
    [button setTitle:self.modelArray[index] forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    button.frame = CGRectMake(index * KScreenWidth/3, 0, KScreenWidth/3, 49);
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleScr addSubview:button];
    
    //给第一个View的头部添加未读消息数
    //    if (index == 0) {
    //        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(button.size.width/2 + button.titleLabel.size.width/2, 1, 20, 15)];
    //        messageLabel.backgroundColor = [UIColor redColor];
    //        messageLabel.font = [UIFont systemFontOfSize:10];
    //        messageLabel.textColor = [UIColor whiteColor];
    //        messageLabel.text = @"24";
    //        messageLabel.textAlignment = NSTextAlignmentCenter;
    //        messageLabel.layer.cornerRadius = 7;
    //        messageLabel.layer.masksToBounds = YES;
    //        [self.titleScr addSubview:messageLabel];
    //    }
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


@end
