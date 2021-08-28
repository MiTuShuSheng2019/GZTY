//
//  TYHistoryShareBonusSubViewController.h
//  美界联盟
//
//  Created by LY on 2017/11/1.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYBaseViewController.h"

@interface TYHistoryShareBonusSubViewController : TYBaseViewController

/** 接收年份 */
@property (nonatomic, strong) NSString *year;

/** type = 1我的分红历史记录  type = 2团队分红历史记录 */
@property (nonatomic, assign) NSInteger type;

@end
