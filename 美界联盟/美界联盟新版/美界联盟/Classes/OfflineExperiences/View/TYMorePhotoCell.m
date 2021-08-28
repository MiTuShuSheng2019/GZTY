//
//  TYMorePhotoCell.m
//  美界联盟
//
//  Created by LY on 2017/11/23.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYMorePhotoCell.h"
#import "CommentImageCollectionViewCell.h"

@interface TYMorePhotoCell ()<UICollectionViewDataSource, UICollectionViewDelegate, SDPhotoBrowserDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

@end

static NSString *identifyCollection = @"CommentImageCollectionViewCell";

@implementation TYMorePhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.myCollectionView registerNib:[UINib nibWithNibName:identifyCollection bundle:nil] forCellWithReuseIdentifier:identifyCollection];
    self.myCollectionView.delegate = self;
    self.myCollectionView .dataSource = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYMorePhotoCell";
    TYMorePhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}


-(void)setMorePhotoArr:(NSMutableArray *)morePhotoArr{
    _morePhotoArr = morePhotoArr;
    [self.myCollectionView reloadData];
}

#pragma mark - <UICollectionViewDelegate,UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.morePhotoArr.count > 3) {
        return 3;
    }else{
        return self.morePhotoArr.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CommentImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifyCollection forIndexPath:indexPath];
    [cell.mainImageView sd_setImageWithURL:[NSURL URLWithString:self.morePhotoArr[indexPath.row]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = KScreenWidth - 40;
    
    return CGSizeMake(width / 3, 110);
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
    if (self.morePhotoArr.count > 3) {
        photoBrowser.imageCount = 3;
    }else{
        photoBrowser.imageCount = self.morePhotoArr.count;
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

@end
