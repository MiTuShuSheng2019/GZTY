//
//  TYMySuperiorViewController.m
//  美界联盟
//
//  Created by LY on 2017/11/7.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYMySuperiorViewController.h"

@interface TYMySuperiorViewController ()
//头像
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
//上级名称
@property (weak, nonatomic) IBOutlet UILabel *upNameLabel;
//姓名
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//电话
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
//微信
@property (weak, nonatomic) IBOutlet UILabel *wxLabel;

@end

@implementation TYMySuperiorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"我的上级" andTitleColor:[UIColor whiteColor] andImage:nil];
    
    [self requestGetcusdetail];
}

#pragma mark --- 网络请求
//7 经销中心-用户管理-获取分销商详细信息
-(void)requestGetcusdetail{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = @([TYLoginModel getPrimaryId]);//分销商ID
    
    NSString *url = [NSString stringWithFormat:@"%@mapi/mcus/getcusdetail",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            
            [self.headImageView setHead:[NSString stringWithFormat:@"%@%@",PhotoUrl,[[respondObject objectForKey:@"c"] objectForKey:@"w"]]];//上级头像地址

            self.upNameLabel.text = [NSString stringWithFormat:@"%@",[TYValidate IsNotNull: [[respondObject objectForKey:@"c"] objectForKey:@"s"]]];//上级名称
            self.nameLabel.text = [NSString stringWithFormat:@"%@",[TYValidate IsNotNull: [[respondObject objectForKey:@"c"] objectForKey:@"s"]]];//上级名称
             self.telLabel.text = [NSString stringWithFormat:@"%@",[TYValidate IsNotNull: [[respondObject objectForKey:@"c"] objectForKey:@"u"]]];//上级电话
             self.wxLabel.text = [NSString stringWithFormat:@"%@",[TYValidate IsNotNull: [[respondObject objectForKey:@"c"] objectForKey:@"v"]]];//上级微信
        }else{
            [TYShowHud showHudSucceedWithStatus:[respondObject objectForKey:@"b"]];
        }
    } orFailBlock:^(id error) {
        
    }];
}

@end
