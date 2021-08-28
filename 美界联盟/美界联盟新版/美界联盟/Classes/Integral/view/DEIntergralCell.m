//
//  DEIntergralCell.m
//  美界联盟
//
//  Created by Glory_iMac on 2019/7/29.
//  Copyright © 2019年 刘燚. All rights reserved.
//

#import "DEIntergralCell.h"

@implementation DEIntergralCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    // NSLog(@"cellForRowAtIndexPath");
    static NSString *identifier = @"DEIntergralCell";
    // 1.缓存中取
    DEIntergralCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[DEIntergralCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor=RGB(238, 238, 238);
    for (int i=0; i<5; i++) {
        UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        label.font=[UIFont systemFontOfSize:16.];
        label.hidden=YES;
        label.tag = 100+i;
        label.textAlignment=NSTextAlignmentCenter;
        [self addSubview:label];
    }
}

-(void)setArray:(NSArray *)array
{
    CGFloat width = SCREEN_WIDTH/array.count;
    for (int i=0; i<array.count; i++) {
        UILabel* label=(UILabel*)[self viewWithTag:100+i];
        label.hidden=NO;
        label.text=[NSString stringWithFormat:@"%@",array[i]];
        label.frame=CGRectMake( width*i, 20, width, 16);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
