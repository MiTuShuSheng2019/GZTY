//
//  TYHeader.h
//  美界联盟
//
//  Created by LY on 2017/10/23.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#ifndef TYHeader_h
#define TYHeader_h

#define DF_ScreenSize  [UIScreen mainScreen].bounds.size

//获取屏幕宽度的宏定义
#define KScreenWidth ([UIScreen mainScreen].bounds.size.width)
//获取屏幕高度的宏定义
#define KScreenHeight ([UIScreen mainScreen].bounds.size.height)
// 获得RGB颜色
#define RGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

//压缩图片
#define kAliPicStr_50_50 @"?x-oss-process=image/format,jpg/resize,m_lfit,h_50,w_50"
#define kAliPicStr_100_100 @"?x-oss-process=image/format,jpg/resize,m_lfit,h_100,w_100"
#define kAliPicStr_150_150 @"?x-oss-process=image/format,jpg/resize,m_lfit,h_150,w_150"
#define kAliPicStr_300_300 @"?x-oss-process=image/format,jpg/resize,m_lfit,h_300,w_300"
#define kAliPicStr_500_500 @"?x-oss-process=image/format,jpg/resize,m_lfit,h_500,w_500"
#define aliPic(picStr,aliSize) [NSString stringWithFormat:@"%@%@",picStr,aliSize]
#define aliPicInfo(picStr) [NSString stringWithFormat:@"%@%@",picStr,@"?x-oss-process=image/info"]
#define aliPicQuality(picStr,quality) [NSString stringWithFormat:@"%@?x-oss-process=image/format,jpg/quality,q_%d/auto-orient,0",picStr,quality]

#define aliPicQuality_l(picStr,quality,w) [NSString stringWithFormat:@"%@?x-oss-process=image/format,jpg/quality,q_%d/resize,l_%d/auto-orient,0",picStr,quality,w]


#define SYNTHESIZE_SINGLETON_FOR_HEADER(className) \
+ (className *)shared##className;

#define SYNTHESIZE_SINGLETON_FOR_CLASS(className)\
static className *shared##className = nil;\
+ (className *)shared##className\
{\
@synchronized(self)\
{\
if (shared##className == nil)\
{\
shared##className = [[self alloc] init];\
}\
}\
return shared##className;\
}\
+ (id)allocWithZone:(NSZone *)zone\
{\
@synchronized(self)\
{\
if (shared##className == nil)\
{\
shared##className = [super allocWithZone:zone];\
}\
} \
return shared##className;\
}\
- (id)copyWithZone:(NSZone *)zone\
{\
return self;\
}


#import "TYNavigationViewController.h"
#import "UIView+Extension.h"
#import <MJRefresh.h>
#import <MJExtension.h>
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>
#import <SDWebImageManager.h>
#import <SDCycleScrollView.h>
#import <SVProgressHUD.h>
#import <WXApi.h>
#import <WXApiObject.h>
#import <UITableView+FDTemplateLayoutCell.h>
#import "TYNetworking.h"
#import "TYSingleton.h"
#import "SDReleaseButton.h"
#import "LoadManager.h"
//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND
//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

#import "Masonry.h"

#import "UIImageView+LYExtension.h"
#import "UIImage+LYExtension.h"
#import "TYShareView.h"
#import "TYLoginModel.h"
#import "TYConsumerLoginModel.h"
#import "TYVersion.h"
#import "TYScrollTitleViewController.h"
#import "UIView+CFFrame.h"
#import "CFPopOverView.h"
#import "CreateCode.h"
#import "TYValidate.h"
#import "LTPickerView.h"
#import "NSArray+CP.h"
#import "SDPhotoBrowser.h"
#import "QLCLabel.h"
#import "PPNumberButton.h"
#import "TYGlobalSearchView.h"
#import "PhotosSaveImage.h"
#import "ABaiduMapManager.h"
#import "TYcommentGradeView.h"
#import "TYDevice.h"
#import "TYBootPageView.h"
#import "TYShowHud.h"
#import "TYAlertAction.h"
#import "UITableView+LY.h"
#import "UICollectionView+LY.h"
#import "ABuyly.h"

#import "UIView+Extension.h"

#import <XGPush.h>

#endif /* TYHeader_h */
