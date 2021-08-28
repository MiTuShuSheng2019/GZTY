//
//  TYAuthoriseViewController.m
//  美界联盟
//
//  Created by LY on 2017/11/6.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYAuthoriseViewController.h"
#import "TYSimpeView.h"
#import "TYAuthorizationView.h"

@interface TYAuthoriseViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//产看授权视图
@property (weak, nonatomic) IBOutlet UIView *look;

@end

@implementation TYAuthoriseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"授权生成" andTitleColor:[UIColor whiteColor] andImage:nil];
    
    //赋值头像和姓名
    [self.headImageView setHead:[NSString stringWithFormat:@"%@%@",PhotoUrl,[TYLoginModel getPhoto]]];
    self.nameLabel.text = [TYLoginModel getUserName];
    
    if ([TYLoginModel getWhetherHeadquarters] == 1) {
        //等于1是总部隐藏查看授权
        self.look.hidden = YES;
    }
}

#pragma mark -- 分享授权链接
- (IBAction)ShareAuthorizedLinks {
    return;
    TYSimpeView *screeView = [TYSimpeView CreatTYSimpeView];
    screeView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:screeView];
}

#pragma mark -- 分享二维码授权
- (IBAction)ShareArCodeAuthorization {
    return;
    TYSimpeView *screeView = [TYSimpeView CreatTYSimpeView];
    screeView.type = 1;
    screeView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:screeView];
}

#pragma mark -- 查看授权
- (IBAction)CheckAuthorization {
    TYAuthorizationView *screeView = [TYAuthorizationView CreatTYAuthorizationView];
    screeView.isRequest = YES;
    screeView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:screeView];
}

@end
