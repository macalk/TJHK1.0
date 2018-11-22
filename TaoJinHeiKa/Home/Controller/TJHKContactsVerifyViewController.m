//
//  TJHKContactsVerifyViewController.m
//  TaoJinHeiKa
//
//  Created by wzh-macpro on 2018/11/2.
//  Copyright © 2018年 TaoJinHeiKa. All rights reserved.
//

#import "TJHKContactsVerifyViewController.h"
#import "TJHKSesameVerifyViewController.h"

@interface TJHKContactsVerifyViewController ()

Strong UITextField *nameInput;
Strong UITextField *phoneInput;

@end

@implementation TJHKContactsVerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"基础认证";
    [self configViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configNavigationBarImage:[UIImage new]];
    [self configNavigationBarShadow:[UIImage new]];
}

- (void)configViews {
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, ScreenWidth, StatusBarHeight+NavigationBarHeight+116);
    headerView.backgroundColor = TJHKHexColor(@"#F5E3CB");
    [self.view addSubview:headerView];
    
    UIImageView *stepView = [[UIImageView alloc] init];
    stepView.frame = CGRectMake((ScreenWidth-265)/2, headerView.height-36-49, 265, 49);
    stepView.image = TJHKImage(@"image_verify_two_step");
    [headerView addSubview:stepView];
    
    UILabel *nameTitleLabel = [[UILabel alloc] init];
    nameTitleLabel.font = TJHKFont(15);
    nameTitleLabel.textColor = TJHKHexColor(@"#282A2E");
    [self.view addSubview:nameTitleLabel];
    nameTitleLabel.text = @"紧急联系人姓名";
    nameTitleLabel.frame = CGRectMake(15, headerView.bottom+20, 125, 55);
    
    self.nameInput = [[UITextField alloc] init];
    self.nameInput.keyboardType = UIKeyboardTypeDefault;
    self.nameInput.textColor = TJHKHexColor(@"#333333");
    self.nameInput.maxLength = 6;
    self.nameInput.placeholder = @"请填写紧急联系人姓名";
    self.nameInput.placeholderFont = TJHKFont(14);
    self.nameInput.placeholderColor = TJHKHexColor(@"#999999");
    [self.view addSubview:self.nameInput];
    self.nameInput.textAlignment = NSTextAlignmentRight;
    self.nameInput.frame = CGRectMake(nameTitleLabel.right+10, nameTitleLabel.top, ScreenWidth-15*2-10-125, 55);
    
    UIView *nameLine = [[UIView alloc] init];
    nameLine.backgroundColor = Line_Color;
    [self.view addSubview:nameLine];
    nameLine.frame = CGRectMake(15, self.nameInput.bottom-1/[UIScreen mainScreen].scale, ScreenWidth-15*2, 1/[UIScreen mainScreen].scale);
    
    UILabel *phoneTitleLabel = [[UILabel alloc] init];
    phoneTitleLabel.font = TJHKFont(15);
    phoneTitleLabel.textColor = TJHKHexColor(@"#282A2E");
    [self.view addSubview:phoneTitleLabel];
    phoneTitleLabel.text = @"紧急联系人手机号";
    phoneTitleLabel.frame = CGRectMake(15, nameLine.bottom, 125, 55);
    
    self.phoneInput = [[UITextField alloc] init];
    self.phoneInput.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneInput.textColor = TJHKHexColor(@"#333333");
    self.phoneInput.maxLength = 11;
    self.phoneInput.placeholder = @"请填写紧急联系人手机号";
    self.phoneInput.placeholderFont = TJHKFont(14);
    self.phoneInput.placeholderColor = TJHKHexColor(@"#999999");
    [self.view addSubview:self.phoneInput];
    self.phoneInput.textAlignment = NSTextAlignmentRight;
    self.phoneInput.frame = CGRectMake(phoneTitleLabel.right+10, phoneTitleLabel.top, ScreenWidth-15*2-10-125, 55);
    
    UIView *phoneLine = [[UIView alloc] init];
    phoneLine.backgroundColor = Line_Color;
    [self.view addSubview:phoneLine];
    phoneLine.frame = CGRectMake(0, self.phoneInput.bottom-1/[UIScreen mainScreen].scale, ScreenWidth, 1/[UIScreen mainScreen].scale);
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(15, ScreenHeight-20-55, ScreenWidth-15*2, 55);
    submitBtn.layer.cornerRadius = 55/2;
    submitBtn.layer.masksToBounds = YES;
    [submitBtn setBackgroundImage:TJHKImage(@"image_loan_btn") forState:UIControlStateNormal];
    submitBtn.titleLabel.font = TJHKFont(19);
    [submitBtn setTitleColor:TJHKHexColor(@"#333333") forState:UIControlStateNormal];
    [submitBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(onSubmitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
}

- (void)onSubmitBtnClick:(UIButton *)btn {
    if (!self.nameInput.text.length) {
        [UIView toastWithMessage:@"请填写紧急联系人姓名"];
        return;
    }
    if (!self.phoneInput.text.length) {
        [UIView toastWithMessage:@"请填写紧急联系人手机号"];
        return;
    }
    
    NSDictionary *param = @{@"userId": [TJHKHandle shareHandle].userId, @"type":@"0", @"name":self.nameInput.text, @"phone":self.phoneInput.text};
    [ApiManager requestWithTpye:nil path:s1_contacts_save parameters:param success:^(NSURLSessionDataTask *task, id response) {
        if ([[response[ResponseCode] stringValue] isEqualToString:SuccessCode]) {
            NSString *verifyCacheKey = [@"LoanVerifyCache_" stringByAppendingString:[TJHKHandle shareHandle].userId?:@""];
            NSDictionary *verifyCache = [KeyChainStore load:verifyCacheKey];
            NSMutableDictionary *verifyDic = (verifyCache?:@{}).mutableCopy;
            NSDictionary *dic = @{@"type":@"0", @"name":self.nameInput.text, @"phone":self.phoneInput.text};
            [verifyDic setValue:[TJHKTool dictionaryToJsonString:dic] forKey:@"contacts"];
            [KeyChainStore save:verifyCacheKey data:verifyDic.copy];
            TJHKSesameVerifyViewController *vc = [[TJHKSesameVerifyViewController alloc] init];
            vc.loanMoney = self.loanMoney;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [UIView toastWithMessage:TJHKString(@"%@", response[ResponseMessage])];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [UIView toastWithMessage:TJHKString(@"%@", error.domain)];
    }];
}

@end
