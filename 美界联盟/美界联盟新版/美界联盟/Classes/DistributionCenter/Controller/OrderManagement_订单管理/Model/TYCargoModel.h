//
//  TYCargoModel.h
//  美界联盟
//
//  Created by LY on 2017/12/1.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYCargoModel : NSObject

/** <#注释#> */
@property (nonatomic, strong) NSString *Barcode;
/** <#注释#> */
@property (nonatomic, strong) NSString *BarcodeTypeStr;
/** 注释 */
@property (nonatomic, strong) NSString *CreateTime;
/** <#注释#> */
@property (nonatomic, strong) NSString *CreatorName;
/** <#注释#> */
@property (nonatomic, strong) NSString *DistributorFullName;
/** <#注释#> */
@property (nonatomic, strong) NSString *DoTypeStr;
/** 注释 */
@property (nonatomic, strong) NSString *FKInDistributorID;
/** <#注释#> */
@property (nonatomic, strong) NSString *FKOutDistributorID;
/** <#注释#> */
@property (nonatomic, strong) NSString *FKProductId;
/** <#注释#> */
@property (nonatomic, strong) NSString *InDistributorFullName;
/** 注释 */
@property (nonatomic, strong) NSString *OperateTitle;
/** <#注释#> */
@property (nonatomic, strong) NSString *OperateTypeStr;
/** <#注释#> */
@property (nonatomic, strong) NSString *PID;
/** 注释 */
@property (nonatomic, strong) NSString *PKID;
/** <#注释#> */
@property (nonatomic, strong) NSString *ProductFullName;

@end
