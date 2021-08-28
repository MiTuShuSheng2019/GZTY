//
//  TYBillDetailModel.h
//  美界联盟
//
//  Created by LY on 2018/11/14.
//  Copyright © 2018 刘燚. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYBillDetailModel : NSObject

@property (nonatomic, assign) double lAmount;
//1 已审核 2待审核
@property (nonatomic, assign) NSInteger lAudit;
/** 时间 */
@property (nonatomic, strong) NSString *lDate;
/** <#注释#> */
@property (nonatomic, strong) NSString *lDescribe;
/** 注释 */
@property (nonatomic, strong) NSString *lId;
/** <#注释#> */
@property (nonatomic, strong) NSString *lName;
/** 注释 */
@property (nonatomic, strong) NSString *lNameStr;
@property (nonatomic, strong) NSString *lType;
@end

NS_ASSUME_NONNULL_END
