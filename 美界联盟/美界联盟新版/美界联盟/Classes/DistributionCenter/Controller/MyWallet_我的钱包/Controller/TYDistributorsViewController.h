//
//  TYDistributorsViewController.h
//  美界联盟
//
//  Created by LY on 2017/10/31.
//  Copyright © 2017年 刘燚. All rights reserved.
//  分销商控制器

#import "TYBaseViewController.h"

@interface TYDistributorsViewController : TYBaseViewController

/** type = 1从给下级界面加入 type=2 从创建出库信息加入 */
@property (nonatomic, assign) NSInteger type;

@end
