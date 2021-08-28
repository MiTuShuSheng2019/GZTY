//
//  TYBaiduMapManager.m
//  美界APP
//
//  Created by TY-DENG on 17/8/17.
//  Copyright © 2017年 Lin. All rights reserved.
//

#import "ABaiduMapManager.h"
#define DF_BaiduMapKey @"Tg8Bn673Y48XvlBhv5tvzrUsRrTFrNUb"



@interface ABaiduMapManager ()<BMKGeneralDelegate,BMKGeoCodeSearchDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate>
{
    CLLocationManager *locationManager;
    BMKPointAnnotation* myAnnotation;//我的位置图标
    NSInteger zoomLevel;
    UIButton *addButton;
    UIButton *subButton;
}

@property (nonatomic, strong) BMKMapManager *mapManager;
@end

@implementation ABaiduMapManager



//初始化地图功能
-(void) addBaiduManager:(AppDelegate *) appDelegate{
     _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:DF_BaiduMapKey  generalDelegate:self];
    if (!ret) {
        [ABuyly buylyExceptionWithName:@"百度地图" reason:@"启动失败" userInfo:nil];
    }
}

//网络请求代理
- (void)onGetNetworkState:(int)iError
{
    if (0 != iError) {
        [ABuyly buylyExceptionWithName:@"百度地图" reason:[NSString stringWithFormat:@"联网失败 【%d】",iError] userInfo:nil];
    }
    
}

//地图授权代理
- (void)onGetPermissionState:(int)iError
{
    if (0 != iError) {
        [ABuyly buylyExceptionWithName:@"百度地图" reason:[NSString stringWithFormat:@"授权失败 【%d】",iError] userInfo:nil];
    }
}

//创建地图
-(void) initMapViewForView:(UIView *)view withFrame:(CGRect) frame mapDelegate:(id <BMKMapViewDelegate>)delegate{
    zoomLevel = 17;
    if (!_mapView) {
        _mapView = DF_NSBoundLoadXib(@"ABaiduMapManager");
        _mapView.delegate = delegate;
        myAnnotation = [[BMKPointAnnotation alloc]init];
        [view addSubview:_mapView];
        addButton = [[UIButton alloc] init];
        subButton = [[UIButton alloc] init];
        
        addButton.backgroundColor = [UIColor whiteColor];
        subButton.backgroundColor = [UIColor whiteColor];
        addButton.titleLabel.font = [UIFont systemFontOfSize:30];
        subButton.titleLabel.font = [UIFont systemFontOfSize:30];
        [addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [subButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [addButton setTitle:@"+" forState:UIControlStateNormal];
        [subButton setTitle:@"-" forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(addButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [subButton addTarget:self action:@selector(subButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [_mapView removeFromSuperview];
    }
    _mapView.frame = frame;
    addButton.frame = CGRectMake(frame.size.width - 44-8, frame.size.height - 88-8, 44, 44);
    subButton.frame = CGRectMake(frame.size.width - 44-8, frame.size.height - 44-8, 44, 44);
    [view addSubview:_mapView];
    [view addSubview:addButton];
    [view addSubview:subButton];
    [self startLocation];
}

-(void) addButtonAction{
    if (zoomLevel<23) {
        zoomLevel++;
    }
    [self loadView:_location];
}
-(void) subButtonAction{
    if (zoomLevel>0) {
        zoomLevel--;
    }
    [self loadView:_location];
}

//开始定位
-(void) startLocation{
    //初始化BMKLocationService
    if (!self.locationService) {
        self.locationService = [[BMKLocationService alloc]init];
        self.locationService.delegate = self;
    }

    [ABaiduMapManager locationServicesEnabled];
    if (_mapView) {
        //删除原来的图标
        [_mapView removeAnnotation:myAnnotation];
    }
    
    //启动LocationService
    [self.locationService startUserLocationService];

}
//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //以下_mapView为BMKMapView对象
    _location = userLocation;
    [self loadView:_location];
    [self.locationService stopUserLocationService];
    if (self.aBaiduDelegate && [self.aBaiduDelegate respondsToSelector:@selector(didUpdateBMKUserLocation:)]) {
        [self.aBaiduDelegate didUpdateBMKUserLocation:_location];
    }
//    [_mapView mapForceRefresh];

}
/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error{
    if (self.aBaiduDelegate && [self.aBaiduDelegate respondsToSelector:@selector(didFailToLocateUserWithError:)]) {
        [self.aBaiduDelegate didFailToLocateUserWithError:error];
    }
}

-(void) loadView:(BMKUserLocation *)userLocation{
    @try{
    CLLocation *loc = userLocation.location;
    CLLocationCoordinate2D coor;
    coor.latitude = loc.coordinate.latitude;
    coor.longitude = loc.coordinate.longitude;
    if (_mapView) {
        myAnnotation.coordinate = coor;
        myAnnotation.title = @"我在这里";
        [_mapView addAnnotation:myAnnotation];
        [_mapView setZoomLevel:zoomLevel]; //精确度
        _mapView.showsUserLocation = YES;//显示定位图层
        _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
        [_mapView updateLocationData:userLocation];
        
    }
    [self addressFromCLLocation:coor];
    }@catch(NSException *e){
        [ABuyly buylyException:e methodName:NSStringFromSelector(_cmd)];
    };
}

-(void) addressFromCLLocation:(CLLocationCoordinate2D )location{
    @try{
    //发起反向地理编码检索
    BMKGeoCodeSearch *searcher =[[BMKGeoCodeSearch alloc]init];
    searcher.delegate = self;
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[
                                                            BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = location;
    [searcher reverseGeoCode:reverseGeoCodeSearchOption];
    }@catch(NSException *e){
        [ABuyly buylyException:e methodName:NSStringFromSelector(_cmd)];
    };

}

//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (self.aBaiduDelegate && [_aBaiduDelegate respondsToSelector:@selector(aBaiduMapManagerResultReverseGeoCodeResult:result:errorCode:)]){
        [self.aBaiduDelegate aBaiduMapManagerResultReverseGeoCodeResult:searcher result:result errorCode:error];
    }
  if (error == BMK_SEARCH_NO_ERROR) {
      [ABuyly buylyExceptionWithName:@"反向地理编码检索" reason:[NSString stringWithFormat:@"接收反向地理编码结果失败 [%d]",error] userInfo:nil];
  }
}


+ (BOOL)locationServicesEnabled {
    if (([CLLocationManager locationServicesEnabled]) && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) ) {
        
//        NSLog(@"手机gps定位已经开启");
        return YES;
    } else {
        [TYShowHud showHudErrorWithStatus:@"您还没有开启GPS功能，无法进行定位"];
        return NO;
    }
}

// Override
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}

//移除
-(void) destoryMapView{
    [self.locationService stopUserLocationService];
    [_mapView removeFromSuperview];
}

@end
