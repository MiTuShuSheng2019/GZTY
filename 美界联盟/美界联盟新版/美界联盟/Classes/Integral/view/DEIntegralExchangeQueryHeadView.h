//
//  DEIntegralExchangeQueryHeadView.h
//  美界联盟
//
//  Created by Glory_iMac on 2019/7/24.
//  Copyright © 2019年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DEIntegralExchangeQueryHeadViewDelegate <NSObject>
//点击分享
-(void)queryName:(NSString*)name phone:(NSString*)phone Date:(NSString*)date1 witnDate:(NSString*)date2 type:(NSInteger)type;

@end

@interface DEIntegralExchangeQueryHeadView : UIView

//调用此方法创建DEIntegralQueryHeadView
+(instancetype)CreatDEIntegralExchangeQueryHeadView;

@property (weak, nonatomic) NSDictionary *dictionary;

@property(nonatomic,assign) id<DEIntegralExchangeQueryHeadViewDelegate> delegate;

@end
