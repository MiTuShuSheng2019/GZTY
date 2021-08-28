//
//  TYBaseViewController.m
//  美界联盟
//
//  Created by LY on 2017/10/23.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYBaseViewController.h"

@interface TYBaseViewController ()

@end

@implementation TYBaseViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //去除导航栏下方的横线
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    if ([TYDevice systemVersion] < 11.0) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    }else{
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置navigationBar的背景色
    self.navigationController.navigationBar.barTintColor = RGB(32, 135, 238);
    
//    [[[self navigationController] navigationBar] setBackgroundImage:[UIImage imageNamed:@"navigation_bar_background"] forBarMetrics:UIBarMetricsDefault];
    
    //开启右滑返回上一级的手势。
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)setNavigationBarTitle:(NSString *)title andTitleColor:(UIColor *)color andImage:(NSString *)imageName{
    
    UIButton * titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleButton setTitle:title forState:UIControlStateNormal];
    titleButton.titleLabel.font=[UIFont boldSystemFontOfSize:17];
    [titleButton setTitleColor:color forState:UIControlStateNormal];
    [titleButton setTitleColor:color forState:UIControlStateHighlighted];
    titleButton.userInteractionEnabled = NO;
    titleButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    //设置文字在左边图片在右边
    if (imageName != nil) {
        [titleButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [titleButton sizeToFit];
        
        // 设间距
        CGFloat spacing = 1.0;
        // 图片右移
        CGSize imageSize = titleButton.imageView.frame.size;
        titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width * 2 - spacing, 0, 0);
        
        // 文字左移
        CGSize titleSize = titleButton.titleLabel.frame.size;
        titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, - titleSize.width * 2 - spacing);
    }
    
    self.navigationItem.titleView = titleButton;
    
}
- (void)addNavigationBackBtn:(NSString *)backImage{
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:backImage] forState:UIControlStateNormal];
    [leftButton sizeToFit];
    leftButton.contentEdgeInsets = UIEdgeInsetsMake(2, -10, 0, 0);
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [leftButton addTarget:self action:@selector(navigationBackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)navigationBackBtnClick:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setNavigationLeftBtnImage:(NSString *)imageName{
    
    if (imageName==nil) {
        self.navigationItem.leftBarButtonItem = nil;
        return;
    }
    
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [leftButton sizeToFit];
    
    leftButton.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [leftButton addTarget:self action:@selector(navigationLeftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setNavigationLeftBtnText:(NSString *)text andColor:(UIColor *)color{
    
    if (text==nil) {
        self.navigationItem.leftBarButtonItem = nil;
        return;
    }
    
    UIButton * leftButton = [[UIButton alloc] init];
    [leftButton setTitle:text forState:UIControlStateNormal];
    leftButton.tintColor=[UIColor whiteColor];
    leftButton.titleLabel.font=[UIFont systemFontOfSize:16];
    [leftButton sizeToFit];
    
    [leftButton setTitleColor:color forState:UIControlStateNormal];
    [leftButton setTitleColor:color forState:UIControlStateHighlighted];
    
    //    if ([Device systemVersion]<7.0) {
    //        [leftButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 3, 0, -3)];
    //    }else{
    [leftButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -7, 0, 7)];
    //    }
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [leftButton addTarget:self action:@selector(navigationLeftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setNavigationRightBtnImage:(NSString *)imageName{
    
    if (imageName==nil) {
        self.navigationItem.rightBarButtonItem=nil;
        return;
    }
    
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [rightButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [rightButton sizeToFit];
    
    //    if ([Device systemVersion]>=7.0) {
    rightButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    //    }else{
    //        rightButton.contentEdgeInsets = UIEdgeInsetsMake(0, -3, 0, 3);
    //    }
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [rightButton addTarget:self action:@selector(navigationRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setNavigationRightBtnImage:(NSString *)imageName1 imageName2:(NSString *)imageName2{
    
    if (imageName1==nil || imageName2==nil) {
        self.navigationItem.rightBarButtonItem=nil;
        return;
    }
    
    UIButton * rightButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton1 setImage:[UIImage imageNamed:imageName1] forState:UIControlStateNormal];
    [rightButton1 sizeToFit];
    
    UIButton * rightButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton2 setImage:[UIImage imageNamed:imageName2] forState:UIControlStateNormal];
    [rightButton2 sizeToFit];
    
    UIView *bgView = [[UIView alloc] init];
    [bgView addSubview:rightButton1];
    [bgView addSubview:rightButton2];
    bgView.height = rightButton1.frame.size.height;
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:bgView];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [rightButton1 addTarget:self action:@selector(navigationRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton2 addTarget:self action:@selector(navigationRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setNavigationRightBtnText:(NSString *)text andTextColor:(UIColor *)color{
    
    if (text==nil) {
        self.navigationItem.rightBarButtonItem=nil;
        return;
    }
    
    UIButton * rightButton = [[UIButton alloc] init];
    
    [rightButton setTitle:text forState:UIControlStateNormal];
    rightButton.tintColor=[UIColor whiteColor];
    rightButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [rightButton sizeToFit];
    
    [rightButton setTitleColor:color forState:UIControlStateNormal];
    [rightButton setTitleColor:color forState:UIControlStateHighlighted];
    
    //    if ([Device systemVersion]>=7.0) {
    [rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
    //    }else{
    //        [rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -3, 0, 3)];
    //    }
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [rightButton addTarget:self action:@selector(navigationRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)setNavigationRightBtnText:(NSString *)text1 text2:(NSString *)text2{
    
    if (text1==nil || text2==nil) {
        self.navigationItem.rightBarButtonItem=nil;
        return;
    }
    
    //第一个按钮
    UIButton * rightButton1 = [[UIButton alloc] init];
    [rightButton1 setTitle:text1 forState:UIControlStateNormal];
    rightButton1.tintColor=[UIColor whiteColor];
    rightButton1.titleLabel.font=[UIFont systemFontOfSize:14];
    [rightButton1 sizeToFit];
    
    [rightButton1 setTitleColor:[UIColor colorWithRed:249/255.0 green:90/255.0 blue:53/255.0 alpha:1] forState:UIControlStateNormal];
    [rightButton1 setTitleColor:[UIColor colorWithRed:117/255.0 green:24/255.0 blue:44/255.0 alpha:1] forState:UIControlStateHighlighted];
    
    //第二个按钮
    UIButton * rightButton2 = [[UIButton alloc] init];
    [rightButton2 setTitle:text2 forState:UIControlStateNormal];
    rightButton2.tintColor=[UIColor whiteColor];
    rightButton2.titleLabel.font=[UIFont systemFontOfSize:14];
    [rightButton2 sizeToFit];
    
    [rightButton2 setTitleColor:[UIColor colorWithRed:249/255.0 green:90/255.0 blue:53/255.0 alpha:1] forState:UIControlStateNormal];
    [rightButton2 setTitleColor:[UIColor colorWithRed:117/255.0 green:24/255.0 blue:44/255.0 alpha:1] forState:UIControlStateHighlighted];
    
    rightButton2.x=rightButton1.frame.size.width;
    
    //背景承载试图
    UIView *bgView = [[UIView alloc] init];
    [bgView addSubview:rightButton1];
    [bgView addSubview:rightButton2];
    
    bgView.height=rightButton1.frame.size.height;
    
    //    if ([Device systemVersion]>=7.0) {
    [rightButton1 setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
    [rightButton2 setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
    //    }else{
    //        [rightButton1 setTitleEdgeInsets:UIEdgeInsetsMake(0, -3, 0, 3)];
    //        [rightButton2 setTitleEdgeInsets:UIEdgeInsetsMake(0, -3, 0, 3)];
    //    }
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:bgView];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [rightButton1 addTarget:self action:@selector(navigationRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton2 addTarget:self action:@selector(navigationRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setNavigationLeftBtnText:(NSString *)text image:(NSString *)imageName
{
    if (([text isEqualToString:@""] || text==nil) && imageName==nil) {
        self.navigationItem.leftBarButtonItem=nil;
        return;
    }
    
    UIButton *leftButton = [[UIButton alloc] init];
    
    
    leftButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    if (text.length > 0) {
        [leftButton setTitle:text forState:UIControlStateNormal];
        leftButton.tintColor = [UIColor whiteColor];
        leftButton.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    if (imageName != nil) {
        
        [leftButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [leftButton sizeToFit];
        
        // 还可增设间距
        CGFloat spacing = 1.0;
        // 图片右移
        CGSize imageSize = leftButton.imageView.frame.size;
        leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width * 2 - spacing, 0, 0);
        
        // 文字左移
        CGSize titleSize = leftButton.titleLabel.frame.size;
        leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, - titleSize.width * 2 - spacing);
    }
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [leftButton addTarget:self action:@selector(navigationLeftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)setNavigationRightBtnText:(NSString *)text image:(NSString *)imageName{
    
    if (([text isEqualToString:@""] || text==nil) && imageName==nil) {
        self.navigationItem.rightBarButtonItem=nil;
        return;
    }
    
    UIButton *rightButton = [[UIButton alloc] init];
    
    if (text.length>0) {
        [rightButton setTitle:text forState:UIControlStateNormal];
        rightButton.tintColor=[UIColor whiteColor];
        rightButton.titleLabel.font=[UIFont systemFontOfSize:12];
    }
    
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    if (imageName != nil) {
        
        [rightButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [rightButton sizeToFit];
        
        // 还可增设间距
        CGFloat spacing = 1.0;
        // 图片右移
        CGSize imageSize = rightButton.imageView.frame.size;
        rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width * 2 - spacing, 0, 0);
        
        // 文字左移
        CGSize titleSize = rightButton.titleLabel.frame.size;
        rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, - titleSize.width * 2 - spacing);
    }
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [rightButton addTarget:self action:@selector(navigationRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)navigationLeftBtnClick:(id)sender
{
    
}

- (void)navigationRightBtnClick:(UIButton *)btn{
    
}

-(NSString *)YearMonthDay{
    //获取当前年月日
    NSDate *currentDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    return [NSString stringWithFormat:@"%ld-%ld-%ld",year,month,day];
}

#pragma mark -- 懒加载数组
- (NSMutableArray *)modelArray{
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

@end
