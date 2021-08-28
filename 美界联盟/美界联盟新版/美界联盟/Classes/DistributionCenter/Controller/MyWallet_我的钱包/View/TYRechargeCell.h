//
//  TYRechargeCell.h
//  美界联盟
//
//  Created by LY on 2017/10/31.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYRechargeModel.h"
#import "TYTransactionRecordModel.h"

@interface TYRechargeCell : UITableViewCell

+(instancetype)CellTableView:(UITableView *)tableView;


/** TYRechargeModel 充值记录传此模型*/
@property (nonatomic, strong) TYRechargeModel *model;

/** TYTransactionRecordModel 交易记录传此模型*/
@property (nonatomic, strong) TYTransactionRecordModel *RecordModel;

@end
