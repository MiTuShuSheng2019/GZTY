//
//  TYDetailsTwoCell.h
//  美界联盟
//
//  Created by LY on 2017/11/23.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYCommentModel.h"

@interface TYDetailsTwoCell : UITableViewCell

+(instancetype)CellTableView:(UITableView *)tableView;

/** TYCommentModel */
@property (nonatomic, strong) TYCommentModel *model;

/** 更多图片数组 */
@property (nonatomic, strong) NSMutableArray *morePhotoArr;

/** 1表示更多图片cell 其他不用传 */
@property (nonatomic, assign) NSInteger isWhoCell;

@end
