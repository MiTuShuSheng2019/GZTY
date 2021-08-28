//
//  TYStorageProdModel.h
//  美界联盟
//
//  Created by LY on 2017/11/8.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYStorageProdModel : NSObject

/** 品牌ID */
@property (nonatomic, assign) NSInteger l;
/** 品牌名称 */
@property (nonatomic, strong) NSString *m;
/** 类别ID */
@property (nonatomic, assign) NSInteger n;
/** 类别名称 */
@property (nonatomic, strong) NSString *o;
/** 产品ID */
@property (nonatomic, assign) NSInteger p;
/** 产品名称 */
@property (nonatomic, strong) NSString *q;
/** 进货总数量 */
@property (nonatomic, assign) NSInteger e;
/** 出库总数量 */
@property (nonatomic, assign) NSInteger d;
/** 受退零售数量 */
@property (nonatomic, assign) NSInteger h;
/** 受退数量 */
@property (nonatomic, assign) NSInteger i;
/** 退货数量 */
@property (nonatomic, assign) NSInteger g;
/** 零售数量 */
@property (nonatomic, assign) NSInteger k;
/** 剩余总数量 */
@property (nonatomic, assign) NSInteger f;

@end
