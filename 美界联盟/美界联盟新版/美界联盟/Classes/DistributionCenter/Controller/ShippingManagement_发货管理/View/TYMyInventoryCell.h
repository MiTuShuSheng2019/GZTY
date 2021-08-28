//
//  TYMyInventoryCell.h
//  美界联盟
//
//  Created by LY on 2017/11/8.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYStorageProdModel.h"

@protocol TYMyInventoryCellDelegate <NSObject>

//查看明细
-(void)ClickSeeDetailProduction:(UIButton *)btn;

@end

@interface TYMyInventoryCell : UITableViewCell

+(instancetype)CellTableView:(UITableView *)tableView;

/** delegate */
@property (nonatomic, weak) id <TYMyInventoryCellDelegate> delegate;

/** TYStorageProdModel */
@property (nonatomic, strong) TYStorageProdModel *model;

@end
