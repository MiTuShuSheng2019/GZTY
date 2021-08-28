//
//  YTRefreshTableViewVC.h
//  SMART1
//
//  Created by LY on 2018/6/14.
//  Copyright © 2018年 Y_T. All rights reserved.
//

#import "BaseTableViewController.h"

@interface YTRefreshTableViewVC : BaseTableViewController

/* 是否加载更多*/
- (void)loadMore:(BOOL)isMore;

// 结束刷新, 子类请求报告，完毕调用
- (void)endHeaderFooterRefreshing;


@end
