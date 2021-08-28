//
//  TYScrollTitleViewController.h
//  美界联盟
//
//  Created by LY on 2017/10/23.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYBaseViewController.h"

@interface TYScrollTitleViewController : TYBaseViewController

-(instancetype)initWithViewControllerArray:(NSMutableArray *)ViewControllerArray withTitleArray:(NSMutableArray *)titleArray SelectNum:(NSInteger)selectNum;

/** 类网易新闻移动栏目; */
@property (nonatomic, strong) UIScrollView *scrollView;

@end
