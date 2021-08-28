//
//  TYForRecord.h
//  美界联盟
//
//  Created by LY on 2017/11/6.
//  Copyright © 2017年 刘燚. All rights reserved.
//  兑换记录模型

#import <Foundation/Foundation.h>

@interface TYForRecord : NSObject

/** 图片 */
@property (nonatomic, strong) NSString *da;
/** 全款金额 */
@property (nonatomic, strong) NSString *db;
/** 名称 */
@property (nonatomic, strong) NSString *dc;
/** 是否可全款支付 */
@property (nonatomic, assign) NSInteger dd;
/** 兑换时间 */
@property (nonatomic, strong) NSString *de;
/** 1总部待审核，2：总部审核，3已首付提车，4已全款提车 */
@property (nonatomic, assign) NSInteger df;
/** PKID */
@property (nonatomic, strong) NSString *dg;

@end
