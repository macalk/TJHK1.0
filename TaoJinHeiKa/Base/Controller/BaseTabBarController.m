//
//  BaseTabBarController.m
//  TaoJinHeiKa
//
//  Created by wzh-macpro on 2018/10/23.
//  Copyright © 2018年 TaoJinHeiKa. All rights reserved.
//

#import "BaseTabBarController.h"
#import "BaseNavigationController.h"
#import "TJHKLoanViewController.h"
#import "TJHKHomeViewController.h"
#import "TJHKMarketViewController.h"
#import "TJHKMineViewController.h"

@interface BaseTabBarController () <UITabBarControllerDelegate>

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.tabBar.translucent = NO;
    [self.tabBar setBackgroundImage:[UIImage imageWithColor:TJHKHexColor(@"#FFFFFF")]];
    [self.tabBar setShadowImage:[UIImage imageWithColor:TJHKHexColor(@"#F3F3F3") size:CGSizeMake(ScreenWidth, 1/[UIScreen mainScreen].scale)]];
    self.delegate = self;
    [self configTabBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [self animateTabBarButton];
}

- (void)configTabBar {
    if (![TJHKHandle shareHandle].isMarket) {
        TJHKHomeViewController *loanVC = [[TJHKHomeViewController alloc] init];
        BaseNavigationController *loanNavVC = [[BaseNavigationController alloc] initWithRootViewController:loanVC];
        loanNavVC.tabBarItem.title = @"首页";
        loanNavVC.tabBarItem.image = [TJHKImage(@"tab_home_normal") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        loanNavVC.tabBarItem.selectedImage = [TJHKImage(@"tab_home_selected") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [loanNavVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:Tab_Color_Normal} forState:UIControlStateNormal];
        [loanNavVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:Tab_Color_Selected} forState:UIControlStateSelected];
        [self addChildViewController:loanNavVC];
        
    } else {
        
        TJHKLoanViewController *loanVC = [[TJHKLoanViewController alloc] init];
        BaseNavigationController *loanNavVC = [[BaseNavigationController alloc] initWithRootViewController:loanVC];
        loanNavVC.tabBarItem.title = @"借款";
        loanNavVC.tabBarItem.image = [TJHKImage(@"tab_loan_normal") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        loanNavVC.tabBarItem.selectedImage = [TJHKImage(@"tab_loan_selected") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [loanNavVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:Tab_Color_Normal} forState:UIControlStateNormal];
        [loanNavVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:Tab_Color_Selected} forState:UIControlStateSelected];
        [self addChildViewController:loanNavVC];
        
        TJHKMarketViewController *marketVC = [[TJHKMarketViewController alloc] init];
        BaseNavigationController *marketNavVC = [[BaseNavigationController alloc] initWithRootViewController:marketVC];
        marketNavVC.tabBarItem.title = @"拿钱";
        marketNavVC.tabBarItem.image = [TJHKImage(@"tab_market_normal") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        marketNavVC.tabBarItem.selectedImage = [TJHKImage(@"tab_market_selected") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [marketNavVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:Tab_Color_Normal} forState:UIControlStateNormal];
        [marketNavVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:Tab_Color_Selected} forState:UIControlStateSelected];
        [self addChildViewController:marketNavVC];
    }
    
    TJHKMineViewController *mineVC = [[TJHKMineViewController alloc] init];
    BaseNavigationController *mineNavVC = [[BaseNavigationController alloc] initWithRootViewController:mineVC];
    mineNavVC.tabBarItem.title = @"我的";
    mineNavVC.tabBarItem.image = [TJHKImage(@"tab_mine_normal") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mineNavVC.tabBarItem.selectedImage = [TJHKImage(@"tab_mine_selected") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [mineNavVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:Tab_Color_Normal} forState:UIControlStateNormal];
    [mineNavVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:Tab_Color_Selected} forState:UIControlStateSelected];
    [self addChildViewController:mineNavVC];
}

- (void)animateTabBarButton {
    NSMutableArray *tabBarButtons = [[NSMutableArray alloc]initWithCapacity:0];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]){
            [tabBarButtons addObject:tabBarButton];
        }
    }
    UIControl *tabBarButton = [tabBarButtons objectAtIndex:self.selectedIndex];
    for (UIView *imageView in tabBarButton.subviews) {
        if ([imageView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
            animation.keyPath = @"transform.scale";
            animation.values = @[@1.0,@1.1,@0.9,@1.0];
            animation.duration = 0.3;
            animation.calculationMode = kCAAnimationCubic;
            [imageView.layer addAnimation:animation forKey:nil];
            break;
        }
    }
}

@end
