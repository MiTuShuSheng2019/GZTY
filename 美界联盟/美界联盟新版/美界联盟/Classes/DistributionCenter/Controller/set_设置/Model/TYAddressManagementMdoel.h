//
//  TYAddressManagementMdoel.h
//  美界联盟
//
//  Created by LY on 2017/11/9.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYAddressManagementMdoel : NSObject

/** 返回PKID */
@property (nonatomic, assign) NSInteger da;
/** 所属分销商ID */
@property (nonatomic, assign) NSInteger db;
/** 联系人 */
@property (nonatomic, strong) NSString *dc;
/** 电话 */
@property (nonatomic, strong) NSString *dd;
/** 省份 */
@property (nonatomic, strong) NSString *de;
/** 城市 */
@property (nonatomic, strong) NSString *df;
/** 地址 */
@property (nonatomic, strong) NSString *dg;
/** 是否默认1不是 2 是 */
@property (nonatomic, assign) NSInteger dh;
/** 创建时间 */
@property (nonatomic, strong) NSString *di;
/** 创建姓名 */
@property (nonatomic, strong) NSString *dj;
/** 邮编 */
@property (nonatomic, strong) NSString *dk;
/** 区域 */
@property (nonatomic, strong) NSString *dl;

//附加属性
/** cell 的高度 */
@property (nonatomic, assign) CGFloat cellH;


@end
