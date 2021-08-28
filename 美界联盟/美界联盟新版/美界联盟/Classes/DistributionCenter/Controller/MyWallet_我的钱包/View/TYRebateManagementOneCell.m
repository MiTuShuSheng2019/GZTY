//
//  TYRebateManagementOneCell.m
//  美界联盟
//
//  Created by LY on 2017/11/1.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYRebateManagementOneCell.h"
#import "TYShippingSummaryViewController.h"
#import "TYRetailRevenueViewController.h"

@interface TYRebateManagementOneCell()
//销售总额
@property (weak, nonatomic) IBOutlet UILabel *totalMoeny;
//发货总收入
@property (weak, nonatomic) IBOutlet UILabel *GrossDeliveryLabel;
//零售总收入
@property (weak, nonatomic) IBOutlet UILabel *GrossRetailLabel;

@end

@implementation TYRebateManagementOneCell

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYRebateManagementOneCell";
    TYRebateManagementOneCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setModel:(TYDiffPriceModel *)model{
    _model = model;
    self.totalMoeny.text = [NSString stringWithFormat:@"￥%@",model.f];
    self.GrossDeliveryLabel.text = [NSString stringWithFormat:@"￥%@",model.d];
    self.GrossRetailLabel.text = [NSString stringWithFormat:@"￥%@",model.e];
}

#pragma mark -- 发货总收入点击事件
- (IBAction)ClickGrossDelivery:(UIButton *)sender {
    UITabBarController *tabVc = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nagVc = [tabVc selectedViewController];
    TYShippingSummaryViewController *shippingVc = [[TYShippingSummaryViewController alloc] init];
    [nagVc pushViewController:shippingVc animated:YES];
}

#pragma mark -- 零售总收入点击事件
- (IBAction)ClickGrossRetail:(UIButton *)sender {
    UITabBarController *tabVc = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nagVc = [tabVc selectedViewController];
    TYRetailRevenueViewController *RetailVc = [[TYRetailRevenueViewController alloc] init];
    [nagVc pushViewController:RetailVc animated:YES];
}


@end
