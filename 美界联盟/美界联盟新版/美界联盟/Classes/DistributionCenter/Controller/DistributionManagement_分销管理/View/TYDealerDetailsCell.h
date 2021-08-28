//
//  TYDealerDetailsCell.h
//  美界联盟
//
//  Created by LY on 2017/11/7.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TYDealerDetailsCell : UITableViewCell

//创建
+(instancetype)CellTableView:(UITableView *)tableView;


@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
