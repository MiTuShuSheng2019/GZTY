//
//  TYDistributorsModel.h
//  美界联盟
//
//  Created by LY on 2017/10/31.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYDistributorsModel : NSObject

/** 分销商id */
@property (nonatomic, assign) NSInteger ea;
/** 分销商名称 */
@property (nonatomic, strong) NSString *eb;
/** 微信号 */
@property (nonatomic, strong) NSString *ec;
/** 电话 */
@property (nonatomic, strong) NSString *ed;
/** 头像图片链接 */
@property (nonatomic, strong) NSString *ee;
/** 等级名称 */
@property (nonatomic, strong) NSString *ef;
/** 等级ID */
@property (nonatomic, assign) NSInteger eg;
/** 分销商地址 */
@property (nonatomic, strong) NSString *eh;
/** 上级名称 */
@property (nonatomic, strong) NSString *ei;
/** 上级等级 */
@property (nonatomic, strong) NSString *ej;
/** 直属下级人数 */
@property (nonatomic, assign) NSInteger ek;
/** 所有下级人数 */
@property (nonatomic, assign) NSInteger el;

@end
