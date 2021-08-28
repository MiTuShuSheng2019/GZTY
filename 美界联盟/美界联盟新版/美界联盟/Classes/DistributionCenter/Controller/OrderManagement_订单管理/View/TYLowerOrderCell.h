//
//  TYLowerOrderCell.h
//  美界联盟
//
//  Created by LY on 2017/11/6.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYMyOrderModel.h"

@protocol TYLowerOrderCellDelegate <NSObject>

//审核通过
-(void)AuditApproval:(UIButton *)btn;
//详情
-(void)LookDetail:(UIButton *)btn;

@end

@interface TYLowerOrderCell : UITableViewCell

+(instancetype)CellTableView:(UITableView *)tableView;

//查看详情
@property (weak, nonatomic) IBOutlet UIButton *detalBtn;
//审核通过
@property (weak, nonatomic) IBOutlet UIButton *auditBtn;
//状态
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

/** delegate */
@property (nonatomic, weak) id <TYLowerOrderCellDelegate> delegate;

/** TYMyOrderModel */
@property (nonatomic, strong) TYMyOrderModel *model;


@end
