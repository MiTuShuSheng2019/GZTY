//
//  TYRetailDeliveryCell.h
//  美界联盟
//
//  Created by LY on 2017/11/11.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TYTYRetailOutStorageBigModel.h"
#import "TYRetailOutStorageModel.h"

@protocol TYRetailDeliveryCellDelegate <NSObject>

//查看详情
-(void)ClickLookDetail:(UIButton *)btn;

@end


@interface TYRetailDeliveryCell : UITableViewCell

+(instancetype)CellTableView:(UITableView *)tableView;

/** TYRetailOutStorageModel */
@property (nonatomic, strong) TYTYRetailOutStorageBigModel *model;

/** delegate */
@property (nonatomic, weak) id <TYRetailDeliveryCellDelegate> delegate;

@end
