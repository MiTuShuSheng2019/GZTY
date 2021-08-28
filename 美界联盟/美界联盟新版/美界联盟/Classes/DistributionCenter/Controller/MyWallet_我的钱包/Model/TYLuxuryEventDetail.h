//
//  TYLuxuryEventDetail.h
//  美界联盟
//
//  Created by LY on 2017/11/6.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYLuxuryEventDetail : NSObject
/** 活动明细PKID */
@property (nonatomic, assign) NSInteger da;
/** 活动PKID */
@property (nonatomic, assign) NSInteger db;
/** 活动明细达标金额 */
@property (nonatomic, assign) double dc;
/** 图片 */
@property (nonatomic, strong) NSString *dd;
/** 首付金额 */
@property (nonatomic, assign) double de;
/** 名称 */
@property (nonatomic, strong) NSString *df;
/** 活动规则 */
@property (nonatomic, strong) NSString *dg;
/** 参与活动PKID */
@property (nonatomic, assign) NSInteger dh;


/** ---- 附加属性 -----*/
/** 选择奖品第二种类型cell的高度 */
@property (nonatomic, assign) CGFloat ChoosePrizeCellH;

/** 豪车季度奖cell的高度 */
@property (nonatomic, assign) CGFloat cellH;

@end
