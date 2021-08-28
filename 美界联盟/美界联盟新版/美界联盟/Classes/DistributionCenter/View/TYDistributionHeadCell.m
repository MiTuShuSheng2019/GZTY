//
//  TYDistributionHeadCell.m
//  美界联盟
//
//  Created by LY on 2017/10/26.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYDistributionHeadCell.h"
#import "TYMessageViewController.h"
#import "TYDeliverGoodsViewController.h"
#import "TYRetailViewController.h"
#import "TYOrderTotalAmountViewController.h"
#import "TYSendGoodsViewController.h"
#import "TYPersonSetViewController.h"
#import "TYLoginChooseViewController.h"
#import "TYShopCartViewController.h"
#import "TYAddressManagementVC.h"
#import "TYConsumerPersonSetVC.h"
#import "TYShippingSummaryViewController.h"
#import "TYRetailRevenueViewController.h"

@interface TYDistributionHeadCell ()

//头像
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
//姓名
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//职位
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
//电话
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
//销售总额数量
@property (weak, nonatomic) IBOutlet UILabel *SellTotalLabelNumber;
//订单总额数量
@property (weak, nonatomic) IBOutlet UILabel *OrderTotalLabelNumber;
//待发货数量
@property (weak, nonatomic) IBOutlet UILabel *SendGoodsLabelNumber;
//销售总额
@property (weak, nonatomic) IBOutlet UILabel *SellTotalLabel;
//订单总额
@property (weak, nonatomic) IBOutlet UILabel *OrderTotalLabel;
//待发货
@property (weak, nonatomic) IBOutlet UILabel *SendGoodsLabel;
//购物车图标
@property (weak, nonatomic) IBOutlet UIImageView *addImge;
//地址图标
@property (weak, nonatomic) IBOutlet UIImageView *addressImage;
//个人信息图标
@property (weak, nonatomic) IBOutlet UIImageView *personImage;
//底部视图
@property (weak, nonatomic) IBOutlet UIView *bottomView;
//底部视图的高
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewH;

@end

@implementation TYDistributionHeadCell

-(void)awakeFromNib{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.headImageView.clipsToBounds = YES;
}

//分销商登录
-(void)setModel:(TYLoginModel *)model{
    _model = model;
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoUrl,[TYLoginModel getPhoto]]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
    
    self.nameLabel.text = [TYValidate IsNotNull:[TYLoginModel getUserName]];
    self.positionLabel.text = [NSString stringWithFormat:@" %@ ",[TYLoginModel getGrade]];
    self.telLabel.text = [TYValidate IsNotNull:[TYLoginModel getPhone]];
    
    self.MessageBtn.hidden = NO;
    self.telLabel.hidden = NO;
    self.positionLabel.hidden = NO;
    self.SellTotalLabelNumber.hidden = NO;
    self.OrderTotalLabelNumber.hidden = NO;
    self.SendGoodsLabelNumber.hidden = NO;
    self.addImge.hidden = YES;
    self.addressImage.hidden = YES;
    self.personImage.hidden = YES;
    self.SellTotalLabel.text = @"盈利总额";
    self.OrderTotalLabel.text = @"级差盈利";
    self.SendGoodsLabel.text = @"个人盈利";
    [self.RightBtn setTitle:@"设置" forState:UIControlStateNormal];
    self.SellTotalLabel.textColor = [UIColor darkGrayColor];
    self.SellTotalLabelNumber.textColor = [UIColor darkGrayColor];
    
    //客服需求先隐藏
    self.bottomView.hidden = YES;
    self.bottomViewH.constant = 0.0;
}

//消费者登录
-(void)setConsumerModel:(TYConsumerLoginModel *)consumerModel{
    _consumerModel = consumerModel;
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoUrl,[TYConsumerLoginModel getPhoto]]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
    self.nameLabel.text = [TYValidate IsNotNull:[TYConsumerLoginModel getUserName]];
    
    //消费者登录
    self.MessageBtn.hidden = YES;
    self.mesLabel.hidden = YES;
    self.telLabel.hidden = YES;
    self.positionLabel.hidden = YES;
    self.SellTotalLabelNumber.hidden = YES;
    self.OrderTotalLabelNumber.hidden = YES;
    self.SendGoodsLabelNumber.hidden = YES;
    self.addImge.hidden = NO;
    self.addressImage.hidden = NO;
    self.personImage.hidden = NO;
    self.SellTotalLabel.text = @"购物车";
    self.OrderTotalLabel.text = @"地址管理";
    self.SendGoodsLabel.text = @"个人信息";
    [self.RightBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    
    self.SellTotalLabel.textColor = [UIColor blackColor];
    self.bottomView.hidden = NO;
    self.bottomViewH.constant = 70.0;
}

-(void)setPriceModel:(TYCusPriceModel *)PriceModel{
    _PriceModel = PriceModel;
    self.SellTotalLabelNumber.text = [NSString stringWithFormat:@"￥%0.2lf",PriceModel.m];
    self.OrderTotalLabelNumber.text = [NSString stringWithFormat:@"￥%0.2lf",PriceModel.n];
    self.SendGoodsLabelNumber.text = [NSString stringWithFormat:@"￥%0.2lf",PriceModel.f];
}

-(void)setDiffModel:(TYDiffPriceModel *)diffModel{
    _diffModel = diffModel;
    self.SellTotalLabelNumber.text = [NSString stringWithFormat:@"￥%@",diffModel.f];
    self.OrderTotalLabelNumber.text = [NSString stringWithFormat:@"￥%@",diffModel.d];
    self.SendGoodsLabelNumber.text = [NSString stringWithFormat:@"￥%@",diffModel.e];
}

#pragma mark  --- 点击消息
- (IBAction)ClickMessage {
    TYMessageViewController *messageVc = [[TYMessageViewController alloc] init];
    UITabBarController *tabVc = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nagVc = [tabVc selectedViewController];
    [nagVc pushViewController:messageVc animated:YES];
}

#pragma mark ----- 点击右边的按钮
- (IBAction)ClickRightBtn {
    UITabBarController *tabVc = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nagVc = [tabVc selectedViewController];
    if ([TYSingleton shareSingleton].consumer == 1) {
        
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您确认退出登录吗？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [TYConsumerLoginModel cleanUserLoginAllMessage];
            TYLoginChooseViewController *chooseVc = [[TYLoginChooseViewController alloc] init];
            [nagVc pushViewController:chooseVc animated:YES];
        }];
        
        [alertVc addAction:action1];
        [alertVc addAction:action2];
        [nagVc presentViewController:alertVc animated:YES completion:nil];
        
    }else{
        TYPersonSetViewController *setVc = [[TYPersonSetViewController alloc] init];
        [nagVc pushViewController:setVc animated:YES];
    }
}

#pragma mark --- 销售总额--购物车
- (IBAction)ClickTotalSales {
    UITabBarController *tabVc = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nagVc = [tabVc selectedViewController];
    
    if ([TYSingleton shareSingleton].consumer == 1) {
        
        TYShopCartViewController *shopVc = [[TYShopCartViewController alloc] init];
        [nagVc pushViewController:shopVc animated:YES];
    }else{
        
        return;
        //        TYDeliverGoodsViewController *deliverVc = [[TYDeliverGoodsViewController alloc] init];
        //        TYRetailViewController *retailVc = [[TYRetailViewController alloc] init];
        //
        //        NSArray *controllerViewArray=@[deliverVc,retailVc];
        //        NSArray *titleArray = @[@"发货",@"零售"];
        //        TYScrollTitleViewController *bigVc = [[TYScrollTitleViewController alloc] initWithViewControllerArray:[NSMutableArray arrayWithArray:controllerViewArray] withTitleArray:[NSMutableArray arrayWithArray:titleArray] SelectNum:0];
        //        [bigVc setNavigationBarTitle:@"销售总额" andTitleColor:[UIColor whiteColor] andImage:nil];
        //
        //        bigVc.hidesBottomBarWhenPushed = YES;
        //
        //        [nagVc pushViewController:bigVc animated:YES];
    }
    
}

#pragma mark --- 订单总额---管理收货地址
- (IBAction)ClickTotalOrder {
    UITabBarController *tabVc = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nagVc = [tabVc selectedViewController];
    if ([TYSingleton shareSingleton].consumer == 1) {
        TYAddressManagementVC *vc = [[TYAddressManagementVC alloc] init];
        [nagVc pushViewController:vc animated:YES];
    }else{
        //        TYOrderTotalAmountViewController *orderVc = [[TYOrderTotalAmountViewController alloc] init];
        //        [nagVc pushViewController:orderVc animated:YES];
        
        
        TYShippingSummaryViewController *orderVc = [[TYShippingSummaryViewController alloc] init];
        [nagVc pushViewController:orderVc animated:YES];
    }
}

#pragma mark --- 待发货--消费者登录个人设置
- (IBAction)ClickSendGoods {
    UITabBarController *tabVc = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nagVc = [tabVc selectedViewController];
    if ([TYSingleton shareSingleton].consumer == 1) {
        TYConsumerPersonSetVC *setVc = [[TYConsumerPersonSetVC alloc] init];
        [nagVc pushViewController:setVc animated:YES];
    }else{
        //        TYSendGoodsViewController *SendGoodsVc = [[TYSendGoodsViewController alloc] init];
        //        [nagVc pushViewController:SendGoodsVc animated:YES];
        
        TYRetailRevenueViewController *RetailVc = [[TYRetailRevenueViewController alloc] init];
        [nagVc pushViewController:RetailVc animated:YES];
    }
}

@end
