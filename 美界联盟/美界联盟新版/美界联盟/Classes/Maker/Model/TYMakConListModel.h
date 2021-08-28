//
//  TYMakConListModel.h
//  美界联盟
//
//  Created by LY on 2017/11/20.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TYVideoModel.h"
#import "TYPhotoModel.h"

@interface TYMakConListModel : NSObject

/** PKID */
@property (nonatomic, assign) NSInteger da;
/** 类别id */
@property (nonatomic, assign) NSInteger db;
/** 主图 */
@property (nonatomic, strong) NSString *dc;
/** 主标题 */
@property (nonatomic, strong) NSString *de;
/** 内容 */
@property (nonatomic, strong) NSString *df;
/** 视频数组 */
@property (nonatomic, strong) NSArray *dh;
/** 图片数组 */
@property (nonatomic, strong) NSArray *di;
/** 时间 */
@property (nonatomic, strong) NSString *dj;
/** 内容跳转地址 */
@property (nonatomic, strong) NSString *dk;

//附加属性
@property (nonatomic,assign) BOOL isExpand; //是否打开全文 默认都是NO

@end
