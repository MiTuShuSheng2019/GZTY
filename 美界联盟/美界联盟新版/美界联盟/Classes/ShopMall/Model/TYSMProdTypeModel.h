//
//  TYSMProdTypeModel.h
//  美界联盟
//
//  Created by LY on 2017/11/30.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYSMProdTypeModel : NSObject
/** 主键ID */
@property (nonatomic, assign) NSInteger da;
/** 链接地址 或类别名称*/
@property (nonatomic, strong) NSString *db;
@end
