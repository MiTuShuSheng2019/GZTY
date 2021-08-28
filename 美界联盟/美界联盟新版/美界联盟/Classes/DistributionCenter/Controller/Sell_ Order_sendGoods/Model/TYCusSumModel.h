//
//  TYCusSumModel.h
//  美界联盟
//
//  Created by LY on 2017/10/30.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYCusSumModel : NSObject
/** 总数量 */
@property (nonatomic, assign) NSInteger d;
/** 总金额 */
@property (nonatomic, assign) double e;
/** 产品名称 */
@property (nonatomic, strong) NSString *f;
/** 产品图片 */
@property (nonatomic, strong) NSString *g;

@end
