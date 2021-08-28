//
//  TYShopMallOneCell.h
//  美界联盟
//
//  Created by LY on 2017/10/24.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYShopMallOneCell : UITableViewCell

+(instancetype)CellTableView:(UITableView *)tableView;

/** 数据数组 */
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UICollectionView *myCollectionView;

@end
