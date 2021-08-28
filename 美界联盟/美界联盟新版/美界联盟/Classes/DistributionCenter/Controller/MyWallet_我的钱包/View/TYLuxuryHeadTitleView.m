//
//  TYLuxuryHeadTitleView.m
//  美界联盟
//
//  Created by LY on 2017/11/6.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYLuxuryHeadTitleView.h"

@implementation TYLuxuryHeadTitleView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addSubViewOffLabel];
    }
    
    return self;
}


-(void)addSubViewOffLabel{
    
    UILabel *sparL = [[UILabel alloc]initWithFrame:CGRectMake(10, 13, 3, 15)];
    sparL.backgroundColor = RGB(32, 135, 238);
    [self.contentView addSubview:sparL];
    
    self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, KScreenWidth - 40, 20)];
    
    self.titleLab.textColor = [UIColor grayColor];
    
    self.titleLab.font = [UIFont systemFontOfSize:15.0];
    
    self.titleLab.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView addSubview:self.titleLab];
    
    
    //backLabel相当于分割线
    UILabel *backLabel = [[UILabel alloc] init];
    backLabel.frame = CGRectMake(0, 39, KScreenWidth, 1);
    backLabel.backgroundColor = RGB(238, 239, 240);
    [self.contentView  addSubview:backLabel];
    
}


@end
