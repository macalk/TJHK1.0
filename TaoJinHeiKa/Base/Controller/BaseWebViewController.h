//
//  BaseWebViewController.h
//  TaoJinHeiKa
//
//  Created by wzh-macpro on 2018/10/23.
//  Copyright © 2018年 TaoJinHeiKa. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>

@interface ScriptMessageHandler : NSObject <WKScriptMessageHandler>

Weak BaseViewController *webViewController;
Strong NSArray *jsMessageNames;

@end


@interface BaseWebViewController : BaseViewController

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *webTitle;
@property (nonatomic, assign) CGFloat marginTop;
@property (nonatomic, assign) BOOL isBindRefresh;

- (void)loadHtml;
- (void)back;

@end
