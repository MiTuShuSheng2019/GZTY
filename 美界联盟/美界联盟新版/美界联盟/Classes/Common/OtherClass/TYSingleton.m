//
//  TYSingleton.m
//  美界APP
//
//  Created by LY on 2017/10/18.
//  Copyright © 2017年 Lin. All rights reserved.
//

#import "TYSingleton.h"

@implementation TYSingleton

static id _singleton = nil;

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    if (_singleton == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _singleton = [super allocWithZone:zone];
        });
    }
    return _singleton;
}

-(instancetype)init{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singleton = [super init];
    });
    return _singleton;
}

-(id)copyWithZone:(NSZone *)zone{
    return _singleton;
}

- (id)mutableCopyWithZone:(nullable NSZone *)zone{
    return _singleton;
}

+(instancetype)shareSingleton{
    return [[self alloc] init];
}

@end
