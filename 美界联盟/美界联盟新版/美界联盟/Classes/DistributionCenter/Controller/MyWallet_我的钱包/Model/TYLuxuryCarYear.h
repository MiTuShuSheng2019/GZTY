//
//  TYLuxuryCarYear.h
//  美界联盟
//
//  Created by LY on 2017/11/6.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYLuxuryCarYear : NSObject
/** 年份 */
@property (nonatomic, strong) NSString *da;
/** 第%期 */
@property (nonatomic, assign) NSInteger db;
/** 销售金额 -- 后台已经处理好保留两位有效数字 直接用字符串 */
@property (nonatomic, strong) NSString *dc;

@end
