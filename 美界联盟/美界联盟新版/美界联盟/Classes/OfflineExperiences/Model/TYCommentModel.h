//
//  TYCommentModel.h
//  美界联盟
//
//  Created by LY on 2017/11/23.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYCommentModel : NSObject

/** 评论id */
@property (nonatomic, assign) NSInteger ea;
/** 评论人电话 */
@property (nonatomic, strong) NSString *eb;
/** 评论内容 */
@property (nonatomic, strong) NSString *ec;
/** 评分 */
@property (nonatomic, assign) double ed;
/** 评论时间 */
@property (nonatomic, strong) NSString *ee;
/** 评论图片数组 */
@property (nonatomic, strong) NSArray *ef;

//附加属性
/** cell的高度 */
@property (nonatomic, assign) CGFloat cellH;

@end
