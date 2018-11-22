//
//  TJHKMarketViewController.m
//  TaoJinHeiKa
//
//  Created by wzh-macpro on 2018/10/23.
//  Copyright © 2018年 TaoJinHeiKa. All rights reserved.
//

#import "TJHKMarketViewController.h"
#import "BaseWebViewController.h"

@interface TJHKMarketViewController ()

Strong BaseWebViewController *webVC;

@end

@implementation TJHKMarketViewController

- (BaseWebViewController *)webVC {
    if (!_webVC) {
        _webVC = [[BaseWebViewController alloc] init];
        _webVC.url = [TJHKTool getHTMLWithPath:MarketPage_LoanMarketList_HTMLUrl];
        _webVC.marginTop = StatusBarHeight;
        _webVC.isBindRefresh = YES;
    }
    return _webVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.navigationItem.title = nil;
    
    [self.view addSubview:self.webVC.view];
    [self.webVC didMoveToParentViewController:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLogin) name:LoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLogout) name:LogoutNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configStatusBarDefault];
    [self configNavigationBarHidden];
}

- (void)onLogin {
    
}

- (void)onLogout {
   
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
