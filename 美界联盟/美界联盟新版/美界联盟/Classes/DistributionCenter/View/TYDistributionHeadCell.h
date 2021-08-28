//
//  TYDistributionHeadCell.h
//  美界联盟
//
//  Created by LY on 2017/10/26.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYCusPriceModel.h"
#import "TYDiffPriceModel.h"

@interface TYDistributionHeadCell : UICollectionViewCell

//消息按钮
@property (weak, nonatomic) IBOutlet UIButton *MessageBtn;
//右边的按钮
@property (weak, nonatomic) IBOutlet UIButton *RightBtn;

//消息读数
@property (weak, nonatomic) IBOutlet UILabel *mesLabel;

/** 分销商登录TYLoginModel */
@property (nonatomic, strong) TYLoginModel *model;

/** 消费者登录传此模型TYConsumerLoginModel */
@property (nonatomic, strong) TYConsumerLoginModel *consumerModel;

/** TYCusPriceModel 总金额模型*/
@property (nonatomic, strong) TYCusPriceModel *PriceModel;

/** TYDiffPriceModel */
@property (nonatomic, strong) TYDiffPriceModel *diffModel;

@end
