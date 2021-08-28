//
//  TYOfflineNavView.m
//  美界联盟
//
//  Created by ydlmac2 on 2017/10/24.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYOfflineNavView.h"

@interface TYOfflineNavView ()<UITextFieldDelegate>


@property (nonatomic, strong) UIView *navView;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UITextField *searchtextField;

@end
@implementation TYOfflineNavView

+ (instancetype)showNavView
{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGB(32, 135, 238);

        [self setInit];

    }
    return self;
}

- (void)setInit
{
    [self addSubview:self.myShopButton];
    [self addSubview:self.navView];

}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self.myShopButton makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(-4);
        make.right.equalTo(0);
        make.size.equalTo(CGSizeMake(80, 30));
    }];
    [self.navView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(8);
        make.right.equalTo(self.myShopButton.mas_left).offset(-6);
        make.height.equalTo(27);
        make.bottom.equalTo(-4);
    }];
}

- (void)goMyShopVc
{
    [self endEditing:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(ClickMyShop)]) {
        [_delegate ClickMyShop];
    }
}

- (void)searchButtonAction:(UIButton *)sender
{
    [self endEditing:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(ClickSearch:)]) {
        [_delegate ClickSearch:self.searchtextField.text];
    }
}

- (UIButton *)myShopButton
{
    if (!_myShopButton) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"我的体验店" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(goMyShopVc) forControlEvents:UIControlEventTouchUpInside];
        _myShopButton = btn;
    }
    return _myShopButton;
}

- (UIView *)navView
{
    if (!_navView) {
        UIView *nav = [[UIView alloc] init];
        nav.backgroundColor = [UIColor whiteColor];
        nav.layer.masksToBounds = YES;
        nav.layer.cornerRadius = 15;
        [nav addSubview:self.searchButton];
        [self.searchButton makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(-8);
            make.centerY.equalTo(0);
            make.width.equalTo(24);
            make.height.equalTo(24);
        }];
        [nav addSubview:self.searchtextField];
        [self.searchtextField makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(0);
            make.left.equalTo(15);
            make.right.equalTo(self.searchButton.mas_left).offset(0);
        }];
        _navView = nav;
    }
    return _navView;
}

- (UIButton *)searchButton
{
    if (!_searchButton) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"search_block"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(searchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _searchButton = btn;
    }
    return _searchButton;
}

- (UITextField *)searchtextField
{
    if (!_searchtextField) {
        UITextField *field = [[UITextField alloc] init];
        field.placeholder = @"搜索体验店";
        field.font = [UIFont systemFontOfSize:14];
        field.delegate = self;
        field.returnKeyType = UIReturnKeyDone;
        _searchtextField = field;
    }
    return _searchtextField;
}

#pragma mark -- <UITextFieldDelegate>
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (_delegate && [_delegate respondsToSelector:@selector(ClickSearch:)]) {
        [_delegate ClickSearch:self.searchtextField.text];
    }
    //按下Done按钮的调用方法，让键盘消失
    [textField resignFirstResponder];
    return YES;
}

@end
