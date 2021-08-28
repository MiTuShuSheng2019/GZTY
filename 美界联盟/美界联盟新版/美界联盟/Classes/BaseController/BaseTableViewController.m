//
//  BaseTableViewController.m
//  SMART1
//
//  Created by LY on 2018/6/19.
//  Copyright © 2018年 Y_T. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@property (nonatomic, assign) UITableViewStyle tableViewStyle;

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    [self setupBaseTableViewUI];
}

//- (void)setupBaseTableViewUI
//{
//    self.tableView.backgroundColor = self.view.backgroundColor;
//    
//    if ([self.parentViewController isKindOfClass:[UINavigationController class]]) {
//        UIEdgeInsets contentInset = self.tableView.contentInset;
//        contentInset.top += self.navigationController.navigationBar.height;
//        self.tableView.contentInset = contentInset;
//    }
//}

#pragma mark - scrollDeleggate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    UIEdgeInsets contentInset = self.tableView.contentInset;
    contentInset.bottom -= self.tableView.mj_footer.size.height;
    self.tableView.scrollIndicatorInsets = contentInset;
    [self.view endEditing:YES];
}

#pragma mark - TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UITableViewCell new];
}

- (UITableView *)tableView
{
    if(_tableView == nil)
    {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:self.tableViewStyle];
        [self.view addSubview:tableView];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        //        tableView.tableFooterView = [UIView new];
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        tableView.showsVerticalScrollIndicator = NO;
        
        _tableView = tableView;
    }
    return _tableView;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    if (self = [super init]) {
        _tableViewStyle = style;
    }
    return self;
}


@end
