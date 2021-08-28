//
//  TYServiceModel.h
//  美界联盟
//
//  Created by LY on 2017/11/23.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYServiceModel : NSObject
/** 服务项目id */
@property (nonatomic, assign) NSInteger sa;
/** 服务项目名称 */
@property (nonatomic, strong) NSString *sb;


//附加属性
/** 判断是否被选中 Yes选中*/
@property (nonatomic, assign) BOOL isSelected;

@end
