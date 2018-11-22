//
//  TJHKTool.h
//  TaoJinHeiKa
//
//  Created by wzh-macpro on 2018/10/23.
//  Copyright © 2018年 TaoJinHeiKa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TJHKLoginViewController.h"

@interface TJHKTool : NSObject

+ (UIViewController *)getViewController;

+ (void)jumpLogin;

+ (void)jumpLoginWithSuccessBlock:(LoginSuccessBlock)successBlock;

+ (void)jumpWebWithUrl:(NSString *)url;

+ (NSString *)getHTMLWithPath:(NSString *)path;

+ (CGFloat)getTextWidthWithText:(NSString *)text font:(UIFont *)font;

+ (CGFloat)getTextHeightWithText:(NSString *)text font:(UIFont *)font width:(CGFloat)width;

+ (CGFloat)getTextWidthWithText:(NSString *)text font:(UIFont *)font wordSpace:(CGFloat)wordSpace;

+ (CGFloat)getTextHeightWithText:(NSString *)text font:(UIFont *)font lineSpace:(CGFloat)lineSpace width:(CGFloat)width;

+ (CGFloat)getTextHeightWithText:(NSString *)text font:(UIFont *)font wordSpace:(CGFloat)wordSpace lineSpace:(CGFloat)lineSpace width:(CGFloat)width;

+ (NSMutableAttributedString *)getText:(NSString *)text font:(UIFont *)font lineSpace:(CGFloat)lineSpace;

+ (NSMutableAttributedString *)getText:(NSString *)text font:(UIFont *)font wordSpace:(CGFloat)wordSpace lineSpace:(CGFloat)lineSpace;

+ (NSString *)getFixPhone:(NSString *)phone;

+ (NSString *)getUUID;

+ (NSString *)getTime:(NSInteger)seconds;

+ (NSString *)dictionaryToJsonString:(NSDictionary *)dic;

@end
