//
//  TJHKMineBanksViewController.m
//  TaoJinHeiKa
//
//  Created by wzh-macpro on 2018/11/4.
//  Copyright © 2018年 TaoJinHeiKa. All rights reserved.
//

#import "TJHKMineBanksViewController.h"

@interface TJHKMineBanksViewController ()

@end

@implementation TJHKMineBanksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的银行卡";
    [self showPlaceholderWithImage:@"image_mine_no_banks" text:@"您还没有添加银行卡哦～"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
