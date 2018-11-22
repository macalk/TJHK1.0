//
//  TJHKAboutUsViewController.m
//  TaoJinHeiKa
//
//  Created by wzh-macpro on 2018/11/4.
//  Copyright © 2018年 TaoJinHeiKa. All rights reserved.
//

#import "TJHKAboutUsViewController.h"

@interface TJHKAboutUsViewController ()

Strong UIImageView *qrcodeView;
Strong UILabel *tipLbael;

@end

@implementation TJHKAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"关于淘金钱包";
    [self configViews];
}

- (void)configViews {
    UIImageView *bottomView = [[UIImageView alloc] init];
    bottomView.frame = CGRectMake(0, ScreenHeight-300-StatusBarHeight-NavigationBarHeight, ScreenWidth, 300);
    bottomView.contentMode = UIViewContentModeScaleAspectFill;
    bottomView.clipsToBounds = YES;
    bottomView.image = TJHKImage(@"image_mine_bottom");
    [self.view addSubview:bottomView];
    
    self.qrcodeView = [[UIImageView alloc] init];
    self.qrcodeView.frame = CGRectMake((ScreenWidth-130)/2, 88, 130, 130);
    [self.view addSubview:self.qrcodeView];
    [self.qrcodeView setImageWithURL:[NSURL URLWithString:@"http://image.vip-black.com/wechat/TJKQRCODE.jpg"] placeholder:nil];
    
    self.tipLbael = [[UILabel alloc] init];
    self.tipLbael.frame = CGRectMake(0, self.qrcodeView.bottom+21, ScreenWidth, 36);
    self.tipLbael.font = TJHKFont(15);
    self.tipLbael.textColor = TJHKHexColor(@"#333333");
    self.tipLbael.textAlignment = NSTextAlignmentCenter;
    self.tipLbael.numberOfLines = 2;
    [self.view addSubview:self.tipLbael];
    self.tipLbael.text = @"欢迎关注微信\r带你解锁拿钱新姿势";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
