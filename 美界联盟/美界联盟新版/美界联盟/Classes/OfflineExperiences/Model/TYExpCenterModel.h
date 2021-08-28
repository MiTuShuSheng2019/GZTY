//
//  TYExpCenterModel.h
//  美界联盟
//
//  Created by LY on 2017/11/23.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYExpCenterModel : NSObject

/** 体验店id */
@property (nonatomic, assign) NSInteger ea;
/** 体验店名称 */
@property (nonatomic, strong) NSString *eb;
/** Logo图片地址 */
@property (nonatomic, strong) NSString *ec;
/** 联系人 */
@property (nonatomic, strong) NSString *ed;
/** 联系电话 */
@property (nonatomic, strong) NSString *ee;
/** 省 */
@property (nonatomic, strong) NSString *ef;
/** 市 */
@property (nonatomic, strong) NSString *eg;
/** 区 */
@property (nonatomic, strong) NSString *eh;
/** 详细地址 */
@property (nonatomic, strong) NSString *ei;
/** 体验店经度 */
@property (nonatomic, strong) NSString *ej;
/** 体验店纬度 */
@property (nonatomic, strong) NSString *ek;
/** 体验人数 */
@property (nonatomic, assign) NSInteger el;
/** 评论平均分 */
@property (nonatomic, assign) double em;
/** 经销商名称 */
@property (nonatomic, strong) NSString *en;
/** 距离 单位：km */
@property (nonatomic, strong) NSString *eo;

@end
