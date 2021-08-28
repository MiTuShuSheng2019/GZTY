//
//  TYTabBarViewController.m
//  美界联盟
//
//  Created by LY on 2017/10/23.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYTabBarViewController.h"
#import "TYNavigationViewController.h"
#import "TYShopMallViewController.h"
#import "TYOfflineExperienceViewController.h"
#import "TYMakerViewController.h"
#import "TYDistributionCenterViewController.h"
#import "TYDistributionCentreVC.h"

@interface TYTabBarViewController ()

@end

@implementation TYTabBarViewController

+ (void)initialize{
    // 通过appearance统一设置所有UITabBarItem的文字属性
    // 后面带有UI_APPEARANCE_SELECTOR的方法, 都可以通过appearance对象来统一设置
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor]} forState:UIControlStateNormal];
    
    //tabBar选中时文字的颜色
   [item setTitleTextAttributes:@{NSForegroundColorAttributeName:RGB(75, 156, 234)}  forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    if ([TYSingleton shareSingleton].consumer == 1) {
//        [self setupChildVc:[[TYShopMallViewController alloc] init] title:@"商城" image:@"shopMall" selectedImage:@"shopMall_Selected"];
//        [self setupChildVc:[[TYOfflineExperienceViewController alloc] init] title:@"线下体验" image:@"Offline" selectedImage:@"Offline_Selected"];
//        [self setupChildVc:[[TYDistributionCenterViewController alloc] init] title:@"个人中心" image:@"center" selectedImage:@"center_Selected"];
//    }else{
    
    
    //此处利用时间戳，是为了规避苹果审核分销商城这个模块，到相应的时间后自然会打开。
//    if ([TYDevice getDateDayNow] > 20190413) {
//        [self setupChildVc:[[TYDistributionCentreVC alloc] init] title:@"分销商城" image:@"distribution" selectedImage:@"distribution_Selected"];
//
//    }
    [self setupChildVc:[[TYShopMallViewController alloc] init] title:@"商城" image:@"shopMall" selectedImage:@"shopMall_Selected"];
    [self setupChildVc:[[TYOfflineExperienceViewController alloc] init] title:@"线下体验" image:@"Offline" selectedImage:@"Offline_Selected"];
    [self setupChildVc:[[TYMakerViewController alloc] init] title:@"创客" image:@"maker" selectedImage:@"maker_Selected"];
    [self setupChildVc:[[TYDistributionCenterViewController alloc] init] title:@"经销中心" image:@"center" selectedImage:@"center_Selected"];
//    self.selectedIndex = 1;
    
    
//    }
//    UIView *tabBarBgView = nil;
//    
//    tabBarBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tabBar.frame.size.width, self.tabBar.frame.size.height)];
//    ///这是整个tabbar的颜色
//    [tabBarBgView setBackgroundColor:[UIColor whiteColor]];
//    [self.tabBar insertSubview:tabBarBgView atIndex:1];
}

/**
 * 初始化子控制器
 */
- (void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage{
    // 设置文字和图片
    vc.navigationItem.title = title;
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    
    // 包装一个导航控制器, 添加导航控制器为tabBarcontroller的子控制器
    TYNavigationViewController *nav = [[TYNavigationViewController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
}


//外部调用的
- (void)upChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage{
    // 设置文字和图片
    vc.navigationItem.title = title;
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
}

@end
