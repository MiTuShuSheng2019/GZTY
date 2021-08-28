//
//  TYChooseSharePlatformView.m
//  美界联盟
//
//  Created by LY on 2017/11/7.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYChooseSharePlatformView.h"
#import "TYSharePlatformCell.h"

@interface TYChooseSharePlatformView()<UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
/** 图片数组 */
@property (nonatomic, strong) NSArray *imgArr;
/** 标题数组 */
@property (nonatomic, strong) NSArray *titleArr;

@end

@implementation TYChooseSharePlatformView

+(instancetype)CreatTYChooseSharePlatformView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}


-(void)awakeFromNib{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    self.backgroundColor = [RGB(0, 0, 0) colorWithAlphaComponent:0.5];
    self.userInteractionEnabled = YES;
    
    self.imgArr = [NSArray arrayWithObjects:@"weixin_chat", @"friends_circle", @"copy_link", nil];
    self.titleArr = [NSArray arrayWithObjects:@"微信", @"微信朋友圈", @"复制链接", nil];
    
    //注册
    [self.myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([TYSharePlatformCell class]) bundle:nil] forCellWithReuseIdentifier:@"TYSharePlatformCell"];
    self.myCollectionView.alwaysBounceVertical = NO;
    self.myCollectionView.showsVerticalScrollIndicator = NO;
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancleView)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}

#pragma mark -- <UIGestureRecognizerDelegate>
//实现此代理是为了防止点击弹框区域视图也消失
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isDescendantOfView:self.backView]) {
        return NO;
    }
    return YES;
}

-(void) cancleView{
    [self removeFromSuperview];
}

#pragma mark -- <UICollectionViewDelegate, UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imgArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TYSharePlatformCell *cell = [self.myCollectionView dequeueReusableCellWithReuseIdentifier:@"TYSharePlatformCell" forIndexPath:indexPath];
    cell.iconImageView.image = [UIImage imageNamed:self.imgArr[indexPath.row]];
    cell.nameLabel.text = self.titleArr[indexPath.row];
    return cell;
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//定义每个UICollectionView ,横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

//纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((KScreenWidth - 2 * 20)/3, 90);
}

//点击UICollectionView
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.title.length == 0) {
        self.title = @"美界联盟";
    }
    if (self.descri.length == 0) {
        self.descri = @"来自美界联盟-授权分享";
    }
    if (indexPath.row == 0) {
        [self sendLinkContent:WXSceneSession title:self.title descrip:self.descri link:self.shareLink image:nil];
    }else if (indexPath.row == 1){
        [self sendLinkContent:WXSceneTimeline title:self.title descrip:self.descri link:self.shareLink image:nil];
    }else{
        UIPasteboard *pas = [UIPasteboard generalPasteboard];
        [pas setString:self.shareLink];
        if (pas ==nil) {
            [TYShowHud showHudErrorWithStatus:@"复制失败"];
        }else{
            [TYShowHud showHudSucceedWithStatus:@"复制成功"];
        }
    }
    [self removeFromSuperview];
    
}
#pragma mark 微信分享
- (void) sendLinkContent:(enum WXScene )scene title:(NSString *)title descrip:(NSString *)des link:(NSString *)link image:(UIImage *)image
{
    @try{
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = title;
        message.description = des;
        if (!image) {
            image = [UIImage imageNamed:@"app_logo.png"];
        }
        [message setThumbImage:image];
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = link;
        message.mediaObject = ext;
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = scene;
        [WXApi sendReq:req];
    }@catch(NSException *e){
        [ABuyly buylyException:e code:10];
    }
    [self removeFromSuperview];
}

#pragma mark -- 取消分享
- (IBAction)canceShare {
    [self removeFromSuperview];
}

@end
