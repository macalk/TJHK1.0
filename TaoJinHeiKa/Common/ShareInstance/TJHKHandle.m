//
//  TJHKHandle.m
//  TaoJinHeiKa
//
//  Created by wzh-macpro on 2018/10/23.
//  Copyright © 2018年 TaoJinHeiKa. All rights reserved.
//

#import "TJHKHandle.h"

@implementation TJHKHandle

+ (instancetype)shareHandle {
    static TJHKHandle *handle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handle = [[TJHKHandle alloc] init];
    });
    return handle;
}

@end
