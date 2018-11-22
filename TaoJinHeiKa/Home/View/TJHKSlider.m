//
//  TJHKSlider.m
//  TaoJinHeiKa
//
//  Created by wzh-macpro on 2018/11/10.
//  Copyright © 2018年 TaoJinHeiKa. All rights reserved.
//

#import "TJHKSlider.h"

@implementation TJHKSlider

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
    CGRect tempRect = rect;
    tempRect.origin.x = rect.origin.x-10;
    tempRect.size.width = rect.size.width+20;
    return CGRectInset([super thumbRectForBounds:bounds trackRect:tempRect value:value], 10, 10);
}

@end
