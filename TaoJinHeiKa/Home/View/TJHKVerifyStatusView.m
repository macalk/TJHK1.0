//
//  TJHKVerifyStatusView.m
//  TaoJinHeiKa
//
//  Created by wzh-macpro on 2018/11/4.
//  Copyright © 2018年 TaoJinHeiKa. All rights reserved.
//

#import "TJHKVerifyStatusView.h"

@interface TJHKVerifyStatusView ()

Strong UIImageView *imageView;
Strong UILabel *titleLabel;
Strong UILabel *subTitleLabel;

@end

@implementation TJHKVerifyStatusView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configViews];
    }
    return self;
}

- (void)configViews {
    self.imageView = [[UIImageView alloc] init];
    self.imageView.frame = CGRectMake(0, 0, VerifyStatus_Height, VerifyStatus_Height);
    [self addSubview:self.imageView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.frame = CGRectMake(self.imageView.right+16, 10, VerifyStatus_Width-VerifyStatus_Height-16, 21);
    self.titleLabel.font = TJHKFont(21);
    self.titleLabel.textColor = TJHKHexColor(@"#333333");
    [self addSubview:self.titleLabel];
    
    self.subTitleLabel = [[UILabel alloc] init];
    self.subTitleLabel.frame = CGRectMake(self.imageView.right+16, self.titleLabel.bottom+10, VerifyStatus_Width-VerifyStatus_Height-16, 12);
    self.subTitleLabel.font = TJHKFont(12);
    self.subTitleLabel.textColor = TJHKHexColor(@"#999999");
    [self addSubview:self.subTitleLabel];
}

- (void)setStatus:(LoanStatus)status {
    if (status == LoanStatus_Auditing) {
        self.imageView.image = TJHKImage(@"icon_loan_auditing");
        self.titleLabel.text = @"订单审核中";
        self.subTitleLabel.text = @"订单已受理，请耐心等待...";
    }
    else if (status == LoanStatus_Fail) {
        self.imageView.image = TJHKImage(@"icon_loan_fail");
        self.titleLabel.text = @"审核未通过";
        self.subTitleLabel.text = [TJHKHandle shareHandle].isShowApplyMarket ? @"更多借款请查看以下推荐" : @"审核未通过，请下次再试";
    }
}

@end
