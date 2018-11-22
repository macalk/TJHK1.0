//
//  TJHKHandle.h
//  TaoJinHeiKa
//
//  Created by wzh-macpro on 2018/10/23.
//  Copyright © 2018年 TaoJinHeiKa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJHKHandle : NSObject

+ (instancetype)shareHandle;

Assign BOOL isMarket; // YES.贷超模式 NO.申请模式（默认申请模式）
Assign BOOL isShowApplyMarket; // 是否显示申请模式下的贷超

Assign BOOL isLogin;
Strong NSString *userId;
Strong NSString *userName;
Strong NSString *phone;

@end
