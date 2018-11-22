//
//  KeyChainStore.h
//  TaoJinHeiKa
//
//  Created by wzh-macpro on 2018/11/2.
//  Copyright © 2018年 TaoJinHeiKa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainStore : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)deleteKeyData:(NSString *)service;

@end
