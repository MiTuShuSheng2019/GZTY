//
//  MyExperienceStoreVC.h
//  美界联盟
//
//  Created by LY on 2017/11/25.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYBaseViewController.h"

@interface MyExperienceStoreVC : TYBaseViewController

/** 0表示预约顾客 1表示已体验 2顾客评论 */
@property (nonatomic, assign) NSInteger type;

@end
