//
//  TYStockModel.h
//  美界联盟
//
//  Created by LY on 2017/11/7.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYStockModel : NSObject
/** 出库总数量 */
@property (nonatomic, assign) NSInteger d;
/** 进货总数量 */
@property (nonatomic, assign) NSInteger e;
/** 剩余总数量 */
@property (nonatomic, assign) NSInteger f;
/** 退货数量 */
@property (nonatomic, assign) NSInteger g;
/** 受退零售数量 */
@property (nonatomic, assign) NSInteger h;
/** 受退数量 */
@property (nonatomic, assign) NSInteger i;
/** 零售数量 */
@property (nonatomic, assign) NSInteger k;
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

@end
