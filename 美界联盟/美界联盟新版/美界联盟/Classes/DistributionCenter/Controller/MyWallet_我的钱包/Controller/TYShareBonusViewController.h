//
//  TYShareBonusViewController.h
//  美界联盟
//
//  Created by LY on 2017/11/1.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYBaseViewController.h"
#import "TYAmountModel.h"

@interface TYShareBonusViewController : TYBaseViewController

/** 接收传值 */
@property (nonatomic, strong) TYAmountModel *amountModle;

/** type = 1我的分红  type = 2团队分红 */
@property (nonatomic, assign) NSInteger type;
@end
