//
//  TYLoginChooseViewController.m
//  美界联盟
//
//  Created by LY on 2017/10/26.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYLoginChooseViewController.h"
#import "TYLoginViewController.h"

@interface TYLoginChooseViewController ()
//消费者登录按钮
@property (weak, nonatomic) IBOutlet UIButton *consumerBtn;

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation TYLoginChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    
    //获取本地软件的版本号
    NSString *localVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    self.versionLabel.text = [NSString stringWithFormat:@"版本V%@",localVersion];
    //此处利用时间戳屏蔽消费者登录按钮，是为了规避苹果审核，
    //少一种登录模式，降低风险，提高通过率
    //20181207 表示的是2018年12月07日之后恢复 正常 此时APP已经上线啦，提交审核者 可更改此时间
//    if ([TYDevice getDateDayNow] > 20181207) {
//        self.consumerBtn.hidden = NO;
//    }else{
//        self.consumerBtn.hidden = YES;
//    }
    self.consumerBtn.hidden = YES;
}

//返回按钮被点击时的动作。
- (void)navigationBackBtnClick:(id)sender{
    [self.tabBarController setSelectedIndex:0];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 消费者登录
- (IBAction)ConsumerLogin {
    TYLoginViewController *loginVc = [[TYLoginViewController alloc] init];
    loginVc.type = 1;
    [self.navigationController pushViewController:loginVc animated:YES];
}

#pragma mark -- 分销商登录
- (IBAction)DistributorLogin {
    TYLoginViewController *loginVc = [[TYLoginViewController alloc] init];
    [self.navigationController pushViewController:loginVc animated:YES];
}

@end
