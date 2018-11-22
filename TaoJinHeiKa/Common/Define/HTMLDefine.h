//
//  HTMLDefine.h
//  TaoJinHeiKa
//
//  Created by wzh-macpro on 2018/10/23.
//  Copyright © 2018年 TaoJinHeiKa. All rights reserved.
//

#ifndef HTMLDefine_h
#define HTMLDefine_h

#ifdef DEBUG

static NSString * const BaseHTMLUrl = @"http://static.vip-black.com";

#else

static NSString * const BaseHTMLUrl = @"http://static.vip-black.com";

#endif


static NSString * const RegisterProtocol_HTMLUrl = @"/register/protocol.html";
static NSString * const LoanPage_LoanMarketList_HTMLUrl = @"/app/index.html";
static NSString * const MarketPage_LoanMarketList_HTMLUrl = @"/app/list.html";

#endif /* HTMLDefine_h */
