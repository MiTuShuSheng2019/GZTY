//
//  TYCircleFriendVC.m
//  美界联盟
//
//  Created by LY on 2017/11/16.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYCircleFriendVC.h"
#import "MLTransition.h"
#import "TYCircleFriendPhotoCell.h"
#import "TYMakConListModel.h"

@interface TYCircleFriendVC ()<UITableViewDelegate,UITableViewDataSource, TYCircleFriendPhotoCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
/** 分页 */
@property (nonatomic, assign) NSInteger page;
/** 请求的条数 */
@property (nonatomic, assign) NSInteger limit;


@end

static NSString *identify = @"TYCircleFriendPhotoCell";

@implementation TYCircleFriendVC


- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"朋友圈推广" andTitleColor:[UIColor whiteColor] andImage:nil];
    
    self.view.disableMLTransition = YES;
    self.myTableView.fd_debugLogEnabled = YES;
    [self.myTableView registerNib:[UINib nibWithNibName:identify bundle:nil] forCellReuseIdentifier:identify];
    
    [self setUpTableView];

}

//初始化TableView
-(void)setUpTableView{
    self.limit = 15;
    __weak typeof(&*self)weakSelf = self;
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf.modelArray removeAllObjects];
        [weakSelf requestGetMakConList];
    }];
    
    self.myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestGetMakConList];
    }];
    
    self.myTableView.mj_footer.hidden = YES;
    [self.myTableView.mj_header beginRefreshing];
    self.myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.myTableView.tableFooterView = [UIView new];
    self.myTableView.showsVerticalScrollIndicator = NO;
}

#pragma mark -- <UITableViewDelegate, UITableViewDataSource>
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TYCircleFriendPhotoCell *cell = [TYCircleFriendPhotoCell CellTableView:self.myTableView];
    cell.delegate = self;
   [self configCell:cell indexpath:indexPath];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [tableView fd_heightForCellWithIdentifier:identify cacheByIndexPath:indexPath configuration:^(TYCircleFriendPhotoCell *cell) {
        [self configCell:cell indexpath:indexPath];
    }];
}

- (void)configCell:(TYCircleFriendPhotoCell *)cell indexpath:(NSIndexPath *)indexpath{
    __weak typeof(cell)weakCell = cell;
    TYMakConListModel *model = self.modelArray[indexpath.row];
    // headerImage 头像 实现渐隐效果
    [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoUrl,model.dc]] placeholderImage:[UIImage imageNamed:@"image_default_loading"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    
        if (image && cacheType == SDImageCacheTypeNone)
        {
            weakCell.headerImageView.alpha = 0;
            [UIView animateWithDuration:0.8 animations:^{
                weakCell.headerImageView.alpha = 1.0f;
            }];
        }else{
            weakCell.headerImageView.alpha = 1.0f;
        }
    }];
    
    // name 名字
    cell.nameLabel.text = model.de;
    
    // description 描述 根据配置在数据源的是否展开字段确定行数
    cell.desLabel.text = model.df;
    
    cell.isExpand = model.isExpand;
    
    if (model.isExpand){
        cell.desLabel.numberOfLines = 0;
        [cell.showAllDetailsButton setTitle:@"收起" forState:UIControlStateNormal];
    }else{
        cell.desLabel.numberOfLines = 5;
        [cell.showAllDetailsButton setTitle:@"全文" forState:UIControlStateNormal];
    }
    
    // 全文label 根据文字的高度是否展示全文lable  点击事件通过数据源来交互
    CGSize rec = [model.df boundingRectWithSize:CGSizeMake(KScreenWidth - 80, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:14]} context:nil].size;
    
    if (rec.height > 100) {
        cell.showAllDetailsButton.hidden = NO;
        cell.showAllHeight.constant = 25;
    }else{
        cell.showAllHeight.constant = 0;
        cell.showAllDetailsButton.hidden = YES;
    }
    
    // img  九宫格图片，用collectionView做
    cell.imageDatas = [[NSMutableArray alloc] initWithArray:model.di];
    cell.videoDatas = [[NSMutableArray alloc] initWithArray:model.dh];
    [cell.collectionView reloadData];
    
    CGFloat width = KScreenWidth - 70 - 20;
    // 没图片就高度为0 （约束是可以拖出来的哦）
    if ([NSArray isEmpty:model.di])
    {        
        if ([NSArray isEmpty:model.dh]) {
            cell.colletionViewHeight.constant = 0;
            cell.saveButton.hidden = YES;
        }else{
            cell.colletionViewHeight.constant = width / 1.5;//此时显示为视频
            cell.saveButton.hidden = NO;
            [cell.saveButton setTitle:@"保存视频" forState:UIControlStateNormal];
        }
        
    }else{
        cell.saveButton.hidden = NO;
        [cell.saveButton setTitle:@"保存图片" forState:UIControlStateNormal];
        if (model.di.count == 1){
            cell.colletionViewHeight.constant = width / 1.5;
        }else{
            cell.colletionViewHeight.constant = ((model.di.count - 1) / 3 + 1) * (width / 3) + (model.di.count - 1) / 3 * 15;
        }
    }
    cell.timeLabel.text = model.dj;
}

#pragma mark -- cell的代理--<TYCircleFriendPhotoCellDelegate>
#pragma mark - 1.点击代理全文展开回调
- (void)clickShowAllDetails:(TYCircleFriendPhotoCell *)cell expand:(BOOL)isExpand{
    
    NSIndexPath *clickIndexPath = [self.myTableView indexPathForCell:cell];
    
    TYMakConListModel *model = self.modelArray[clickIndexPath.row];
    model.isExpand = isExpand;
    
//    [self.myTableView reloadData];
    
    //刷新当前的cell
    [self.myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:clickIndexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - TableView 占位图
- (UIImage *)xy_noDataViewImage {
    return [UIImage imageNamed:@"no_data"];
}

- (NSString *)xy_noDataViewMessage {
    return @"抱歉，暂无相关数据";
}

- (UIColor *)xy_noDataViewMessageColor {
    return RGB(170, 170, 170);
}

#pragma mark --- 网络请求
//111 创客 获取内容明细
-(void)requestGetMakConList{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = @(-1);//三级类别 -1全部
    params[@"c"] = @(self.page);//分页index
    params[@"d"] = @(self.limit);//分页size
    params[@"e"] = @(3);//二级类别
    
    NSString *url = [NSString stringWithFormat:@"%@MAPI/mcus/GetMakConList",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            
            NSArray *arr = [TYMakConListModel mj_objectArrayWithKeyValuesArray:[[respondObject objectForKey:@"c"] objectForKey:@"d"]];
            [self.modelArray addObjectsFromArray:arr];
            
            self.page = self.page + 1;
            if (arr.count == self.limit) {
                self.myTableView.mj_footer.hidden = NO;
            }else{
                self.myTableView.mj_footer.hidden = YES;
            }
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
        [self.myTableView reloadData];
        
    } orFailBlock:^(id error) {
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
    }];
}

@end
