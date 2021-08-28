//
//  SchoolViewController.h
//  美界联盟
//
//  Created by LY on 2017/11/18.
//  Copyright © 2017年 刘燚. All rights reserved.
//

#import "TYBaseViewController.h"
#import "TYCategoryModel.h"

@interface SchoolViewController : TYBaseViewController

@property (nonatomic, strong) TYCategoryModel *model;
/** 二级类别id */
@property (nonatomic, assign) NSInteger categoryID;


@end
