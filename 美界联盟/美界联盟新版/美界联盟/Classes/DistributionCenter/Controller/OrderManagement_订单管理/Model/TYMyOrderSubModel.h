//
//  TYMyOrderSubModel.h
//  美界联盟
//
//  Created by LY on 2017/11/6.
//  Copyright © 2017年 刘燚. All rights reserved.
//  我的订单子模型

#import <Foundation/Foundation.h>

@interface TYMyOrderSubModel : NSObject

/** 订单项ID */
@property (nonatomic, strong) NSString *eka;
/** 图片url */
@property (nonatomic, strong) NSString *ekb;
/** 产品名称 */
@property (nonatomic, strong) NSString *ekc;
/** 小计 */
@property (nonatomic, assign) NSInteger ekd;
/** 售价 */
@property (nonatomic, assign) double eke;
/** 商品数量 */
@property (nonatomic, assign) NSInteger ekf;


/** 积分数量*/
@property (nonatomic, assign) NSInteger Intergral;
/** 积分类型 * 1 银币 * 2 金币*/
@property (nonatomic, assign) NSInteger IntergralType;
/** 图片url */
@property (nonatomic, strong) NSString *smmjProductName;
/** 产品名称 */
@property (nonatomic, strong) NSString *smmjProductUrl;


@end
