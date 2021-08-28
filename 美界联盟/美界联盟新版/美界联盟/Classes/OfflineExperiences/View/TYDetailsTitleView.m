//
//  TYDetailsTitleView.m
//  美界联盟
//
//  Created by LY on 2017/11/23.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYDetailsTitleView.h"

@implementation TYDetailsTitleView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addSubViewOffLabel];
    }
    
    return self;
}


-(void)addSubViewOffLabel{
    
    UILabel *sparL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 10)];
    sparL.backgroundColor = RGB(238, 238, 238);
    [self.contentView addSubview:sparL];
    
    self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, KScreenWidth - 40, 20.0)];
    
    self.titleLab.textColor = [UIColor blackColor];
    
    self.titleLab.font = [UIFont systemFontOfSize:17.0];
    
    self.titleLab.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView addSubview:self.titleLab];
    
    //backLabel分割线
    UILabel *backLabel = [[UILabel alloc] init];
    backLabel.backgroundColor = RGB(238, 238, 238);
    [self.contentView addSubview:backLabel];
    backLabel.frame = CGRectMake(0, 49, KScreenWidth, 1);
}

@end
