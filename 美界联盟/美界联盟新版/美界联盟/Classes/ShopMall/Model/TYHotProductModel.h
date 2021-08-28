//
//  TYHotProductModel.h
//  美界联盟
//
//  Created by LY on 2017/10/24.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYHotProductModel : NSObject
/** 产品id */
@property (nonatomic, assign) NSInteger ea;
/** 产品名称 */
@property (nonatomic, strong) NSString *eb;
/** 标准价 */
@property (nonatomic, strong) NSString *ec;
/** 折扣价 */
@property (nonatomic, strong) NSString *ed;
/** 缩略图链接 */
@property (nonatomic, strong) NSString *ee;
//图片详细链接
@property (nonatomic, strong) NSArray *ef;

/*****---自定义添加到购物车的商品数量---****/
@property (nonatomic, assign) NSInteger shopNumber;

/** 判断是否被选中 Yes选中*/
@property (nonatomic, assign) BOOL isSelected;

@end
