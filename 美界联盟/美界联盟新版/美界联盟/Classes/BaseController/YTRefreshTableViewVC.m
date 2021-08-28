//
//  YTRefreshTableViewVC.m
//  SMART1
//
//  Created by LY on 2018/6/14.
//  Copyright © 2018年 Y_T. All rights reserved.
//

#import "YTRefreshTableViewVC.h"

@interface YTRefreshTableViewVC ()

@end

@implementation YTRefreshTableViewVC
- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(&*self)weakself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadIsMore:NO];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakself loadIsMore:YES];
    }];
    [self.tableView.mj_header beginRefreshing];
}


// 内部方法
- (void)loadIsMore:(BOOL)isMore
{
    // 控制只能下拉或者上拉
    if (isMore) {
        ![self.tableView.mj_header isRefreshing] ?: [self.tableView.mj_header endRefreshing];
    }else{
        ![self.tableView.mj_footer isRefreshing] ?: [self.tableView.mj_footer endRefreshing];
    }
    [self loadMore:isMore];
}


// 结束刷新
- (void)endHeaderFooterRefreshing
{
    //    NSLog(@"tableview----------------endHeaderFooterRefreshing");
    // 结束刷新状态
    ![self.tableView.mj_header isRefreshing] ?: [self.tableView.mj_header endRefreshing];
    ![self.tableView.mj_footer isRefreshing] ?: [self.tableView.mj_footer endRefreshing];
    [self.tableView reloadData];
}

// 子类需要调用调用
- (void)loadMore:(BOOL)isMore
{
    //        NSAssert(0, @"子类必须重载%s", __FUNCTION__);
}

#pragma mark - TableView 占位图
- (UIImage *)xy_noDataViewImage {
    return [UIImage imageNamed:@"icon_expression wrong"];
}

- (NSString *)xy_noDataViewMessage {
    return @"暂无相关数据";
}

- (UIColor *)xy_noDataViewMessageColor {
    return [UIColor grayColor];
}

@end
