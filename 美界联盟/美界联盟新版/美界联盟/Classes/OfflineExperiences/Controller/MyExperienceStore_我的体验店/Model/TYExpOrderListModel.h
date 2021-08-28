//
//  TYExpOrderListModel.h
//  美界联盟
//
//  Created by LY on 2017/11/25.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYExpOrderListModel : NSObject
/** 预约单主键ID */
@property (nonatomic, assign) NSInteger ea;
/** 预约人电话 */
@property (nonatomic, strong) NSString *eb;
/** 预约人姓名 */
@property (nonatomic, strong) NSString *ec;
/** 体验店名称 */
@property (nonatomic, strong) NSString *ed;
/** 创建日期 */
@property (nonatomic, strong) NSString *ee;
/** 体验店详细地址 */
@property (nonatomic, strong) NSString *ef;
/** 预约日期 */
@property (nonatomic, strong) NSString *eg;
/** 预约人数 */
@property (nonatomic, assign) NSInteger eh;
/** 服务项名称 */
@property (nonatomic, strong) NSString *ei;
/** 预约单下的评论分数 */
@property (nonatomic, assign) double ej;
/** 评论的状态1：未审核；2：审核失败；3：审核通过 4：禁用 */
@property (nonatomic, assign) NSInteger ek;
/** 预约单状态 状态：1：待接受，2：已接受，3：已体验，9：已取消 */
@property (nonatomic, assign) NSInteger el;
/** 体验店Logo */
@property (nonatomic, strong) NSString *em;
/** 体验店经度 */
@property (nonatomic, strong) NSString *en;
/** 体验店纬度 */
@property (nonatomic, strong) NSString *eo;
/** 字符串数组，可存多个电话 */
@property (nonatomic, strong) NSArray *ep;
/** 预约单备注 */
@property (nonatomic, strong) NSString *eq;


//附加属性cell的高度，预约详情可用到
/** cell的高度 */
@property (nonatomic, assign) CGFloat cellH;

@end
