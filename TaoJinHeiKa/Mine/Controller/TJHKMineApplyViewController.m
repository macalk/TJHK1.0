//
//  TJHKMineApplyViewController.m
//  TaoJinHeiKa
//
//  Created by wzh-macpro on 2018/11/4.
//  Copyright © 2018年 TaoJinHeiKa. All rights reserved.
//

#import "TJHKMineApplyViewController.h"

@interface TJHKMineApplyViewController ()

@end

@implementation TJHKMineApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的申请";
    [self showPlaceholderWithImage:@"image_mine_no_apply" text:@"暂无申请哦～"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
