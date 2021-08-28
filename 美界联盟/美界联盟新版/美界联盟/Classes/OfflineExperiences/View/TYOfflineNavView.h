//
//  TYOfflineNavView.h
//  美界联盟
//
//  Created by ydlmac2 on 2017/10/24.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TYOfflineNavViewDelegate <NSObject>
// 搜索
- (void)ClickSearch:(NSString *)content;
// 我的店铺
- (void)ClickMyShop;

@end

@interface TYOfflineNavView : UIView

+ (instancetype)showNavView;

/** delegat */
@property (nonatomic, weak) id <TYOfflineNavViewDelegate> delegate;

//我的体验店按钮
@property (nonatomic, strong) UIButton *myShopButton;

@end
