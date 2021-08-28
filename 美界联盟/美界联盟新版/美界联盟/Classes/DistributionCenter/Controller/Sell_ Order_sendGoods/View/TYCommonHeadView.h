//
//  TYCommonHeadView.h
//  美界联盟
//
//  Created by LY on 2017/10/30.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYCommonHeadView : UIView

//创建View
+(instancetype)CreatTYCommonHeadView;

//金额
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
