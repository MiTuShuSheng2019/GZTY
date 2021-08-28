//
//  TYTYCheckBarCodeBigModel.h
//  美界联盟
//
//  Created by LY on 2017/11/13.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYTYCheckBarCodeBigModel : NSObject
/** 条码类型 1,2,3*/
@property (nonatomic, assign) NSInteger d;
/** 条码状态 */
@property (nonatomic, assign) NSInteger e;
/** 商品数组 */
@property (nonatomic, strong) NSArray *f;

@end
