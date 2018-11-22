//
//  TJHKLoginViewController.m
//  TaoJinHeiKa
//
//  Created by wzh-macpro on 2018/10/23.
//  Copyright © 2018年 TaoJinHeiKa. All rights reserved.
//

#import "TJHKLoginViewController.h"

@interface TJHKLoginViewController ()

Strong UITextField *phoneInput;
Strong UITextField *codeInput;
Strong UIButton *sendSMSBtn;
Strong UIButton *loginBtn;
Assign BOOL hasPhoneInput;
Assign BOOL hasCodeInput;
Strong dispatch_source_t timer;
Assign NSInteger time;
Copy LoginSuccessBlock successBlock;

@end

@implementation TJHKLoginViewController

- (instancetype)initWithSuccessBlock:(LoginSuccessBlock)successBlock {
    self = [super init];
    if (self) {
        self.successBlock = successBlock;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configDefaultData];
    [self configViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configStatusBarLight];
    [self configNavigationBarHidden];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configDefaultData {
    self.time = 60;
}

- (void)configViews {
    UIImageView *backView = [[UIImageView alloc] init];
    backView.contentMode = UIViewContentModeScaleAspectFill;
    backView.clipsToBounds = YES;
    backView.userInteractionEnabled = YES;
    [self.view addSubview:backView];
    backView.image = TJHKImage(@"image_login_back");
    backView.frame = self.view.bounds;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = TJHKBoldFont(27);
    titleLabel.textColor = TJHKHexColor(@"#FFFFFF");
    [backView addSubview:titleLabel];
    titleLabel.text = @"淘金钱包";
    titleLabel.frame = CGRectMake(29, 99, self.view.width-29*2, 27);
    
    UILabel *subTitleLabel = [[UILabel alloc] init];
    subTitleLabel.font = TJHKFont(22);
    subTitleLabel.textColor = TJHKHexColor(@"#FFFFFF");
    [backView addSubview:subTitleLabel];
    subTitleLabel.text = @"大小额贷 · 值得信赖";
    subTitleLabel.frame = CGRectMake(29, titleLabel.bottom+21, self.view.width-29*2, 22);
    
    UIView *phoneBackView = [[UIView alloc] init];
    phoneBackView.backgroundColor = TJHKHexColorAlpha(@"#FFFFFF", 0.2f);
    phoneBackView.layer.cornerRadius = 55/2;
    phoneBackView.layer.masksToBounds = YES;
    [backView addSubview:phoneBackView];
    CGFloat topMargin = (self.view.height-55*3-15*2)/2;
    phoneBackView.frame = CGRectMake(25, topMargin, self.view.width-25*2, 55);
    
    self.phoneInput = [[UITextField alloc] init];
    self.phoneInput.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneInput.textColor = TJHKHexColor(@"#FFFFFF");
    self.phoneInput.maxLength = 11;
    self.phoneInput.placeholder = @"请输入手机号码";
    self.phoneInput.placeholderFont = TJHKFont(17);
    self.phoneInput.placeholderColor = TJHKHexColorAlpha(@"#FFFFFF", 0.5f);
    [phoneBackView addSubview:self.phoneInput];
    [self.phoneInput addTarget:self action:@selector(onEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    self.phoneInput.frame = CGRectMake(22, 0, phoneBackView.width-22*2-20*2-1-88, phoneBackView.height);
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = TJHKHexColor(@"#FFFFFF");
    [phoneBackView addSubview:line];
    line.frame = CGRectMake(self.phoneInput.right+20, (phoneBackView.height-20)/2, 1, 20);
    
    self.sendSMSBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sendSMSBtn.titleLabel.font = TJHKFont(17);
    [self.sendSMSBtn setTitleColor:TJHKHexColorAlpha(@"#FFFFFF", 0.5f) forState:UIControlStateDisabled];
    [self.sendSMSBtn setTitleColor:TJHKHexColor(@"#FFFFFF") forState:UIControlStateNormal];
    [phoneBackView addSubview:self.sendSMSBtn];
    [self.sendSMSBtn addTarget:self action:@selector(onSendSMSBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.sendSMSBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    self.sendSMSBtn.enabled = NO;
    self.sendSMSBtn.frame = CGRectMake(line.right+20, 0, 88, phoneBackView.height);
    
    UIView *codeBackView = [[UIView alloc] init];
    codeBackView.backgroundColor = TJHKHexColorAlpha(@"#FFFFFF", 0.2f);
    codeBackView.layer.cornerRadius = 55/2;
    codeBackView.layer.masksToBounds = YES;
    [backView addSubview:codeBackView];
    codeBackView.frame = CGRectMake(25, phoneBackView.bottom+15, self.view.width-25*2, 55);
    
    self.codeInput = [[UITextField alloc] init];
    self.codeInput.keyboardType = UIKeyboardTypeNumberPad;
    self.codeInput.textColor = TJHKHexColor(@"#FFFFFF");
    self.codeInput.maxLength = 4;
    self.codeInput.placeholder = @"请输入短信验证码";
    self.codeInput.placeholderFont = TJHKFont(17);
    self.codeInput.placeholderColor = TJHKHexColorAlpha(@"#FFFFFF", 0.5f);
    [codeBackView addSubview:self.codeInput];
    [self.codeInput addTarget:self action:@selector(onEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    self.codeInput.frame = CGRectMake(22, 0, phoneBackView.width-22*2, codeBackView.height);
    
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginBtn.titleLabel.font = TJHKFont(20);
    [self.loginBtn setTitleColor:TJHKHexColor(@"#666666") forState:UIControlStateDisabled];
    [self.loginBtn setTitleColor:TJHKHexColor(@"#252422") forState:UIControlStateNormal];
    [self.loginBtn setBackgroundImage:[UIImage imageWithColor:TJHKHexColorAlpha(@"#FFFFFF", 0.6f) size:CGSizeMake(self.view.width-25*2, 55)] forState:UIControlStateDisabled];
    [self.loginBtn setBackgroundImage:TJHKImage(@"image_login_btn") forState:UIControlStateNormal];
    self.loginBtn.layer.cornerRadius = 55/2;
    self.loginBtn.layer.masksToBounds = YES;
    [backView addSubview:self.loginBtn];
    [self.loginBtn addTarget:self action:@selector(onLoginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    self.loginBtn.enabled = NO;
    self.loginBtn.frame = CGRectMake(25, codeBackView.bottom+15, self.view.width-25*2, 55);
    
    UIButton *protocolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    protocolBtn.titleLabel.font = TJHKFont(12);
    [protocolBtn setTitleColor:TJHKHexColor(@"#999999") forState:UIControlStateNormal];
    [backView addSubview:protocolBtn];
    [protocolBtn addTarget:self action:@selector(onProtocolBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    NSString *btnStr = @"未注册用户将直接为您注册，《用户服务协议》";
    [protocolBtn setTitle:btnStr forState:UIControlStateNormal];
    CGFloat btnWidth = [TJHKTool getTextWidthWithText:btnStr font:TJHKFont(12)];
    protocolBtn.frame = CGRectMake((self.view.width-btnWidth)/2, self.view.bottom-45-12, btnWidth, 12);
}

- (void)onSendSMSBtnClick:(UIButton *)btn {
    NSDictionary *param = @{@"phone":self.phoneInput.text, @"type":@(2)};
    [ApiManager requestWithTpye:nil path:s1_sms_sendSms parameters:param success:^(NSURLSessionDataTask *task, id response) {
        if ([[response[ResponseCode] stringValue] isEqualToString:SuccessCode]) {
            [self fireTimer];
        } else {
            [UIView toastWithMessage:TJHKString(@"%@", response[ResponseMessage])];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [UIView toastWithMessage:TJHKString(@"%@", error.domain)];
    }];
}

- (void)onLoginBtnClick:(UIButton *)btn {
    NSDictionary *param = @{@"phone":self.phoneInput.text, @"code":self.codeInput.text};
    [ApiManager requestWithTpye:nil path:s1_clientUser_smsLogin_app parameters:param success:^(NSURLSessionDataTask *task, id response) {
        if ([[response[ResponseCode] stringValue] isEqualToString:SuccessCode]) {
            [[NSUserDefaults standardUserDefaults] setObject:response[ResponseData] forKey:UserData_CacheKey];
            [TJHKHandle shareHandle].isLogin = YES;
            [TJHKHandle shareHandle].userId = response[ResponseData][@"userId"];
            [TJHKHandle shareHandle].phone = response[ResponseData][@"account"];
            [TJHKHandle shareHandle].userName = response[ResponseData][@"userName"];
            [self dismissViewControllerAnimated:YES completion:nil];
            if (self.successBlock) {
                self.successBlock();
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:LoginNotification object:nil];
        } else {
            [UIView toastWithMessage:TJHKString(@"%@", response[ResponseMessage])];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [UIView toastWithMessage:TJHKString(@"%@", error.domain)];
    }];
}

- (void)onProtocolBtnClick:(UIButton *)btn {
    [TJHKTool jumpWebWithUrl:[TJHKTool getHTMLWithPath:RegisterProtocol_HTMLUrl]];
}

- (void)onEditingChanged:(UITextField *)textField {
    if ([textField isEqual:self.phoneInput]) {
        self.hasPhoneInput = (textField.text.length == 11);
    }
    else if ([textField isEqual:self.codeInput]) {
        self.hasCodeInput = (textField.text.length == 4);
    }
    self.sendSMSBtn.enabled = self.hasPhoneInput;
    self.loginBtn.enabled = (self.hasPhoneInput && self.hasCodeInput);
}

- (void)fireTimer {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);
    @weakify(self);
    dispatch_source_set_event_handler(self.timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            if (self.time > 0) {
                self.sendSMSBtn.enabled = NO;
                [self.sendSMSBtn setTitle:TJHKString(@"%02zds", self.time) forState:UIControlStateNormal];
                self.time--;
            } else {
                self.time = 0;
                self.sendSMSBtn.enabled = YES;
                [self.sendSMSBtn setTitle:@"重新获取" forState:UIControlStateNormal];
                dispatch_source_cancel(self.timer);
            }
        });
    });
    dispatch_resume(self.timer);
}

@end
