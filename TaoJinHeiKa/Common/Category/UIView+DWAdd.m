//
//  UIView+DWAdd.m
//  TaoJinHeiKa
//
//  Created by wzh-macpro on 2018/10/30.
//  Copyright © 2018年 TaoJinHeiKa. All rights reserved.
//

#import "UIView+DWAdd.h"

@implementation UIView (DWAdd)

+ (void)toastWithMessage:(NSString *)message {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.7]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setCornerRadius:4.f];
    if (message.length != 0) {
        [SVProgressHUD showImage:nil status:[@" " stringByAppendingString:message]];
    }
    [SVProgressHUD setMinimumDismissTimeInterval:2];
}

@end
