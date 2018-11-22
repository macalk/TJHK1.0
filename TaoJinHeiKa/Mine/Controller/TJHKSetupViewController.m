//
//  TJHKSetupViewController.m
//  TaoJinHeiKa
//
//  Created by wzh-macpro on 2018/11/4.
//  Copyright © 2018年 TaoJinHeiKa. All rights reserved.
//

#import "TJHKSetupViewController.h"

@interface TJHKSetupViewController ()

@end

@implementation TJHKSetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = TJHKHexColor(@"#F9F9F9");
    self.navigationItem.title = @"设置中心";
    [self configViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configNavigationBarShadow:[UIImage new]];
}

- (void)configViews {
    UIView *versionView = [[UIView alloc] init];
    versionView.frame = CGRectMake(0, 9, ScreenWidth, 50);
    versionView.backgroundColor = TJHKHexColor(@"#FFFFFF");
    [self.view addSubview:versionView];
    
    UILabel *versionTitleView = [[UILabel alloc] init];
    versionTitleView.frame = CGRectMake(17, 0, (ScreenWidth-17*2)/2, 50);
    versionTitleView.font = TJHKFont(15);
    versionTitleView.textColor = TJHKHexColor(@"#333333");
    versionTitleView.text = @"当前版本";
    [versionView addSubview:versionTitleView];
    
    UILabel *versionNumView = [[UILabel alloc] init];
    versionNumView.frame = CGRectMake(ScreenWidth-17-(ScreenWidth-17*2)/2, 0, (ScreenWidth-17*2)/2, 50);
    versionNumView.font = TJHKFont(14);
    versionNumView.textColor = TJHKHexColor(@"#999999");
    versionNumView.textAlignment = NSTextAlignmentRight;
    versionNumView.text = TJHKString(@"%@", AppVersion);
    [versionView addSubview:versionNumView];
    
    UIView *logoutView = [[UIView alloc] init];
    logoutView.frame = CGRectMake(0, versionView.bottom+21, ScreenWidth, 55);
    logoutView.backgroundColor = TJHKHexColor(@"#FFFFFF");
    [self.view addSubview:logoutView];
    
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutBtn.frame = CGRectMake((ScreenWidth-80)/2, 0, 80, 55);
    logoutBtn.titleLabel.font = TJHKFont(19);
    [logoutBtn setTitle:@"安全退出" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:TJHKHexColor(@"#F73434") forState:UIControlStateNormal];
    [logoutBtn addTarget:self action:@selector(onLogoutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [logoutView addSubview:logoutBtn];
}

- (void)onLogoutBtnClick:(UIButton *)btn {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserData_CacheKey];
    [TJHKHandle shareHandle].isLogin = NO;
    [TJHKHandle shareHandle].userId = nil;
    [TJHKHandle shareHandle].userName = nil;
    [TJHKHandle shareHandle].phone = nil;
    [TJHKTool jumpLoginWithSuccessBlock:^{
        [self.navigationController popToRootViewControllerAnimated:NO];
        UITabBarController *tabBarController = (UITabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
        if (tabBarController) {
            tabBarController.selectedIndex = 0;
        }
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:LogoutNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
