//
//  DEIntegralMallModel.m
//  美界联盟
//
//  Created by Glory_iMac on 2019/9/12.
//  Copyright © 2019 刘燚. All rights reserved.
//

#import "DEIntegralMallModel.h"

@implementation DEIntegralMallModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
