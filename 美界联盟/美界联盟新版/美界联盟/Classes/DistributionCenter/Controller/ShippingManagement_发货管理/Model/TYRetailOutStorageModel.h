//
//  TYRetailOutStorageModel.h
//  美界联盟
//
//  Created by LY on 2017/11/11.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYRetailOutStorageModel : NSObject

/** 产品ID */
@property (nonatomic, assign) NSInteger fa;
/** PKID */
@property (nonatomic, strong) NSString *fb;
/** 流水号 */
@property (nonatomic, strong) NSString *fc;
/** 条码类型 */
@property (nonatomic, strong) NSString *fd;
/** 分销商ID */
@property (nonatomic, strong) NSString *fe;
/** 备注 */
@property (nonatomic, strong) NSString *ff;
/** 创建时间 */
@property (nonatomic, strong) NSString *fg;
/** 创建分销商ID */
@property (nonatomic, strong) NSString *fh;
/** 创建者名字 */
@property (nonatomic, strong) NSString *fi;
/** 操作类型 */
@property (nonatomic, strong) NSString *fj;
/** PID */
@property (nonatomic, strong) NSString *fk;
/** 销售数量 */
@property (nonatomic, assign) NSInteger fl;
/** 产品名称 */
@property (nonatomic, strong) NSString *fm;
/** 产品图片*/
@property (nonatomic, strong) NSString *fn;
/** 单价 */
@property (nonatomic, assign) double fo;



@end
