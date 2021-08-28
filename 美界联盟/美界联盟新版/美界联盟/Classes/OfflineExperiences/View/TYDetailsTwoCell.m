//
//  TYDetailsTwoCell.m
//  美界联盟
//
//  Created by LY on 2017/11/23.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYDetailsTwoCell.h"
#import "CommentImageCollectionViewCell.h"

@interface TYDetailsTwoCell ()<UICollectionViewDataSource, UICollectionViewDelegate, SDPhotoBrowserDelegate>

@property (weak, nonatomic) IBOutlet UILabel *telLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet TYcommentGradeView *starView;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myCollectionViewTop;

/** 图片数组 */
@property (nonatomic, strong) NSMutableArray *imgArr;

@end

static NSString *identifyCollection = @"CommentImageCollectionViewCell";

@implementation TYDetailsTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.myCollectionView registerNib:[UINib nibWithNibName:identifyCollection bundle:nil] forCellWithReuseIdentifier:identifyCollection];
    self.myCollectionView.delegate = self;
    self.myCollectionView .dataSource = self;
    
    self.starView.userInteractionEnabled = false;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYDetailsTwoCell";
    TYDetailsTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

-(void)setModel:(TYCommentModel *)model{
    _model = model;
    
    self.telLabel.text = [TYValidate IsNotNull:model.eb];
    self.timeLabel.text = [TYValidate IsNotNull:model.ee];
    [self.starView setNumberOfStars:5 rateStyle:RateStyleHalfStar isAnination:YES finish:^(CGFloat currentScore) {
        
    }];
    [self.starView setCurrentScore:model.ed];
    self.contentLabel.text = [TYValidate IsNotNull:model.ec];
    
    [self.imgArr removeAllObjects];
    for (int i = 0; i < model.ef.count; i++) {
        NSString *imgStr = [NSString stringWithFormat:@"%@%@", PhotoUrl,model.ef[i]];
        [self.imgArr addObject:imgStr];
    }
    [self.myCollectionView reloadData];
}


#pragma mark - <UICollectionViewDelegate,UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.imgArr.count > 3) {
        return 3;
    }else{
        return self.imgArr.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CommentImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifyCollection forIndexPath:indexPath];
    [cell.mainImageView sd_setImageWithURL:[NSURL URLWithString:self.imgArr[indexPath.row]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = KScreenWidth - 40;
    
    return CGSizeMake(width / 3, 120);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
{
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
    photoBrowser.delegate = self;
    photoBrowser.currentImageIndex = indexPath.row;
    if (self.imgArr.count > 3) {
        photoBrowser.imageCount = 3;
    }else{
        photoBrowser.imageCount = self.imgArr.count;
    }
    photoBrowser.sourceImagesContainerView = self.myCollectionView;
    [photoBrowser show];
}

#pragma mark - SDPhotoBrowserDelegate
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    CommentImageCollectionViewCell *cell = (CommentImageCollectionViewCell *)[self.myCollectionView cellForItemAtIndexPath:indexPath];
    return cell.mainImageView.image;
}

#pragma mark -- 懒加载
- (NSMutableArray *) imgArr
{
    if (!_imgArr) {
        _imgArr = [NSMutableArray array];
    }
    return _imgArr;
}

@end
