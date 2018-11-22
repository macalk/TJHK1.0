//
//  TJHKLogoView.m
//  TaoJinHeiKa
//
//  Created by wzh-macpro on 2018/11/4.
//  Copyright © 2018年 TaoJinHeiKa. All rights reserved.
//

#import "TJHKLogoView.h"

@implementation TJHKLogoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configViews];
    }
    return self;
}

- (void)configViews {
    UIImageView *logo = [[UIImageView alloc] init];
    logo.frame = CGRectMake(20, 0, 71, 18);
    logo.image = TJHKImage(@"icon_loan_logo");
    [self addSubview:logo];
    
    UILabel *logoDesView = [[UILabel alloc] init];
    logoDesView.frame = CGRectMake(21, logo.bottom+8, ScreenWidth-21*2, 14);
    logoDesView.font = TJHKFont(14);
    logoDesView.textColor = TJHKHexColor(@"#333333");
    logoDesView.text = @"费率低 / 秒到账";
    [self addSubview:logoDesView];
}

@end
