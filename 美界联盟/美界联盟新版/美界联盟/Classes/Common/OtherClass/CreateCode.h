//
//  CreateCode.h
//  BangBang
//
//  Created by LY on 16/10/8.
//  Copyright © 2016年 Banglin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreateCode : NSObject
//创建一个二维码
-(CIImage *)createGeneralCode;

/** 添加想要的地址信息 */
@property (nonatomic, strong) NSString *url;

/** 添加想要的内容信息 */
@property (nonatomic, strong) NSString *content;

@end
