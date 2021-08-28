//
//  TYSelectProductMenuTableViewCell.h
//  美界APP
//
//  Created by TY-DENG on 17/8/8.
//  Copyright © 2017年 Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYProdtypeModel.h"

@interface TYSelectProductMenuTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *menuTitleLabel;

+(instancetype)CellTableView:(UITableView *)tableView;

/** TYProdtypeModel */
@property (nonatomic, strong) TYProdtypeModel *model;

@end
