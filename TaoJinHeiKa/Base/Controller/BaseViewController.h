//
//  BaseViewController.h
//  TaoJinHeiKa
//
//  Created by wzh-macpro on 2018/10/23.
//  Copyright © 2018年 TaoJinHeiKa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void)configStatusBarDefault;
- (void)configStatusBarLight;
- (void)configNavigationBarHidden;
- (void)configNavigationBarShow;
- (void)configNavigationBarImage:(UIImage *)image;
- (void)configNavigationBarShadow:(UIImage *)image;
- (void)configNavigationBarTitleWithColor:(UIColor *)color;
- (void)configLeftBarButtonWithImage:(NSString *)image Title:(NSString *)title;
- (void)configRightBarButtonWithImage:(NSString *)image Title:(NSString *)title;
- (void)leftBarButtonAciton;
- (void)rightBarButtonAciton;
- (void)appendTailWithColor:(UIColor *)color;
- (void)showPlaceholderWithImage:(NSString *)image text:(NSString *)text;
- (void)hidePlaceholder;

@end
