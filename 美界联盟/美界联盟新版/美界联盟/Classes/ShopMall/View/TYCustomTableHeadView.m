//
//  TYCustomTableHeadView.m
//  美界联盟
//
//  Created by LY on 2017/10/24.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYCustomTableHeadView.h"

@implementation TYCustomTableHeadView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addSubViewOffLabel];
    }
    
    return self;
}


-(void)addSubViewOffLabel{
    
    UILabel *sparL = [[UILabel alloc]initWithFrame:CGRectMake(10, 7.5, 3, 15)];
    sparL.backgroundColor = RGB(33, 136, 238);
    [self.contentView addSubview:sparL];
    
    self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(20.0, 5.0, KScreenWidth - 20, 20.0)];
    
    self.titleLab.textColor = [UIColor blackColor];
    
    self.titleLab.font = [UIFont systemFontOfSize:17.0];
    
    self.titleLab.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView addSubview:self.titleLab];
    
    //backLabel分割线
    UILabel *backLabel = [[UILabel alloc] init];
    backLabel.backgroundColor = RGB(222, 222, 222);
    [self.contentView addSubview:backLabel];
    backLabel.frame = CGRectMake(0, 29, KScreenWidth, 1);
}

@end
