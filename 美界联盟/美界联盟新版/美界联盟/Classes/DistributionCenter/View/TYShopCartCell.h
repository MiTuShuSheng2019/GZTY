//
//  TYShopCartCell.h
//  美界联盟
//
//  Created by LY on 2017/11/27.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYHotProductModel.h"
#import "PPNumberButton.h"

@protocol TYShopCartCellDelegate <NSObject>

//点击选择
-(void)ClickChoose:(UIButton *)chooseBtn;

@end

@interface TYShopCartCell : UITableViewCell

+(instancetype)CellTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;


/** TYHotProductModel */
@property (nonatomic, strong) TYHotProductModel *model;

/** delegate */
@property (nonatomic, weak) id <TYShopCartCellDelegate> delegate;

@end
