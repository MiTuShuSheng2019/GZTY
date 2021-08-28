//
//  DEIntegralMallModel.h
//  美界联盟
//
//  Created by Glory_iMac on 2019/9/12.
//  Copyright © 2019 刘燚. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DEIntegralMallModel : NSObject

///
@property(copy,nonatomic) NSString* goodsCode;
///
@property(copy,nonatomic) NSString* goodsName;
///
@property(copy,nonatomic) NSNumber* goodsGold;
///
@property(copy,nonatomic) NSNumber* goodsSilver;
///
@property(copy,nonatomic) NSString* goodsPrice;
///
@property(copy,nonatomic) NSString* goodsUrl;

- (instancetype)initWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
