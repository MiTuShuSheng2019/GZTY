//
//  DEIntergralCell.h
//  美界联盟
//
//  Created by Glory_iMac on 2019/7/29.
//  Copyright © 2019年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DEIntergralCell : UITableViewCell

@property(strong,nonatomic)NSArray* array;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
