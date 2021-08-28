//
//  TYAmountModel.h
//  美界联盟
//
//  Created by LY on 2017/11/1.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYAmountModel : NSObject
/** 个人销售金额 */
@property (nonatomic, assign) double d;
/** 团队销售金额 */
@property (nonatomic, assign) double e;
/** 销售金额 */
@property (nonatomic, assign) double f;
/** 总金额 */
@property (nonatomic, assign) double g;
/** 开始季度日期 */
@property (nonatomic, strong) NSString *h;
/** 结束季度日期 */
@property (nonatomic, strong) NSString *i;
/** 个人总返利金额 */
@property (nonatomic, assign) double j;
/** 团队总返利金额 */
@property (nonatomic, assign) double k;
/** 总返利金额 */
@property (nonatomic, assign) double l;
/** 个人首充返利金额 */
@property (nonatomic, assign) double m;
/** 个人首充金额 */
@property (nonatomic, assign) double n;

@end
