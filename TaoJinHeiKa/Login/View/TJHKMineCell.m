//
//  TJHKMineCell.m
//  TaoJinHeiKa
//
//  Created by wzh-macpro on 2018/11/1.
//  Copyright © 2018年 TaoJinHeiKa. All rights reserved.
//

#import "TJHKMineCell.h"

@interface TJHKMineCell ()

Strong UIImageView *iconView;
Strong UILabel *titleView;
Strong UIImageView *nextView;
Strong UIView *line;

@end

@implementation TJHKMineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configViews];
    }
    return self;
}

- (void)configViews {
    self.iconView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.iconView];
    
    self.titleView = [[UILabel alloc] init];
    self.titleView.font = TJHKFont(15);
    self.titleView.textColor = TJHKHexColor(@"#333333");
    [self.contentView addSubview:self.titleView];

    self.nextView = [[UIImageView alloc] init];
    self.nextView.image = TJHKImage(@"icon_mine_cell_next");
    [self.contentView addSubview:self.nextView];
    
    self.line = [[UIView alloc] init];
    self.line.backgroundColor = Line_Color;
    [self.contentView addSubview:self.line];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.iconView.frame = CGRectMake(16, (self.height-20)/2, 20, 20);
    self.titleView.frame = CGRectMake(self.iconView.right+11, 0, self.width-16*2-11*2-20-8, self.height);
    self.nextView.frame = CGRectMake(self.titleView.right+11, (self.height-15)/2, 8, 15);
    self.line.frame = CGRectMake(41, self.bottom-1/[UIScreen mainScreen].scale, self.width-41-16, 1/[UIScreen mainScreen].scale);
}

- (void)setIcon:(NSString *)icon title:(NSString *)title {
    self.iconView.image = TJHKImage(icon);
    self.titleView.text = !NULLString(title)?title:@"";
}

- (void)hideLine:(BOOL)isHidden {
    self.line.hidden = isHidden;
}

@end
