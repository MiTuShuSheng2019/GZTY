//
//  TYIWantAppointmentVC.m
//  美界联盟
//
//  Created by LY on 2017/11/24.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYIWantAppointmentVC.h"
#import "TYWantAppointmentTitleView.h"
#import "TYWantAppointmentCell.h"
#import "TYWantAppointmentTwoCell.h"
#import "TYWantAppointmentThirdCell.h"

@interface TYIWantAppointmentVC ()<UITableViewDelegate, UITableViewDataSource, TYWantAppointmentTwoCellDeledate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
/** 标题数组 */
@property (nonatomic, strong) NSArray *titleArr;
/** 选择项目id数组 */
@property (nonatomic, strong) NSMutableArray *idArr;

/** 预约人 */
@property (nonatomic, strong) NSString *peopleStr;
/** 预约电话 */
@property (nonatomic, strong) NSString *phoneStr;
/** 预约人数 */
@property (nonatomic, strong) NSString *peopleNumberStr;
/** 预约时间 */
@property (nonatomic, strong) NSString *timeStr;
/** 备注 */
@property (nonatomic, strong) NSString *RemarkStr;

/** <#注释#> */
@property (nonatomic, strong) UITextView *remarkTextView;
@end

@implementation TYIWantAppointmentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationBackBtn:@"back"];
    [self setNavigationBarTitle:@"我要预约" andTitleColor:[UIColor whiteColor] andImage:nil];
    
    self.titleArr = [NSArray arrayWithObjects:@"", @"预约项目：", @"预约备注：", nil];
    
    [self setUpTableView];
    
    //监听键盘出现和消失
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark 键盘出现
-(void)keyboardWillShow:(NSNotification *)note
{
    
    // 取出键盘最终的frame
    //    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //    self.myTableView.contentInset = UIEdgeInsetsMake(0, 0, rect.size.height, 0);
    //    self.myTableView.contentSize = CGSizeMake(0, -(KScreenHeight - rect.size.height));
    
    
    //    NSDictionary *info = [note userInfo];
    //    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    //
    //    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    //    self.myTableView.scrollEnabled = YES;
    //    self.myTableView.contentInset = contentInsets;
    //    self.myTableView.scrollIndicatorInsets = contentInsets;
    //
    //    CGRect aRect = self.view.frame;
    //    aRect.size.height -= kbSize.height;
    
    //    if (!CGRectContainsPoint(aRect, self.remarkTextView.superview.superview.frame.origin) ) {
    //
    //        CGPoint scrollPoint = CGPointMake(0.0, self.remarkTextView.superview.superview.frame.origin.y -aRect.size.height + 200);
    //
    //        [self.myTableView setContentOffset:scrollPoint animated:YES];
    
    //    }
    
    //新
    //    NSDictionary *userInfo = note.userInfo;
    //    CGFloat duration = [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    //
    //    CGRect keyFrame = [userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    //    CGFloat moveY = keyFrame.origin.y - self.view.frame.size.height - 64;//这个64是我减去的navigationbar加上状态栏20的高度,可以看自己的实际情况决定是否减去;
    //
    //    [UIView animateWithDuration:duration animations:^{
    //        self.myTableView.transform = CGAffineTransformMakeTranslation(0, moveY);
    //    }];
    
}

#pragma mark 键盘消失
-(void)keyboardWillHide:(NSNotification *)note{
    
    //    self.myTableView.transform = CGAffineTransformMakeTranslation(0, 0);
    
}

//初始化TableView
-(void)setUpTableView{
    
    self.myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.myTableView.tableFooterView = [UIView new];
    self.myTableView.showsVerticalScrollIndicator = NO;
}

#pragma mark <UITableViewDelegate, UITableViewDataSource>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 9 * KScreenWidth / 16 + 45 * 4;
    }else if (indexPath.section == 1){
        return 50;
    }else{
        return 150;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return self.contentArr.count;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        TYWantAppointmentCell *cell = [TYWantAppointmentCell CellTableView:self.myTableView];
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.imgStr]] placeholderImage:[UIImage imageNamed:@"image_default_loading"]];
        self.peopleStr = cell.peopleTextField.text;
        self.phoneStr = cell.phoneTextField.text;
        self.peopleNumberStr = cell.peopleNumberTextField.text;
        self.timeStr = cell.timeTextField.text;
        return cell;
    }else if (indexPath.section == 1){
        TYWantAppointmentTwoCell *cell = [TYWantAppointmentTwoCell CellTableView:self.myTableView];
        cell.delegate = self;
        cell.model = self.contentArr[indexPath.row];
        return cell;
    }else{
        TYWantAppointmentThirdCell *cell = [TYWantAppointmentThirdCell CellTableView:self.myTableView];
        self.RemarkStr = cell.RemarkTextView.text;
        self.remarkTextView = cell.RemarkTextView;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.titleArr.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    static NSString *identifyHead = @"Hcell";
    TYWantAppointmentTitleView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifyHead];
    if (!headerView) {
        headerView = [[TYWantAppointmentTitleView alloc] initWithReuseIdentifier:identifyHead];
        [headerView setFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    }
    headerView.titleLab.text = self.titleArr[section];
    return headerView;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark -- <TYWantAppointmentTwoCellDeledate>
-(void)ClickChoose:(UIButton *)chooseBtn{
    
    [self.view endEditing:YES];
    chooseBtn.selected = !chooseBtn.selected;
    
    TYWantAppointmentTwoCell *cell = (TYWantAppointmentTwoCell *)[[chooseBtn superview] superview];
    NSIndexPath *path = [self.myTableView indexPathForCell:cell];
    TYServiceModel *model = self.contentArr[path.row];
    NSString *idStr = [NSString stringWithFormat:@"%ld",model.sa];
    
    if (chooseBtn.selected) {
        model.isSelected = YES;
        [self.idArr addObject:idStr];
    }else{
        model.isSelected = NO;
        [self.idArr removeObject:idStr];
    }
}

#pragma mark -- 确定预约
- (IBAction)ClickDeterminedAppointment {
    
    [self.myTableView reloadData];
    
    if (self.peopleStr.length == 0) {
        [TYShowHud showHudErrorWithStatus:@"请填写预约人"];
        return;
    }
    
    if (self.phoneStr.length == 0) {
        [TYShowHud showHudErrorWithStatus:@"请填写预约电话"];
        return;
    }
    
    if (self.peopleNumberStr.length == 0) {
        [TYShowHud showHudErrorWithStatus:@"请填写预约人数"];
        return;
    }
    
    if (self.timeStr.length == 0) {
        [TYShowHud showHudErrorWithStatus:@"请填写预约时间"];
        return;
    }
    
    if (self.idArr.count == 0) {
        [TYShowHud showHudErrorWithStatus:@"请选择项目"];
        return;
    }
    
    [self requestOrderAdd];
}

#pragma mark -- 网路请求
// 82 线下体验 新增预约订单
- (void)requestOrderAdd{
    
    NSString *idStr = [self.idArr componentsJoinedByString:@","];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = [TYLoginModel getSessionID];//回话session
    params[@"b"] = @(self.storID);//体验店主键ID
    params[@"c"] = self.peopleStr;//预约人
    params[@"d"] = self.phoneStr;//手机号码
    params[@"e"] = self.peopleNumberStr;//预约人数
    params[@"f"] = idStr;//服务项目 =服务项目id，逗号分割
    params[@"g"] = self.timeStr;//预约时间
    params[@"h"] = self.RemarkStr;//预约备注
    params[@"i"] = [TYDevice getAPPID];//设备ID
    
    NSString *url = [NSString stringWithFormat:@"%@MAPI/Exp/OrderAdd",APP_REQUEST_URL];
    [TYNetworking postRequestURL:url parameters:params andProgress:^(double progress) {
        
    } withSuccessBlock:^(id respondObject) {
        
        if ([[respondObject objectForKey:@"a"] integerValue] == TYRequestSuccessful) {
            [TYShowHud showHudSucceedWithStatus:@"预约成功等待审核"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [TYShowHud showHudErrorWithStatus:[respondObject objectForKey:@"b"]];
        }
        
    } orFailBlock:^(id error) {
        
    }];
}

#pragma mark -- 懒加载
- (NSMutableArray *) idArr
{
    if (!_idArr) {
        _idArr = [NSMutableArray array];
    }
    return _idArr;
}

@end
