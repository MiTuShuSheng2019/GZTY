//
//  TYMorePhotoCell.h
//  美界联盟
//
//  Created by LY on 2017/11/23.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYMorePhotoCell : UITableViewCell

+(instancetype)CellTableView:(UITableView *)tableView;

/** 更多图片数组 */
@property (nonatomic, strong) NSMutableArray *morePhotoArr;


@end
