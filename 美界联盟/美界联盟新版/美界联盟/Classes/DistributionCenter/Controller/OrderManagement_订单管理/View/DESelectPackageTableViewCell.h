//
//  DESelectPackageTableViewCell.h
//  美界联盟
//
//  Created by Glory_iMac on 2019/10/30.
//  Copyright © 2019 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYSelectProduct.h"

@class DESelectPackageTableViewCell;

@protocol DESelectPackageTableViewCellDelegate  <NSObject>

-(void)selectPackageTableViewCell:(DESelectPackageTableViewCell *)cell;

@end

@interface DESelectPackageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIButton *shoppingBtn;

@property (assign, nonatomic) NSInteger foodId;

@property (assign, nonatomic) NSUInteger amount;

//减少订单数量 不需要动画效果
@property (copy, nonatomic) void (^plusBlock)(NSInteger count,BOOL animated);


@property (weak, nonatomic) id<DESelectPackageTableViewCellDelegate> delegate;

//创建
+(instancetype)CellTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

/** TYSelectProduct */
@property (nonatomic, strong) TYSelectProduct *model;

@end
