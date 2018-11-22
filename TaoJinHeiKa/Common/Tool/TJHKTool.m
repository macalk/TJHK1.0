//
//  TJHKTool.m
//  TaoJinHeiKa
//
//  Created by wzh-macpro on 2018/10/23.
//  Copyright © 2018年 TaoJinHeiKa. All rights reserved.
//

#import "TJHKTool.h"
#import "BaseWebViewController.h"
#import "BaseNavigationController.h"

@implementation TJHKTool

+ (UIViewController *)getViewController {
    UITabBarController *tabBarController = (UITabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    if (tabBarController && [tabBarController isKindOfClass:[UITabBarController class]]) {
        UINavigationController *navigationController = (UINavigationController *)tabBarController.selectedViewController;
        if (navigationController && [navigationController isKindOfClass:[UINavigationController class]]) {
            UIViewController *controller = navigationController.visibleViewController;
            return controller;
        }
    }
    return [UIApplication sharedApplication].delegate.window.rootViewController;
}

+ (void)jumpLogin {
    [self jumpLoginWithSuccessBlock:nil];
}

+ (void)jumpLoginWithSuccessBlock:(LoginSuccessBlock)successBlock {
    if ([TJHKHandle shareHandle].isLogin) {
        return;
    }
    UIViewController *controller = [self getViewController];
    if ([controller isKindOfClass:[TJHKLoginViewController class]]) {
        return;
    }
    TJHKLoginViewController *loginVC = [[TJHKLoginViewController alloc] initWithSuccessBlock:successBlock];
    BaseNavigationController *navVC = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
    [controller.navigationController presentViewController:navVC animated:YES completion:nil];
}

+ (void)jumpWebWithUrl:(NSString *)url {
    BaseWebViewController *webVC = [[BaseWebViewController alloc] init];
    webVC.url = url;
    [[self getViewController].navigationController pushViewController:webVC animated:YES];
}

+ (NSString *)getHTMLWithPath:(NSString *)path {
    if (![path containsString:@"?"]) {
        path = [path stringByAppendingString:@"?"];
    }
    NSString *htmlUrl = [BaseHTMLUrl stringByAppendingString:path];
    return htmlUrl;
}

+ (CGFloat)getTextWidthWithText:(NSString *)text font:(UIFont *)font {
    return [self getTextWidthWithText:text font:font wordSpace:-1];
}

+ (CGFloat)getTextHeightWithText:(NSString *)text font:(UIFont *)font width:(CGFloat)width {
    return [self getTextHeightWithText:text font:font wordSpace:-1 lineSpace:-1 width:width];
}

+ (CGFloat)getTextWidthWithText:(NSString *)text font:(UIFont *)font wordSpace:(CGFloat)wordSpace {
    NSDictionary *dic = @{NSFontAttributeName:font};
    if (wordSpace >= 0) {
        dic = @{NSKernAttributeName:@(wordSpace), NSFontAttributeName:font};
    }
    CGFloat width = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, font.lineHeight) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size.width;
    return width;
}

+ (CGFloat)getTextHeightWithText:(NSString *)text font:(UIFont *)font lineSpace:(CGFloat)lineSpace width:(CGFloat)width {
    return [self getTextHeightWithText:text font:font wordSpace:-1 lineSpace:lineSpace width:width];
}

+ (CGFloat)getTextHeightWithText:(NSString *)text font:(UIFont *)font wordSpace:(CGFloat)wordSpace lineSpace:(CGFloat)lineSpace width:(CGFloat)width {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;
    NSDictionary *dic = @{NSFontAttributeName:font};
    if (wordSpace >= 0) {
        dic = @{NSKernAttributeName:@(wordSpace), NSFontAttributeName:font};
    }
    else if (lineSpace >= 0) {
        dic = @{NSParagraphStyleAttributeName:paragraphStyle, NSFontAttributeName:font};
    }
    else if (wordSpace >= 0 && lineSpace >= 0) {
        dic = @{NSParagraphStyleAttributeName:paragraphStyle, NSKernAttributeName:@(wordSpace), NSFontAttributeName:font};
    }
    CGFloat height = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size.height;
    return height;
}

+ (NSMutableAttributedString *)getText:(NSString *)text font:(UIFont *)font lineSpace:(CGFloat)lineSpace {
    return [self getText:text font:font wordSpace:-1 lineSpace:lineSpace];
}

+ (NSMutableAttributedString *)getText:(NSString *)text font:(UIFont *)font wordSpace:(CGFloat)wordSpace lineSpace:(CGFloat)lineSpace {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;
    NSDictionary *dic = @{NSParagraphStyleAttributeName:paragraphStyle, NSFontAttributeName:font};
    if (wordSpace >= 0) {
        dic = @{NSParagraphStyleAttributeName:paragraphStyle, NSKernAttributeName:@(wordSpace), NSFontAttributeName:font};
    }
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text attributes:dic];
    return string;
}

+ (NSString *)getFixPhone:(NSString *)phone {
    if (phone.length == 11) {
        phone = [phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    return phone;
}

+ (NSString *)getUUID {
    NSString * strUUID = (NSString *)[KeyChainStore load:UUID_CacheKey];
    if ([strUUID isEqualToString:@""] || !strUUID) {
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        CFRelease(uuidRef);
        [KeyChainStore save:UUID_CacheKey data:strUUID];
    }
    return strUUID;
}

+ (NSString *)getTime:(NSInteger)seconds {
    NSString *str_hour = [NSString stringWithFormat:@"%02zd", seconds/3600];
    NSString *str_minute = [NSString stringWithFormat:@"%02zd", (seconds%3600)/60];
    NSString *str_second = [NSString stringWithFormat:@"%02zd", seconds%60];
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@", str_hour, str_minute, str_second];
    return format_time;
}

+ (NSString *)dictionaryToJsonString:(NSDictionary *)dic {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        return nil;
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
