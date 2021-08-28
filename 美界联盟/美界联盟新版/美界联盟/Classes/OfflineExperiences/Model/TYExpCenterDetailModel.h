//
//  TYExpCenterDetailModel.h
//  美界联盟
//
//  Created by LY on 2017/11/23.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYServiceModel.h"

@interface TYExpCenterDetailModel : NSObject
/** 体验店ID */
@property (nonatomic, assign) NSInteger d;
/** 体验店名称 */
@property (nonatomic, strong) NSString *e;
/** Logo图片 */
@property (nonatomic, strong) NSString *f;
/** 简介 */
@property (nonatomic, strong) NSString *g;
/** 联系人 */
@property (nonatomic, strong) NSString *h;
/** 联系电话返回字符串数组 */
@property (nonatomic, strong) NSArray *i;
/** 省 */
@property (nonatomic, strong) NSString *j;
/** 市 */
@property (nonatomic, strong) NSString *k;
/** 区 */
@property (nonatomic, strong) NSString *l;
/** 详细地址 */
@property (nonatomic, strong) NSString *m;
/** 经度 */
@property (nonatomic, strong) NSString *n;
/** 纬度 */
@property (nonatomic, strong) NSString *o;
/** 体验人数 */
@property (nonatomic, assign) NSInteger p;
/** 评分 */
@property (nonatomic, assign) double q;
/** 体验店状态：1：开启；2：状态 */
@property (nonatomic, assign) NSInteger r;
/** 体验店服务项目数组 */
@property (nonatomic, strong) NSArray *s;


//附加属性
/** 详情cell的高度 */
@property (nonatomic, assign) CGFloat cellH;

@end
