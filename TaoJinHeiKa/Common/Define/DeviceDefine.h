//
//  DeviceDefine.h
//  TaoJinHeiKa
//
//  Created by wzh-macpro on 2018/10/23.
//  Copyright © 2018年 TaoJinHeiKa. All rights reserved.
//

#ifndef DeviceDefine_h
#define DeviceDefine_h


#define AppName             [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
#define BundleID            [[NSBundle mainBundle] bundleIdentifier]
#define AppVersion          [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define AppBuild            [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleVersion"]

#define IS_IOS8             ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES:NO)
#define IS_IOS9             ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0 ? YES:NO)
#define IS_IOS10            ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0 ? YES:NO)
#define IS_IOS11            ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0 ? YES:NO)
#define IS_IOS12            ([[[UIDevice currentDevice] systemVersion] floatValue] >= 12.0 ? YES:NO)

#define ScreenWidth         [UIScreen mainScreen].bounds.size.width
#define ScreenHeight        [UIScreen mainScreen].bounds.size.height
#define StatusBarHeight     [[UIApplication sharedApplication] statusBarFrame].size.height
#define NavigationBarHeight 44
#define TopBarHeight        (StatusBarHeight+NavigationBarHeight)
#define TabBarHeight        (IS_X_SERIES ? 83 : 49)
#define BottomSafeHeight    (IS_X_SERIES ? 34 : 0)

#define SCREEN_MAX_LENGTH   (MAX(ScreenWidth, ScreenHeight))
#define IS_IPHONE           (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5         (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6         (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6_PLUS    (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_X         (IS_IPHONE && [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONE_XS        (IS_IPHONE && [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONE_XS_MAX    (IS_IPHONE && [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPHONE_XR        (IS_IPHONE && [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_X_SERIES         ([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.height == 896)


#endif /* DeviceDefine_h */
