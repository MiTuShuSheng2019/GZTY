//
//  TYGetDisStyleModel.h
//  美界联盟
//
//  Created by LY on 2017/11/20.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYGetDisStyleModel : NSObject

/** 分销商名称 */
@property (nonatomic, strong) NSString *da;
/** 金额 */
@property (nonatomic, strong) NSString *db;
/** 电话 */
@property (nonatomic, strong) NSString *dc;
/** 微信号 */
@property (nonatomic, strong) NSString *dd;
/** 地址明细 */
@property (nonatomic, strong) NSString *de;
/** 图片 */
@property (nonatomic, strong) NSString *df;


//附加属性
/** cell高度 */
@property (nonatomic, assign) CGFloat cellH;

/** cell底部视图的高度 */
@property (nonatomic, assign) CGFloat cellBottomViewH;

@end
