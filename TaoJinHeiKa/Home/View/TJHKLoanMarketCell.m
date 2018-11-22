//
//  TJHKLoanMarketCell.m
//  TaoJinHeiKa
//
//  Created by wzh-macpro on 2018/11/4.
//  Copyright © 2018年 TaoJinHeiKa. All rights reserved.
//

#import "TJHKLoanMarketCell.h"

@implementation TJHKLoanMarketModel

@end


@interface TJHKLoanMarketCell ()

Strong UIImageView *imageView;
Strong UILabel *titleLabel;

@end

@implementation TJHKLoanMarketCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configViews];
    }
    return self;
}

- (void)configViews {
    self.imageView = [[UIImageView alloc] init];
    self.imageView.frame = CGRectMake((ScreenWidth/4-52)/2, 0, 52, 52);
    self.imageView.backgroundColor = TJHKHexColor(@"#F9F9F9");
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.cornerRadius = 10.f;
    self.imageView.layer.borderWidth = 1.f;
    self.imageView.layer.borderColor = TJHKHexColor(@"#FFFFFF").CGColor;
    [self.contentView addSubview:self.imageView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.frame = CGRectMake(10, self.imageView.bottom+15, ScreenWidth/4-10*2, 14);
    self.titleLabel.font = TJHKFont(14);
    self.titleLabel.textColor = TJHKHexColor(@"#333333");
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titleLabel];
}

- (void)setModel:(TJHKLoanMarketModel *)model {
    _model = model;
    [self.imageView setImageWithURL:[NSURL URLWithString:model.logo?:@""] placeholder:nil];
    self.titleLabel.text = model.name?:@"";
}

@end
