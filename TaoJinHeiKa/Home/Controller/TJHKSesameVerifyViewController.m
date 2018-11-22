//
//  TJHKSesameVerifyViewController.m
//  TaoJinHeiKa
//
//  Created by wzh-macpro on 2018/11/2.
//  Copyright © 2018年 TaoJinHeiKa. All rights reserved.
//

#import "TJHKSesameVerifyViewController.h"

@interface TJHKSesameVerifyViewController ()

Strong UITextField *sesameInput;

@end

@implementation TJHKSesameVerifyViewController

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
    stepView.image = TJHKImage(@"image_verify_three_step");
    [headerView addSubview:stepView];
    
    UILabel *sesameTitleLabel = [[UILabel alloc] init];
    sesameTitleLabel.font = TJHKFont(15);
    sesameTitleLabel.textColor = TJHKHexColor(@"#282A2E");
    [self.view addSubview:sesameTitleLabel];
    sesameTitleLabel.text = @"芝麻分";
    sesameTitleLabel.frame = CGRectMake(15, headerView.bottom+20, 80, 55);
    
    self.sesameInput = [[UITextField alloc] init];
    self.sesameInput.keyboardType = UIKeyboardTypeNumberPad;
    self.sesameInput.textColor = TJHKHexColor(@"#333333");
    self.sesameInput.maxLength = 6;
    self.sesameInput.placeholder = @"请填写您的芝麻分";
    self.sesameInput.placeholderFont = TJHKFont(14);
    self.sesameInput.placeholderColor = TJHKHexColor(@"#999999");
    [self.view addSubview:self.sesameInput];
    self.sesameInput.textAlignment = NSTextAlignmentRight;
    self.sesameInput.frame = CGRectMake(sesameTitleLabel.right+10, sesameTitleLabel.top, ScreenWidth-15*2-10-80, 55);
    
    UIView *idCardLine = [[UIView alloc] init];
    idCardLine.backgroundColor = Line_Color;
    [self.view addSubview:idCardLine];
    idCardLine.frame = CGRectMake(0, self.sesameInput.bottom-1/[UIScreen mainScreen].scale, ScreenWidth, 1/[UIScreen mainScreen].scale);
    
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
    if (!self.sesameInput.text.length) {
        [UIView toastWithMessage:@"请填写您的芝麻分"];
        return;
    }
    
    NSDictionary *param = @{@"userId": [TJHKHandle shareHandle].userId, @"score":self.sesameInput.text};
    [ApiManager requestWithTpye:nil path:s1_credit_score_saveZhiMa parameters:param success:^(NSURLSessionDataTask *task, id response) {
        if ([[response[ResponseCode] stringValue] isEqualToString:SuccessCode]) {
            NSString *verifyCacheKey = [@"LoanVerifyCache_" stringByAppendingString:[TJHKHandle shareHandle].userId?:@""];
            NSDictionary *verifyCache = [KeyChainStore load:verifyCacheKey];
            NSMutableDictionary *verifyDic = (verifyCache?:@{}).mutableCopy;
            NSDictionary *dic = @{@"score":self.sesameInput.text};
            [verifyDic setValue:[TJHKTool dictionaryToJsonString:dic] forKey:@"sesame"];
            [KeyChainStore save:verifyCacheKey data:verifyDic.copy];
            [self submitLoanData];
        } else {
            [UIView toastWithMessage:TJHKString(@"%@", response[ResponseMessage])];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [UIView toastWithMessage:TJHKString(@"%@", error.domain)];
    }];
}

- (void)submitLoanData {
    NSMutableDictionary *param = @{@"userId":[TJHKHandle shareHandle].userId, @"amount":TJHKString(@"%zd", self.loanMoney)}.mutableCopy;
    NSString *verifyCacheKey = [@"LoanVerifyCache_" stringByAppendingString:[TJHKHandle shareHandle].userId?:@""];
    NSDictionary *verifyCache = [KeyChainStore load:verifyCacheKey];
    NSString *IDCardJsonStr = verifyCache[@"IDCard"];
    NSString *contactsJsonStr = verifyCache[@"contacts"];
    NSString *sesameJsonStr = verifyCache[@"sesame"];
    [param setValue:IDCardJsonStr forKey:@"idCard"];
    [param setValue:contactsJsonStr forKey:@"contacts"];
    [param setValue:sesameJsonStr forKey:@"zhima"];
    
    [ApiManager requestWithTpye:nil path:s1_order_submit parameters:param success:^(NSURLSessionDataTask *task, id response) {
        if ([[response[ResponseCode] stringValue] isEqualToString:SuccessCode]) {
            [UIView toastWithMessage:@"您的申请已提交，正在审核中"];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
            NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
            [formatter setTimeZone:timeZone];
            NSString *loanTimeCacheKey = [@"LoanTimeCache_" stringByAppendingString:[TJHKHandle shareHandle].userId?:@""];
            [KeyChainStore save:loanTimeCacheKey data:[formatter stringFromDate:[NSDate date]]];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            [UIView toastWithMessage:TJHKString(@"%@", response[ResponseMessage])];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [UIView toastWithMessage:TJHKString(@"%@", error.domain)];
    }];
}

@end
