//
//  TYDetailsOneCell.h
//  美界联盟
//
//  Created by LY on 2017/11/23.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYExpCenterDetailModel.h"
#import "TYServiceModel.h"

@interface TYDetailsOneCell : UITableViewCell

+(instancetype)CellTableView:(UITableView *)tableView;

/** TYExpCenterDetailModel */
@property (nonatomic, strong) TYExpCenterDetailModel *detailModel;

/** 服务项目传此模型TYServiceModel */
@property (nonatomic, strong) TYServiceModel *serviceModel;


@end
