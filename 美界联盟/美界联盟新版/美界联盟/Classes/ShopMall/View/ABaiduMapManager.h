//
//  TYBaiduMapManager.h
//  美界APP
//
//  Created by TY-DENG on 17/8/17.
//  Copyright © 2017年 Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
#import "ABuyly.h"

@class ABaiduMapManager;

///通知Delegate
@protocol ABaiduMapManagerDelegate <BMKLocationServiceDelegate>
@optional
-(void) aBaiduMapManagerResultReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error;

@end

@interface ABaiduMapManager : NSObject
@property (nonatomic,strong) BMKLocationService *locationService;
@property (nonatomic,strong) BMKMapView* mapView;
@property (nonatomic,weak) id<ABaiduMapManagerDelegate> aBaiduDelegate;
@property (nonatomic,strong) BMKUserLocation *location;



//初始化地图功能
-(void) addBaiduManager:(AppDelegate *) appDelegate;
//开始定位
-(void) startLocation;
//创建地图
-(void) initMapViewForView:(UIView *)view withFrame:(CGRect) frame mapDelegate:(id <BMKMapViewDelegate>)delegate;
//移除
-(void) destoryMapView;
@end
