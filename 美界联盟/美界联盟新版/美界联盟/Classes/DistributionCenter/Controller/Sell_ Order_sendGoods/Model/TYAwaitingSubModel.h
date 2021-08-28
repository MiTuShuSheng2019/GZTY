//
//  TYAwaitingSubModel.h
//  美界app
//
//  Created by LY on 2017/10/21.
//  Copyright © 2017年 Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYAwaitingSubModel : NSObject
/** 订单项ID */
@property (nonatomic, assign) NSInteger eka;
/** 图片url */
@property (nonatomic, strong) NSString *ekb;
/** 产品名称 */
@property (nonatomic, strong) NSString *ekc;
/** 小计 */
@property (nonatomic, assign) NSInteger ekd;
/** 售价 */
@property (nonatomic, assign) NSInteger eke;
/** 商品数量 */
@property (nonatomic, assign) NSInteger ekf;

@end
