//
//  TYEventModel.h
//  美界联盟
//
//  Created by LY on 2017/11/1.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYEventModel : NSObject
/** 活动PKID */
@property (nonatomic, assign) NSInteger da;
/** 活动开始时间 */
@property (nonatomic, strong) NSString *db;
/** 活动结束时间 */
@property (nonatomic, strong) NSString *dc;
/** 活动最低参与金额 */
@property (nonatomic, assign) double dd;
/** 活动名称 */
@property (nonatomic, strong) NSString *de;
/** 活动图片 */
@property (nonatomic, strong) NSString *df;

//附加属性
/** cell的高度 */
@property (nonatomic, assign) CGFloat cellH;

@end
