//
//  TYDetailsModel.h
//  美界联盟
//
//  Created by LY on 2017/11/22.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYDetailsModel : NSObject

/** 图片url */
@property (nonatomic, strong) NSString *ea;
/** 图片描述 */
@property (nonatomic, strong) NSString *eb;


//附加属性
/** cell的高度 */
@property (nonatomic, assign) CGFloat cellH;

@end
