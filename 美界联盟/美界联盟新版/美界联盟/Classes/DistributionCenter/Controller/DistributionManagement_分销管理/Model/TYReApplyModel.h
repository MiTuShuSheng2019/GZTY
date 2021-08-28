//
//  TYReApplyModel.h
//  美界联盟
//
//  Created by LY on 2017/11/7.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYReApplyModel : NSObject

/** 分销商id */
@property (nonatomic, assign) NSInteger ea;
/** 分销商名称 */
@property (nonatomic, strong) NSString *eb;
/** 分销商电话 */
@property (nonatomic, strong) NSString *ec;
/** 申请等级 */
@property (nonatomic, strong) NSString *ed;
/** 原等级 */
@property (nonatomic, strong) NSString *ee;
/** 审核状态 */
@property (nonatomic, strong) NSString *ef;

@end
