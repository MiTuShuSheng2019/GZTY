//
//  TYShopMallHeadView.m
//  美界联盟
//
//  Created by LY on 2017/10/24.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYShopMallHeadView.h"
#import "TYBannerModel.h"
#import "TYHotProductViewController.h"
#import "TYAllProductsViewController.h"
#import "DEIntegralMallController.h"

@interface TYShopMallHeadView ()
//分类的背景View
@property (weak, nonatomic) IBOutlet UIView *ClassifyView;
/** 轮播图片数组 */
@property (nonatomic, strong) NSMutableArray *photoArr;

@end

@implementation TYShopMallHeadView

+(instancetype)CreatTYShopMallHeadView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    NSArray *array = @[@"AllClass", @"HotProducts", @"NewProduct", @"积分商城"];//图片
    NSArray *label = @[@"所有产品", @"热销产品", @"新品推荐", @"积分商城"];//文字
    
    NSInteger arrayCount = array.count;
    CGFloat buttonW = 50;
    CGFloat buttonH = 75;
    CGFloat y = 10;
    CGFloat x = (KScreenWidth - buttonW * arrayCount) / (arrayCount * 2);

    for (int j = 0; j < array.count; j++) {
        
        SDReleaseButton *viewButton = [[SDReleaseButton alloc] init];
        viewButton.frame = CGRectMake(x + j*(2 * x+buttonW), y, buttonW, buttonH);
        viewButton.tag = 1000 + j;
        [viewButton setImage:[UIImage imageNamed:array[j]] forState:UIControlStateNormal];
        [viewButton setTitle:label[j] forState:UIControlStateNormal];
        viewButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [viewButton addTarget:self action:@selector(gotoViewController:) forControlEvents:UIControlEventTouchUpInside];
        [viewButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.ClassifyView addSubview:viewButton];
    }
    
}


- (void)gotoViewController:(UIButton *)button{
    //在View中跳转
    switch (button.tag) {
        case 1000:{//所有产品
            TYAllProductsViewController *allVc = [[TYAllProductsViewController alloc] init];
            //取出根视图控制器
            UITabBarController *tabVc = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            //取出当前选中的导航控制器
            UINavigationController *nagVc = [tabVc selectedViewController];
            [nagVc pushViewController:allVc animated:YES];
        }
            break;
        case 1001:{//热销产品
            TYHotProductViewController *hotVc = [[TYHotProductViewController alloc] init];
            hotVc.ProductType = 1;
            UITabBarController *tabVc = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            UINavigationController *nagVc = [tabVc selectedViewController];
            [nagVc pushViewController:hotVc animated:YES];
        }
            break;
        case 1002:{//新品推荐
            TYHotProductViewController *hotVc = [[TYHotProductViewController alloc] init];
            hotVc.ProductType = 2;
            UITabBarController *tabVc = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            UINavigationController *nagVc = [tabVc selectedViewController];
            [nagVc pushViewController:hotVc animated:YES];
            
        }
            break;
        case 1003:{//积分商城
            DEIntegralMallController *imVc = [[DEIntegralMallController alloc] init];
            UITabBarController *tabVc = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            UINavigationController *nagVc = [tabVc selectedViewController];
            [nagVc pushViewController:imVc animated:YES];
            
        }
            break;
        default:
            break;
    }
}

@end
