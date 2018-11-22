//
//  TJHKMineViewController.m
//  TaoJinHeiKa
//
//  Created by wzh-macpro on 2018/10/23.
//  Copyright © 2018年 TaoJinHeiKa. All rights reserved.
//

#import "TJHKMineViewController.h"
#import "TJHKMineCell.h"
#import "TJHKMineApplyViewController.h"
#import "TJHKMineBanksViewController.h"
#import "TJHKAboutUsViewController.h"
#import "TJHKSetupViewController.h"

#define Mine_Header_Height (TopBarHeight+233)
#define Mine_Header_Back_Height (TopBarHeight+196)
#define Mine_Header_Bar_Height 90

@interface TJHKMineViewController ()

Strong UIView *headerView;
Strong UIButton *portraitBtn;
Strong UILabel *nickLabel;
Strong UIButton *verifyBtn;
Strong UIView *topBar;
Strong UIView *tableView;
Strong UIImageView *bottomLogo;

@end

@implementation TJHKMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.navigationItem.title = nil;
    self.view.backgroundColor = TJHKHexColor(@"#F9F9F9");
    
    [self configViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLogin) name:LoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLogout) name:LogoutNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configStatusBarLight];
    [self configNavigationBarHidden];
}

- (void)configViews {
    self.headerView = [[UIView alloc] init];
    self.headerView.frame = CGRectMake(0, 0, ScreenWidth, Mine_Header_Height);
    [self.view addSubview:self.headerView];
    
    UIImageView *headerBackView = [[UIImageView alloc] init];
    headerBackView.frame = CGRectMake(0, 0, self.headerView.width, Mine_Header_Back_Height);
    headerBackView.image = TJHKImage(@"image_mine_header");
    [self.headerView addSubview:headerBackView];
    
    self.portraitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.portraitBtn.frame = CGRectMake((self.headerView.width-68)/2, TopBarHeight-10, 68, 68);
    [self.portraitBtn addTarget:self action:@selector(onPortraitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:self.portraitBtn];
    [self.portraitBtn setImageWithURL:TJHKUrl(@"") forState:UIControlStateNormal placeholder:TJHKImage(@"icon_mine_portrait")];
    
    self.nickLabel = [[UILabel alloc] init];
    self.nickLabel.font = TJHKBoldFont(22);
    self.nickLabel.textColor = TJHKHexColor(@"#FFFFFF");
    self.nickLabel.textAlignment = NSTextAlignmentCenter;
    self.nickLabel.frame = CGRectMake(10, self.portraitBtn.bottom+14, headerBackView.width-10*2, 22);
    [headerBackView addSubview:self.nickLabel];
    self.nickLabel.text = [TJHKHandle shareHandle].userName?:@"";
    
    self.verifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.verifyBtn.frame = CGRectMake((headerBackView.width-92)/2, self.nickLabel.bottom+12, 92, 17);
    self.verifyBtn.titleLabel.font = TJHKFont(12);
    [self.verifyBtn setTitleColor:TJHKHexColor(@"#605244") forState:UIControlStateNormal];
    [self.verifyBtn setTitle:@"  认证拿钱" forState:UIControlStateNormal];
    [self.verifyBtn setImage:TJHKImage(@"icon_mine_verify") forState:UIControlStateNormal];
    [self.verifyBtn setBackgroundImage:TJHKImage(@"image_mine_verify_back") forState:UIControlStateNormal];
    self.verifyBtn.layer.cornerRadius = 17/2;
    self.verifyBtn.layer.masksToBounds = YES;
    [headerBackView addSubview:self.verifyBtn];
    
    self.topBar = [[UIView alloc] init];
    self.topBar.frame = CGRectMake(10, self.headerView.height-Mine_Header_Bar_Height, ScreenWidth-10*2, Mine_Header_Bar_Height);
    self.topBar.backgroundColor = TJHKHexColor(@"#FFFFFF");
    self.topBar.layer.cornerRadius = 10.f;
    self.topBar.layer.masksToBounds = YES;
    self.topBar.layer.shadowColor = TJHKHexColorAlpha(@"#666666", 0.05f).CGColor;
    self.topBar.layer.shadowOpacity = 1;
    self.topBar.layer.shadowRadius = 9;
    self.topBar.layer.shadowOffset = CGSizeMake(0,1);
    [self.headerView addSubview:self.topBar];
    
    UIButton *myApplyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    myApplyBtn.frame = CGRectMake(29, (self.topBar.height-45)/2, self.topBar.width/2-29, 45);
    myApplyBtn.titleLabel.font = TJHKFont(15);
    myApplyBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [myApplyBtn setTitleColor:TJHKHexColor(@"#333333") forState:UIControlStateNormal];
    [myApplyBtn setImage:TJHKImage(@"icon_mine_apply") forState:UIControlStateNormal];
    [myApplyBtn setTitle:@"我的申请" forState:UIControlStateNormal];
    myApplyBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, myApplyBtn.width-45);
    CGFloat myApplyBtnTextWidth = [TJHKTool getTextWidthWithText:myApplyBtn.titleLabel.text font:myApplyBtn.titleLabel.font];
    myApplyBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, myApplyBtn.width-45-11-myApplyBtnTextWidth);
    [myApplyBtn addTarget:self action:@selector(onMyApplyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.topBar addSubview:myApplyBtn];
    
    UIButton *myBanksBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    myBanksBtn.frame = CGRectMake(self.topBar.width/2, (self.topBar.height-45)/2, self.topBar.width/2-29, 45);
    myBanksBtn.titleLabel.font = TJHKFont(15);
    [myBanksBtn setTitleColor:TJHKHexColor(@"#333333") forState:UIControlStateNormal];
    [myBanksBtn setImage:TJHKImage(@"icon_mine_banks") forState:UIControlStateNormal];
    [myBanksBtn setTitle:@"我的银行卡" forState:UIControlStateNormal];
    myBanksBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, myBanksBtn.width-45);
    CGFloat myBanksBtnTextWidth = [TJHKTool getTextWidthWithText:myBanksBtn.titleLabel.text font:myBanksBtn.titleLabel.font];
    myBanksBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, myBanksBtn.width-45-11-myBanksBtnTextWidth);
    [myBanksBtn addTarget:self action:@selector(onMyBanksBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.topBar addSubview:myBanksBtn];
    
    self.tableView = [[UIView alloc] init];
    self.tableView.frame = CGRectMake(10, self.headerView.bottom+10, ScreenWidth-10*2, 120);
    self.tableView.backgroundColor = TJHKHexColor(@"#FFFFFF");
    self.tableView.layer.cornerRadius = 10.f;
    self.tableView.layer.masksToBounds = YES;
    self.tableView.layer.shadowColor = TJHKHexColorAlpha(@"#666666", 0.05f).CGColor;
    self.tableView.layer.shadowOpacity = 1;
    self.tableView.layer.shadowRadius = 9;
    self.tableView.layer.shadowOffset = CGSizeMake(0,1);
    [self.view addSubview:self.tableView];
    
    TJHKMineCell *aboutUsCell = [[TJHKMineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    aboutUsCell.frame = CGRectMake(0, 0, self.tableView.width, 60);
    [aboutUsCell setIcon:@"icon_mine_about_us" title:@"关于淘金钱包"];
    aboutUsCell.userInteractionEnabled = YES;
    [aboutUsCell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAboutUsJump)]];
    [self.tableView addSubview:aboutUsCell];
    
    TJHKMineCell *setupCell = [[TJHKMineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    setupCell.frame = CGRectMake(0, 60, self.tableView.width, 60);
    [setupCell setIcon:@"icon_mine_setup" title:@"设置中心"];
    [setupCell hideLine:YES];
    setupCell.userInteractionEnabled = YES;
    [setupCell addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSetupJump)]];
    [self.tableView addSubview:setupCell];
    
    self.bottomLogo = [[UIImageView alloc] init];
    self.bottomLogo.frame = CGRectMake((ScreenWidth-125)/2, ScreenHeight-TabBarHeight-25-40, 125, 40);
    self.bottomLogo.image = TJHKImage(@"icon_mine_bottom_logo");
    [self.view addSubview:self.bottomLogo];
}

- (void)onPortraitBtnClick:(UIButton *)btn {
    
}

- (void)onMyApplyBtnClick:(UIButton *)btn {
    if (![TJHKHandle shareHandle].isLogin) {
        [TJHKTool jumpLogin];
        return;
    }
    TJHKMineApplyViewController *vc = [[TJHKMineApplyViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onMyBanksBtnClick:(UIButton *)btn {
    if (![TJHKHandle shareHandle].isLogin) {
        [TJHKTool jumpLogin];
        return;
    }
    TJHKMineBanksViewController *vc = [[TJHKMineBanksViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onAboutUsJump {
    TJHKAboutUsViewController *vc = [[TJHKAboutUsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onSetupJump {
    if (![TJHKHandle shareHandle].isLogin) {
        [TJHKTool jumpLogin];
        return;
    }
    TJHKSetupViewController *vc = [[TJHKSetupViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onLogin {
    [self.portraitBtn setImageWithURL:TJHKUrl(@"") forState:UIControlStateNormal placeholder:TJHKImage(@"icon_mine_portrait")];
    self.nickLabel.text = [TJHKHandle shareHandle].userName?:@"";
}

- (void)onLogout {
    [self.portraitBtn setImageWithURL:TJHKUrl(@"") forState:UIControlStateNormal placeholder:TJHKImage(@"icon_mine_portrait")];
    self.nickLabel.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
