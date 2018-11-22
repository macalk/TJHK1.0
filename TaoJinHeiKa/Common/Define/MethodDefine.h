//
//  MethodDefine.h
//  TaoJinHeiKa
//
//  Created by wzh-macpro on 2018/10/23.
//  Copyright © 2018年 TaoJinHeiKa. All rights reserved.
//

#ifndef MethodDefine_h
#define MethodDefine_h


#define TJHKImage(name)                  [UIImage imageNamed:name]
#define TJHKString(string, args...)      [NSString stringWithFormat:string, args]
#define TJHKHexColor(string)             [UIColor colorWithHexString:string]
#define TJHKHexColorAlpha(string, value)  [UIColor colorWithHexString:string alpha:value]
#define TJHKFont(size)                   [UIFont systemFontOfSize:size]
#define TJHKBoldFont(size)               [UIFont boldSystemFontOfSize:size]
#define TJHKUrl(string)                  [NSURL URLWithString:string]

#define Strong                         @property (nonatomic, strong)
#define Weak                           @property (nonatomic, weak)
#define Copy                           @property (nonatomic, copy)
#define Assign                         @property (nonatomic, assign)

#define NULLString(string) ((![string isKindOfClass:[NSString class]])||[string isEqualToString:@""] || (string == nil) || [string isEqualToString:@""] || [string isKindOfClass:[NSNull class]]||[[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0 || [string isEqualToString:@"(null)"])


#endif /* MethodDefine_h */
