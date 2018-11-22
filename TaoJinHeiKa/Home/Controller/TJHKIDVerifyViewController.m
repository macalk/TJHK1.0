//
//  TJHKIDVerifyViewController.m
//  TaoJinHeiKa
//
//  Created by wzh-macpro on 2018/11/2.
//  Copyright © 2018年 TaoJinHeiKa. All rights reserved.
//

#import "TJHKIDVerifyViewController.h"
#import "TJHKContactsVerifyViewController.h"

@interface TJHKIDVerifyViewController ()

Strong UITextField *nameInput;
Strong UITextField *idCardInput;

@end

@implementation TJHKIDVerifyViewController

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
    stepView.image = TJHKImage(@"image_verify_one_step");
    [headerView addSubview:stepView];
    
    UILabel *nameTitleLabel = [[UILabel alloc] init];
    nameTitleLabel.font = TJHKFont(15);
    nameTitleLabel.textColor = TJHKHexColor(@"#282A2E");
    [self.view addSubview:nameTitleLabel];
    nameTitleLabel.text = @"姓名";
    nameTitleLabel.frame = CGRectMake(15, headerView.bottom+20, 80, 55);
    
    self.nameInput = [[UITextField alloc] init];
    self.nameInput.keyboardType = UIKeyboardTypeDefault;
    self.nameInput.textColor = TJHKHexColor(@"#333333");
    self.nameInput.maxLength = 6;
    self.nameInput.placeholder = @"请填写您的真实姓名";
    self.nameInput.placeholderFont = TJHKFont(14);
    self.nameInput.placeholderColor = TJHKHexColor(@"#999999");
    [self.view addSubview:self.nameInput];
    self.nameInput.textAlignment = NSTextAlignmentRight;
    self.nameInput.frame = CGRectMake(nameTitleLabel.right+10, nameTitleLabel.top, ScreenWidth-15*2-10-80, 55);
    
    UIView *nameLine = [[UIView alloc] init];
    nameLine.backgroundColor = Line_Color;
    [self.view addSubview:nameLine];
    nameLine.frame = CGRectMake(15, self.nameInput.bottom-1/[UIScreen mainScreen].scale, ScreenWidth-15*2, 1/[UIScreen mainScreen].scale);
    
    UILabel *idCardTitleLabel = [[UILabel alloc] init];
    idCardTitleLabel.font = TJHKFont(15);
    idCardTitleLabel.textColor = TJHKHexColor(@"#282A2E");
    [self.view addSubview:idCardTitleLabel];
    idCardTitleLabel.text = @"身份证号";
    idCardTitleLabel.frame = CGRectMake(15, nameLine.bottom, 80, 55);
    
    self.idCardInput = [[UITextField alloc] init];
    self.idCardInput.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.idCardInput.textColor = TJHKHexColor(@"#333333");
    self.idCardInput.maxLength = 18;
    self.idCardInput.placeholder = @"请填写您的身份证号码";
    self.idCardInput.placeholderFont = TJHKFont(14);
    self.idCardInput.placeholderColor = TJHKHexColor(@"#999999");
    [self.view addSubview:self.idCardInput];
    self.idCardInput.textAlignment = NSTextAlignmentRight;
    self.idCardInput.frame = CGRectMake(idCardTitleLabel.right+10, idCardTitleLabel.top, ScreenWidth-15*2-10-80, 55);
    
    UIView *idCardLine = [[UIView alloc] init];
    idCardLine.backgroundColor = Line_Color;
    [self.view addSubview:idCardLine];
    idCardLine.frame = CGRectMake(0, self.idCardInput.bottom-1/[UIScreen mainScreen].scale, ScreenWidth, 1/[UIScreen mainScreen].scale);
    
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
        [UIView toastWithMessage:@"请填写您的真实姓名"];
        return;
    }
    if (!self.idCardInput.text.length) {
        [UIView toastWithMessage:@"请填写您的身份证号码"];
        return;
    }
    
    NSDictionary *param = @{@"userId": [TJHKHandle shareHandle].userId, @"realName":self.nameInput.text, @"cardNo":self.idCardInput.text};
    [ApiManager requestWithTpye:nil path:s1_idCard_save parameters:param success:^(NSURLSessionDataTask *task, id response) {
        if ([[response[ResponseCode] stringValue] isEqualToString:SuccessCode]) {
            NSString *verifyCacheKey = [@"LoanVerifyCache_" stringByAppendingString:[TJHKHandle shareHandle].userId?:@""];
            NSDictionary *verifyCache = [KeyChainStore load:verifyCacheKey];
            NSMutableDictionary *verifyDic = (verifyCache?:@{}).mutableCopy;
            NSDictionary *dic = @{@"realName":self.nameInput.text, @"cardNo":self.idCardInput.text};
            [verifyDic setValue:[TJHKTool dictionaryToJsonString:dic] forKey:@"IDCard"];
            [KeyChainStore save:verifyCacheKey data:verifyDic.copy];
            TJHKContactsVerifyViewController *vc = [[TJHKContactsVerifyViewController alloc] init];
            vc.loanMoney = self.loanMoney;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [UIView toastWithMessage:TJHKString(@"%@", response[ResponseMessage])];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [UIView toastWithMessage:TJHKString(@"%@", error.domain)];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
