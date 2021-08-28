//
//  TYManageModel.h
//  美界联盟
//
//  Created by LY on 2017/11/9.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYManageModel : NSObject
/** 主键ID */
@property (nonatomic, assign) NSInteger ea;
/** 消息标题 */
@property (nonatomic, strong) NSString *eb;
/** 消息内容  */
@property (nonatomic, strong) NSString *ec;
/** 发送消息时间  */
@property (nonatomic, strong) NSString *ed;
/** 是否已读 1：未读；3：已读； */
@property (nonatomic, assign) NSInteger ee;

@end
