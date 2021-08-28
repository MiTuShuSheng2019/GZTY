//
//  TYAddCartView.h
//  美界联盟
//
//  Created by LY on 2017/11/27.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPNumberButton.h"
#import "TYHotProductModel.h"

@protocol  TYAddCartViewDelagate <NSObject>

//添加购物车
-(void)addCar;

@end

@interface TYAddCartView : UIView

+(instancetype)CreatTYAddCartView;

@property (weak, nonatomic) IBOutlet PPNumberButton *shopNumberBtn;

/** TYShopDetail */
@property (nonatomic, strong) TYHotProductModel *model;

/** delegate */
@property (nonatomic, weak) id <TYAddCartViewDelagate> delegate;

@end
