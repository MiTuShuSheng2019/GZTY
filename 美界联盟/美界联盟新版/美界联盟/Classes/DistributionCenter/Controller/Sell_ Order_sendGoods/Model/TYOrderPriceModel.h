//
//  TYOrderPriceModel.h
//  美界联盟
//
//  Created by LY on 2017/10/30.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYOrderPriceModel : NSObject
/** 产品ID */
@property (nonatomic, assign) NSInteger ea;
/** 产品名称 */
@property (nonatomic, strong) NSString *eb;
/** 产品图片 */
@property (nonatomic, strong) NSString *ec;
/** 总价 */
@property (nonatomic, assign) double ed;
/** 总数量 */
@property (nonatomic, assign) NSInteger ee;

@end
