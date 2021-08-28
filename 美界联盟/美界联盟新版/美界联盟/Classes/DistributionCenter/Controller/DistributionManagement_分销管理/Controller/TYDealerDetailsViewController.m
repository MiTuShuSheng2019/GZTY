//
//  TYDealerDetailsViewController.m
//  美界联盟
//
//  Created by LY on 2017/11/7.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYDealerDetailsViewController.h"
#import "TYDealerDetailsCell.h"

@interface TYDealerDetailsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation TYDealerDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"经销商详情" andTitleColor:[UIColor whiteColor] andImage:nil];
    
    [self setUpTableView];
}

//初始化TableView
-(void)setUpTableView{
    
    self.myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.myTableView.tableFooterView = [UIView new];
    self.myTableView.showsVerticalScrollIndicator = NO;
}

#pragma mark -- <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TYDealerDetailsCell *cell = [TYDealerDetailsCell CellTableView:self.myTableView];
    
    if (indexPath.row == 0) {
        cell.contentLabel.text = [NSString stringWithFormat:@"姓名：%@", [TYValidate IsNotNull:self.model.eb]];
    }else if (indexPath.row == 1){
        cell.contentLabel.text = [NSString stringWithFormat:@"分销商等级：%@", [TYValidate IsNotNull:self.model.ef]];
    }else if (indexPath.row == 2){
        cell.contentLabel.text = [NSString stringWithFormat:@"手机：%@", [TYValidate IsNotNull:self.model.ed]];
    }else if (indexPath.row == 3){
        cell.contentLabel.text = [NSString stringWithFormat:@"微信：%@", [TYValidate IsNotNull:self.model.ec]];
    }else if (indexPath.row == 4){
        cell.contentLabel.text = [NSString stringWithFormat:@"地址：%@", [TYValidate IsNotNull:self.model.eh]];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

@end
