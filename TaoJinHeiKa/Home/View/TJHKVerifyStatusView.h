//
//  TJHKVerifyStatusView.h
//  TaoJinHeiKa
//
//  Created by wzh-macpro on 2018/11/4.
//  Copyright © 2018年 TaoJinHeiKa. All rights reserved.
//

#import <UIKit/UIKit.h>

#define VerifyStatus_Width 225
#define VerifyStatus_Height 61

typedef NS_ENUM(NSUInteger, LoanStatus) {
    LoanStatus_Normal,
    LoanStatus_Auditing,
    LoanStatus_Fail,
};

@interface TJHKVerifyStatusView : UIView

Assign LoanStatus status;

@end
