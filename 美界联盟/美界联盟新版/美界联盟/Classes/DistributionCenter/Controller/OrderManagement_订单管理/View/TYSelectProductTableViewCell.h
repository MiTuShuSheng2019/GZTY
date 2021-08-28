//
//  TYSelectProductTableViewCell.h
//  美界APP
//
//  Created by TY-DENG on 17/8/7.
//  Copyright © 2017年 Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYSelectProduct.h"

@class TYSelectProductTableViewCell;

@protocol TYSelectProductTableViewCellDelegate  <NSObject>

-(void)selectProductTableViewCell:(TYSelectProductTableViewCell *)cell Number:(NSInteger)number increaseStatus:(BOOL)increaseStatus;

@end

@interface TYSelectProductTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet PPNumberButton *shopNumberBtn;

@property (assign, nonatomic) NSInteger foodId;

@property (assign, nonatomic) NSUInteger amount;

//减少订单数量 不需要动画效果
@property (copy, nonatomic) void (^plusBlock)(NSInteger count,BOOL animated);


@property (weak, nonatomic) id<TYSelectProductTableViewCellDelegate> delegate;

//创建
+(instancetype)CellTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

/** TYSelectProduct */
@property (nonatomic, strong) TYSelectProduct *model;

@end
