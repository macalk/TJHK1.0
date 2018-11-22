//
//  BaseViewController.m
//  TaoJinHeiKa
//
//  Created by wzh-macpro on 2018/10/23.
//  Copyright © 2018年 TaoJinHeiKa. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

Strong UIView *noDataView;
Strong UIImageView *placeholderImage;
Strong UILabel *placeholderLabel;

@end

@implementation BaseViewController

- (UIImageView *)placeholderImage {
    if (!_placeholderImage) {
        _placeholderImage = [[UIImageView alloc] init];
        _placeholderImage.contentMode = UIViewContentModeScaleAspectFill;
        _placeholderImage.clipsToBounds = YES;
        _placeholderImage.frame = CGRectMake(0, 100, ScreenWidth, 105);
    }
    return _placeholderImage;
}

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.font = TJHKFont(14);
        _placeholderLabel.textColor = TJHKHexColor(@"#999999");
        _placeholderLabel.textAlignment = NSTextAlignmentCenter;
        _placeholderLabel.frame = CGRectMake(0, 228, ScreenWidth, 14);
    }
    return _placeholderLabel;
}

- (UIView *)noDataView {
    if (!_noDataView) {
        _noDataView = [[UIView alloc] init];
        _noDataView.backgroundColor = Back_Color;
        _noDataView.frame = self.view.bounds;
    }
    return _noDataView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Back_Color;
    [self configDefaultLeftBarButton];
    [self configNavigationBarTitleWithColor:Nav_Color_Dark];
    [self configNavigationBarImage:[UIImage imageWithColor:TJHKHexColor(@"#FFFFFF")]];
    [self configNavigationBarShadow:[UIImage imageWithColor:TJHKHexColor(@"#F3F3F3") size:CGSizeMake(ScreenWidth, 1/[UIScreen mainScreen].scale)]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configStatusBarDefault];
    [self configNavigationBarShow];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)configStatusBarDefault {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

- (void)configStatusBarLight {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

- (void)configNavigationBarHidden {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)configNavigationBarShow {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)configNavigationBarImage:(UIImage *)image {
    [self configNavigationBarShow];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}

- (void)configNavigationBarShadow:(UIImage *)image {
    [self configNavigationBarShow];
    [self.navigationController.navigationBar setShadowImage:image];
}

- (void)configNavigationBarTitleWithColor:(UIColor *)color {
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:color, NSFontAttributeName:TJHKFont(18)}];
}

- (void)configDefaultLeftBarButton {
    if (self.navigationController.viewControllers && [self.navigationController.viewControllers firstObject] != self) {
        [self configLeftBarButtonWithImage:@"nav_back_dark" Title:nil];
    }
}

- (void)configLeftBarButtonWithImage:(NSString *)image Title:(NSString *)title {
    NSMutableArray *buttonItems = [NSMutableArray array];
    if (!NULLString(image)) {
        UIImage *btnImage = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:btnImage style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonAciton)];
        [buttonItems addObject:item];
    }
    else if (!NULLString(title)) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonAciton)];
        [buttonItems addObject:item];
    }
    self.navigationItem.leftBarButtonItems = buttonItems;
}

- (void)configRightBarButtonWithImage:(NSString *)image Title:(NSString *)title {
    NSMutableArray *buttonItems = [NSMutableArray array];
    if (!NULLString(image)) {
        UIImage *btnImage = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:btnImage style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonAciton)];
        [buttonItems addObject:item];
    }
    else if (!NULLString(title)) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonAciton)];
        [buttonItems addObject:item];
    }
    self.navigationItem.rightBarButtonItems = buttonItems;
}

- (void)leftBarButtonAciton {
    if (self.navigationController) {
        if (self.navigationController.viewControllers.count > 1) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)rightBarButtonAciton {
    
}

// X系列适配
- (void)appendTailWithColor:(UIColor *)color {
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, self.view.height-BottomSafeHeight, self.view.width, BottomSafeHeight);
    view.backgroundColor = color;
    [self.view addSubview:view];
}

- (void)showPlaceholderWithImage:(NSString *)image text:(NSString *)text {
    [self hidePlaceholder];
    [self.view addSubview:self.noDataView];
    [self.noDataView addSubview:self.placeholderImage];
    [self.noDataView addSubview:self.placeholderLabel];
    self.placeholderImage.image = TJHKImage(image);
    self.placeholderLabel.text = text;
}

- (void)hidePlaceholder {
    [self.noDataView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
