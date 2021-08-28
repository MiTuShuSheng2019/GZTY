//
//  BaseTableViewController.h
//  SMART1
//
//  Created by LY on 2018/6/19.
//  Copyright © 2018年 Y_T. All rights reserved.
//

#import "TYBaseViewController.h"

@interface BaseTableViewController : TYBaseViewController<UITableViewDelegate, UITableViewDataSource>

// 这个代理方法如果子类实现了, 必须调用super
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView NS_REQUIRES_SUPER;

@property (weak, nonatomic) UITableView *tableView;

// tableview的样式, 默认plain
- (instancetype)initWithStyle:(UITableViewStyle)style;

@end
