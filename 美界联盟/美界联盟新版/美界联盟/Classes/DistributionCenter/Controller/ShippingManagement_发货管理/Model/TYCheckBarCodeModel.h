//
//  TYCheckBarCodeModel.h
//  美界联盟
//
//  Created by LY on 2017/11/13.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYCheckBarCodeModel : NSObject

/** 条码状态表主键PKID */
@property (nonatomic, strong) NSString *fa;
/** 所属大标 */
@property (nonatomic, strong) NSString *fb;
/** 所属小标 */
@property (nonatomic, strong) NSString *fc;
/** 所属中标 */
@property (nonatomic, strong) NSString *fd;
/** 密码 */
@property (nonatomic, strong) NSString *fe;
/** ScaleID */
@property (nonatomic, assign) NSInteger ff;
/** 产品ID */
@property (nonatomic, assign) NSInteger fg;
/** 条码状态 */
@property (nonatomic, strong) NSString *fh;
/** 之前状态 */
@property (nonatomic, strong) NSString *fi;
/** 当前所属分销商ID */
@property (nonatomic, strong) NSString *fj;
/** 产品id */
@property (nonatomic, strong) NSString *fk;
/** 产品名称 */
@property (nonatomic, strong) NSString *fl;

@end
