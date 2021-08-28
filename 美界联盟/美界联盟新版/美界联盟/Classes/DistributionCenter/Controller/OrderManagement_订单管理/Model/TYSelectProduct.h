//
//  TYSelectProduct.h
//  美界联盟
//
//  Created by LY on 2017/11/6.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYSelectProduct : NSObject
/** 产品id */
@property (nonatomic, assign) NSInteger ea;
/** 图片url */
@property (nonatomic, strong) NSString *eb;
/** 产品名称 */
@property (nonatomic, strong) NSString *ec;
/** 原价 */
@property (nonatomic, strong) NSString *ed;
/** 现在售价 */
@property (nonatomic, strong) NSString *ee;
/** 销量 */
@property (nonatomic, assign) NSInteger ef;
/** 分享链接 */
@property (nonatomic, strong) NSString *eg;
/** 产品分类id */
@property (nonatomic, assign) NSInteger eh;
/** 产品分类 */
@property (nonatomic, strong) NSString *ei;

/** 属性 */
@property (nonatomic, assign) NSInteger type;


//附加属性
/**  */
//@property (nonatomic, assign) NSInteger number;
/** 商品数量 */
@property (nonatomic, assign) NSInteger countNumber;


@end
