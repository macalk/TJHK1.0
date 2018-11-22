//
//  BaseNavigationBar.m
//  TaoJinHeiKa
//
//  Created by wzh-macpro on 2018/11/1.
//  Copyright © 2018年 TaoJinHeiKa. All rights reserved.
//

#import "BaseNavigationBar.h"

@implementation BaseNavigationBar

- (void)layoutSubviews {
    [super layoutSubviews];

    for (UIView *view in self.subviews) {
        if (@available(iOS 11.0, *)) {
            if ([view isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
                CGRect frame = view.frame;
                frame.size.height = 64;
                if (IS_X_SERIES) {
                    frame.origin.y = 24;
                }
                view.frame = frame;
            }
            if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarContentView")]) {
                CGRect frame = view.frame;
                frame.origin.y = 20;
                if (IS_X_SERIES) {
                    frame.origin.y = 44;
                }
                view.frame = frame;
            }
        }
    }
}

@end
