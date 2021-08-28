//
//  TYCircleFriendPhotoCell.h
//  美界联盟
//
//  Created by LY on 2017/11/16.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TYCircleFriendPhotoCell;

@protocol TYCircleFriendPhotoCellDelegate <NSObject>
// 点击全文回调展开
- (void)clickShowAllDetails:(TYCircleFriendPhotoCell *)cell expand:(BOOL)isExpand;

@end

@interface TYCircleFriendPhotoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView; //!< 头像
@property (weak, nonatomic) IBOutlet QLCLabel *nameLabel; //!< 名字
@property (weak, nonatomic) IBOutlet QLCLabel *desLabel; //!< 文字发布
@property (nonatomic,assign) BOOL isExpand; //!< 是否展开Desc 用来控制

@property (weak, nonatomic) IBOutlet UIButton *showAllDetailsButton;//全文按钮
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showAllHeight;//全文按钮的高度 25

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView; //!< 九宫格
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colletionViewHeight; //!< 九宫格高度
@property (weak, nonatomic) IBOutlet UILabel *timeLabel; //!< 时间轴
@property (weak, nonatomic) IBOutlet UIButton *saveButton; //!< 保存按钮


@property (nonatomic,strong) NSMutableArray *imageDatas; //!< 九宫格图片数据源
@property (nonatomic,strong) NSMutableArray *videoDatas; //!< 视频播放数据源

@property (nonatomic,assign) id<TYCircleFriendPhotoCellDelegate>delegate;

//创建cell
+(instancetype)CellTableView:(UITableView *)tableView;


@end
