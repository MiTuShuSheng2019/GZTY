//
//  TYIWantAppointmentVC.h
//  美界联盟
//
//  Created by LY on 2017/11/24.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYBaseViewController.h"

@interface TYIWantAppointmentVC : TYBaseViewController

/** 预约项目数组 */
@property (nonatomic, strong) NSArray *contentArr;
/** 体验店id */
@property (nonatomic, assign) NSInteger storID;
/** 封面图地址 */
@property (nonatomic, strong) NSString *imgStr;

@end
