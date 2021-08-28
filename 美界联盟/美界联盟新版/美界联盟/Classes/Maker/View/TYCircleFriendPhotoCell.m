//
//  TYCircleFriendPhotoCell.m
//  美界联盟
//
//  Created by LY on 2017/11/16.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYCircleFriendPhotoCell.h"
#import "CommentImageCollectionViewCell.h"
#import "TYPhotoModel.h"
#import "TYVideoCollectionCell.h"
#import "TYVideoPlayerVC.h"
#import "TYVideoModel.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "XMPlayerManager.h"

// 照片原图路径
#define KOriginalPhotoImagePath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@OriginalPhotoImages]

// 视频URL路径
#define KVideoUrlPath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@VideoURL]

// caches路径
#define KCachesPath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)
                                     
@interface TYCircleFriendPhotoCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SDPhotoBrowserDelegate>

@end

static NSString *identifyCollection = @"CommentImageCollectionViewCell";
static NSString *identifyCollection2 = @"TYVideoCollectionCell";

@implementation TYCircleFriendPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.collectionView registerNib:[UINib nibWithNibName:identifyCollection bundle:nil] forCellWithReuseIdentifier:identifyCollection];
    
    [self.collectionView registerNib:[UINib nibWithNibName:identifyCollection2 bundle:nil] forCellWithReuseIdentifier:identifyCollection2];
    
    self.collectionView.delegate = self;
    self.collectionView .dataSource = self;
    
    self.autoresizingMask = UIViewAutoresizingNone;
}

+(instancetype)CellTableView:(UITableView *)tableView{
    NSString *ID = @"TYCircleFriendPhotoCell";
    TYCircleFriendPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark - <UICollectionViewDelegate,UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.imageDatas.count != 0) {
        return self.imageDatas.count;
    }else{
        return self.videoDatas.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.imageDatas.count != 0) {
        CommentImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifyCollection forIndexPath:indexPath];
       
        TYPhotoModel *model = self.imageDatas[indexPath.item];
        
        [cell.mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoUrl,model.dia]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
         
        return cell;
    }else{
        TYVideoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifyCollection2 forIndexPath:indexPath];
        TYVideoModel *model = self.videoDatas[indexPath.row];
        [cell.videoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PhotoUrl, model.dhb]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = KScreenWidth - 90 - 20;
    if (self.imageDatas.count != 0) {
        
        if (![NSArray isEmpty:self.imageDatas])
        {
            if (self.imageDatas.count == 1)
            {
                return CGSizeMake(width / 2, width / 1.5);
            }else{
                return CGSizeMake(width / 3, width / 3);
            }
        }
        return CGSizeZero;
    }else{
         return CGSizeMake(width / 2, width / 1.5);
    }
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
    if (self.imageDatas.count != 0) {
        SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
        photoBrowser.delegate = self;
        photoBrowser.currentImageIndex = indexPath.row;
        photoBrowser.imageCount = self.imageDatas.count;
        photoBrowser.sourceImagesContainerView = self.collectionView;
        [photoBrowser show];
    }else{
        TYVideoModel *model = [self.videoDatas firstObject];
        TYVideoPlayerVC *videoVc = [[TYVideoPlayerVC alloc] init];
        videoVc.type = 1;
        videoVc.strUrl = [NSString stringWithFormat:@"%@%@",PhotoUrl,model.dha];
        UITabBarController *tabVc = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        UINavigationController *nagVc = [tabVc selectedViewController];
        [nagVc pushViewController:videoVc animated:YES];
    }
}

#pragma mark - SDPhotoBrowserDelegate
//- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
//    NSString *urlString = self.imageDatas[index];
//    return [NSURL URLWithString:urlString];
//}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    CommentImageCollectionViewCell *cell = (CommentImageCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return cell.mainImageView.image;
}


#pragma mark -- 点击全文
- (IBAction)FullText:(UIButton *)sender {
    
    self.isExpand = !self.isExpand;

    if (self.delegate && [self.delegate respondsToSelector:@selector(clickShowAllDetails:expand:)]) {
        [self.delegate clickShowAllDetails:self expand:self.isExpand];
    }
}

#pragma mark -- 点击保存图片
- (IBAction)savePhoto:(UIButton *)sender {
    
    if (self.imageDatas.count != 0) {
        //保存图片
        [self savePhoto];
    }else if (self.videoDatas.count != 0){
        //保存视频
        [self saveVideo];
    }
}

//保存视频
-(void)saveVideo{
    NSString *url = nil;
    for (int i = 0; i < self.videoDatas.count; ++i) {
        TYVideoModel *model = self.videoDatas[i];
        url = [NSString stringWithFormat:@"%@%@",PhotoUrl,model.dha];
    }
    
    XMPlayerManager *playerManager = [[XMPlayerManager alloc] init];
    playerManager.videoURL = [NSURL URLWithString:url];  // 当前的视频URL
    [playerManager saveImage];
}


//保存图片
-(void)savePhoto{
    NSMutableArray *photoArr = [NSMutableArray array];
    for (int i = 0; i < self.imageDatas.count; ++i) {
        TYPhotoModel *model = self.imageDatas[i];
        NSString *url = [NSString stringWithFormat:@"%@%@",PhotoUrl,model.dia];
        [photoArr addObject:url];
    }
    
    [SVProgressHUD showWithStatus:@"正在保存图片..."];
    [PhotosSaveImage SaveImageUrls:photoArr withPhotosName:@"美界联盟" saveingProgress:^(NSInteger receivedSize, NSInteger expectedSize) {
        //        NSLog(@"-->保存到第%ld张", receivedSize);
        [SVProgressHUD showWithStatus:@"正在保存图片..."];
    } compeleteSave:^(PhotosSaveImageTypeMsge saveType) {
        
        switch (saveType) {
            case PhotosSaveImageTypeMsgeSaveNot:
            {
                //全部保存失败");
                [SVProgressHUD showWithStatus:@"保存失败"];
                [SVProgressHUD dismissWithDelay:1.0];
            }
                break;
            case PhotosSaveImageTypeMsgeSucceed:
            {
                //全部保存成功
                [SVProgressHUD showWithStatus:@"保存成功"];
                [SVProgressHUD dismissWithDelay:1.0];
            }
                break;
            case PhotosSaveImageTypeMsgeNotNetwork:
            {
                [SVProgressHUD showWithStatus:@"没有网络"];
                [SVProgressHUD dismissWithDelay:1.0];
            }
                break;
            case PhotosSaveImageTypeMsgePermission:
            {
                [SVProgressHUD showWithStatus:@"没有访问相册的权限"];
                [SVProgressHUD dismissWithDelay:1.0];
            }
                break;
            case PhotosSaveImageTypeMsgeCreatedCollectionNot:
            {
                //                NSLog(@"-->创建相册失败");
            }
                break;
            default:
                break;
        }
    }];
}

@end
