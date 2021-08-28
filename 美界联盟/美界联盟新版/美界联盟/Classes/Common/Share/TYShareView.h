//
//  TYShareView.h
//  美界联盟
//
//  Created by LY on 2017/10/25.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYShareView : UIView

//创建
+(instancetype)CreatTYShareView;

//分享必传参数
/** 分销商主键id */
@property (nonatomic, assign) NSInteger distributionID;
/** 产品id */
@property (nonatomic, assign) NSInteger prodcutID;


@end
