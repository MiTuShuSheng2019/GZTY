//
//  TYProductCell.h
//  美界联盟
//
//  Created by LY on 2017/11/22.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYProductCell : UITableViewCell

+(instancetype)CellTableView:(UITableView *)tableView;

/** TYLoginModel */
@property (nonatomic, strong) TYLoginModel *model;

/** 消费者登录传TYConsumerLoginModel */
@property (nonatomic, strong) TYConsumerLoginModel *consumerModel;

@end
