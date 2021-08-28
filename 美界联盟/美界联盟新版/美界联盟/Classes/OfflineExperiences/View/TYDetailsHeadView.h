//
//  TYDetailsHeadView.h
//  美界联盟
//
//  Created by LY on 2017/11/23.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYExpCenterModel.h"

@protocol TYDetailsHeadViewDelegate <NSObject>

//导航
-(void)Navigation;

//拨打电话
-(void)CallPhone;

//预约
-(void)MakeAppointment;

@end

@interface TYDetailsHeadView : UIView

+(instancetype)CreatTYDetailsHeadView;

//轮播图的背景View
@property (weak, nonatomic) IBOutlet UIView *photoView;

/** TYExpCenterModel */
@property (nonatomic, strong) TYExpCenterModel *model;

/** delegate */
@property (nonatomic, weak) id <TYDetailsHeadViewDelegate> delegate;

@end
