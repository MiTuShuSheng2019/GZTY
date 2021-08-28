//
//  TYBootPageView.h
//  美界APP
//
//  Created by TY-DENG on 2017/10/8.
//  Copyright © 2017年 Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYBootPageView : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonMaginBottomLC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHeightLC;


#pragma mark 展示引导页，默认应用展示一次
+(void) showForView;
@end
