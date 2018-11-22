//
//  TJHKPreLauchViewController.m
//  TaoJinHeiKa
//
//  Created by wzh-macpro on 2018/11/4.
//  Copyright © 2018年 TaoJinHeiKa. All rights reserved.
//

#import "TJHKPreLauchViewController.h"

@interface TJHKPreLauchViewController ()

@end

@implementation TJHKPreLauchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *lauchView = [[UIImageView alloc] init];
    lauchView.frame = self.view.bounds;
    [self.view addSubview:lauchView];
    
    if (IS_IPHONE_4_OR_LESS) {
        lauchView.image = [UIImage imageNamed:@"3.5"];
    }
    else if (IS_IPHONE_5) {
        lauchView.image = [UIImage imageNamed:@"4.0"];
    }
    else if (IS_IPHONE_6) {
        lauchView.image = [UIImage imageNamed:@"4.7"];
    }
    else if (IS_IPHONE_6_PLUS) {
        lauchView.image = [UIImage imageNamed:@"5.5"];
    }
    else if (IS_IPHONE_X) {
        lauchView.image = [UIImage imageNamed:@"5.8"];
    }
    else {
        lauchView.image = [UIImage imageNamed:@"5.8"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
