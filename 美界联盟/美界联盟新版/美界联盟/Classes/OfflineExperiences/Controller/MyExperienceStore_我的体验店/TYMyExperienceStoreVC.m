//
//  TYMyExperienceStoreVC.m
//  美界联盟
//
//  Created by LY on 2017/11/24.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYMyExperienceStoreVC.h"
#import "MyExperienceStoreVC.h"
#import "TYExpCenterDetailModel.h"

@interface TYMyExperienceStoreVC ()<UIScrollViewDelegate>
/** 标题数组 */
@property (nonatomic, strong) NSMutableArray *titleArr;
@property (nonatomic, weak) UIView *titleView;
@property (nonatomic, weak) UIScrollView *titleScr;
@property (nonatomic, weak) UIScrollView *contentView;
//指示条目
@property (nonatomic, weak) UIView *indView;

//封面图
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
//地址
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
//评分
@property (weak, nonatomic) IBOutlet TYcommentGradeView *starView;
//体验人数
@property (weak, nonatomic) IBOutlet UILabel *experienceLabel;

@end

@implementation TYMyExperienceStoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"我的体验店" andTitleColor:[UIColor whiteColor] andImage:nil];
    
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.iconImageView.clipsToBounds = YES;
    self.starView.userInteractionEnabled = false;
    
    self.titleArr = [NSMutableArray arrayWithObjects:@"预约顾客", @"已体验", @"顾客评论", nil];
    [self setUpTitleView];
    for (NSInteger i = 0; i < self.titleArr.count; i++) {
        MyExperienceStoreVC *vc = [[MyExperienceStoreVC alloc] init];
        vc.type = i;
        [self addChildViewController:vc];
        
        // 设置顶部的标签栏
        [self setupTitlesView:self.titleArr childIndex:i];
    }
    [self setupContentView];
    
    [self requestExpCenterDetail];
}

// 内容scrollview
- (void)setupContentView
{
    CGFloat linetopH = CGRectGetHeight(self.titleView.frame);
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.frame = CGRectMake(0, linetopH + 100, KScreenWidth, KScreenHeight -linetopH - 64 - 100);
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
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, KScreenWidth, 40)];
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
    button.tag = index;

    [button setTitle:self.titleArr[index] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
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

#pragma mark -- 网路请求
//85 线下体验 体验店详情
- (void)requestExpCenterDetail{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = @([TYLoginModel getExperienceId]);//体验店ID
    
    NSString *url = [NSString stringWithFormat:@"%@MAPI/Exp/GetExpCenterDetail",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            TYExpCenterDetailModel *model = [TYExpCenterDetailModel mj_objectWithKeyValues:[respondObject objectForKey:@"c"]];
            [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PhotoUrl, model.f]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
            self.addressLabel.text = [TYValidate IsNotNull:model.e];
            self.experienceLabel.text = [NSString stringWithFormat:@"%ld人体验", model.p];
            [self.starView setNumberOfStars:5 rateStyle:RateStyleHalfStar isAnination:YES finish:^(CGFloat currentScore) {
            }];
            [self.starView setCurrentScore:model.q];
           
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
      
    } orFailBlock:^(id error) {
        
    }];
}


@end
