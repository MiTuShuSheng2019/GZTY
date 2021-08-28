//
//  TYOutboundGoodsCell.h
//  美界联盟
//
//  Created by LY on 2017/11/10.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYOutboundGoodsModel.h"
#import "TYTYCheckBarCodeBigModel.h"
#import "TYCheckBarCodeModel.h"

@interface TYOutboundGoodsCell : UITableViewCell

+(instancetype)CellTableView:(UITableView *)tableView;

/** TYOutboundGoodsModel */
@property (nonatomic, strong) TYOutboundGoodsModel *model;

/** 从新增出库信息 进入的商品出库 页面传此模型TYTYCheckBarCodeBigModel */
@property (nonatomic, strong) TYTYCheckBarCodeBigModel *checkModel;

@end
