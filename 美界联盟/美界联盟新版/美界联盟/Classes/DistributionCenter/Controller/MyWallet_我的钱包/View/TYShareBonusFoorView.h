//
//  TYShareBonusFoorView.h
//  美界联盟
//
//  Created by LY on 2017/11/1.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TYShareBonusFoorViewDelegate <NSObject>

//查看历史
-(void)ClickSeeProductionHistory;

@end

@interface TYShareBonusFoorView : UITableViewHeaderFooterView

//创建
+(instancetype)CreatTYShareBonusFoorView;

/** delegate */
@property (nonatomic, weak) id <TYShareBonusFoorViewDelegate> delegate;


@end
