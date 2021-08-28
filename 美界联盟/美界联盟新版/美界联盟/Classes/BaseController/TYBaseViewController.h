//
//  TYBaseViewController.h
//  美界联盟
//
//  Created by LY on 2017/10/23.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYBaseViewController : UIViewController

//添加导航栏返回按钮---传图片名称即可
- (void)addNavigationBackBtn:(NSString *)backImage;
//返回按钮被点击时的动作。
- (void)navigationBackBtnClick:(id)sender;
//设置导航栏标题
- (void)setNavigationBarTitle:(NSString *)title andTitleColor:(UIColor *)color andImage:(NSString *)imageName;
//设置导航栏左边的图标
- (void)setNavigationLeftBtnImage:(NSString *)imageName;
//设置导航栏左边的文字
- (void)setNavigationLeftBtnText:(NSString *)text andColor:(UIColor *)color;
//设置导航栏右边的图标
- (void)setNavigationRightBtnImage:(NSString *)imageName;
//设置导航栏右边的2个图标
- (void)setNavigationRightBtnImage:(NSString *)imageName1 imageName2:(NSString *)imageName2;
//设置导航栏右边的文字
- (void)setNavigationRightBtnText:(NSString *)text andTextColor:(UIColor *)color;
//设置导航栏右边的2组文字
- (void)setNavigationRightBtnText:(NSString *)text1 text2:(NSString *)text2;
//设置导航栏右边的文字和图片
- (void)setNavigationRightBtnText:(NSString *)text image:(NSString *)imageName;
//设置导航栏坐边的文字和图片
- (void)setNavigationLeftBtnText:(NSString *)text image:(NSString *)imageName;
//导航栏左边按钮被按下的触发事件
- (void)navigationLeftBtnClick:(id)sender;
//导航栏右边按钮被按下的触发事件
- (void)navigationRightBtnClick:(UIButton *)btn;

//数据数组，凡是继承此控制器都可用
@property (nonatomic, strong) NSMutableArray *modelArray;

/********搜索显示属性 凡是继承此控制器都可用 *******/
/** 关键字 */
@property (nonatomic, strong) NSString *keyWord;
/** 开始时间 */
@property (nonatomic, strong) NSString *startTime;
/** 结束时间 */
@property (nonatomic, strong) NSString *endTime;
/** 订单来源 */
@property (nonatomic, strong) NSString *ddtype;

//获取当前年-月-日
-(NSString *)YearMonthDay;

@end
