//
//  UITextField+DWAdd.h
//  TaoJinHeiKa
//
//  Created by wzh-macpro on 2018/11/1.
//  Copyright © 2018年 TaoJinHeiKa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (DWAdd)

@property (nonatomic, assign) NSUInteger maxLength;
@property (nonatomic, strong) UIFont *placeholderFont;
@property (nonatomic, strong) UIColor *placeholderColor;

@end
