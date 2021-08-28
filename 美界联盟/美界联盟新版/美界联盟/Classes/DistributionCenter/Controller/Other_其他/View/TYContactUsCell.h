//
//  TYContactUsCell.h
//  美界联盟
//
//  Created by LY on 2017/11/1.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYContactUsModel.h"

@interface TYContactUsCell : UITableViewCell

+(instancetype)CellTableView:(UITableView *)tableView;

//标题
@property (weak, nonatomic) IBOutlet UILabel *title;

//内容
@property (weak, nonatomic) IBOutlet UILabel *content;

/** TYContactUsModel */
@property (nonatomic, strong) TYContactUsModel *model;


@end
