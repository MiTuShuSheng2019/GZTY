//
//  TYTYRetailOutStorageBigModel.h
//  美界联盟
//
//  Created by LY on 2017/11/11.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYRetailOutStorageModel.h"

@interface TYTYRetailOutStorageBigModel : NSObject
/** 流水号 */
@property (nonatomic, strong) NSString *d;
/** 销售数量 */
@property (nonatomic, assign) NSInteger e;
/** 详情数组 */
@property (nonatomic, strong) NSArray *f;
/** 总价 */
@property (nonatomic, assign) double g;

@end
