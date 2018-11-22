//
//  TJHKHomeViewController.m
//  TaoJinHeiKa
//
//  Created by wzh-macpro on 2018/11/4.
//  Copyright © 2018年 TaoJinHeiKa. All rights reserved.
//

#import "TJHKHomeViewController.h"
#import "TJHKIDVerifyViewController.h"
#import "TJHKContactsVerifyViewController.h"
#import "TJHKSesameVerifyViewController.h"
#import "TJHKLogoView.h"
#import "TJHKVerifyStatusView.h"
#import "TJHKLoanMarketCell.h"
#import "TJHKSlider.h"

#define Minimum 500
#define Maximum 1200
#define Interval 100
#define LoanDays 15
#define ServiceMoney 20
#define LoanTip @"不向学生提供服务"

@interface TJHKHomeViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

Strong UIImageView *headerBackView;
Strong UIView *topBar;
Strong UILabel *minLabel;
Strong UILabel *maxLabel;
Strong UIButton *loanBtn;
Strong UIView *bottomTipView;
Strong TJHKVerifyStatusView *statusView;
Strong UICollectionView *myCollectionView;

Strong UILabel *loanMoneyLabel;
Strong UILabel *loanDaysLabel;
Strong UILabel *serviceMoneyLabel;
Strong TJHKSlider *slider;
Assign NSInteger sliderValue;
Assign NSInteger lastSliderValue;
Strong dispatch_source_t timer;
Assign NSInteger time;
Assign LoanStatus loanStatus;
Strong NSMutableArray *productList;

@end

@implementation TJHKHomeViewController

- (NSMutableArray *)productList {
    if (!_productList) {
        _productList = [NSMutableArray arrayWithCapacity:0];
    }
    return _productList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.navigationItem.title = @"借钱";
    
    [self configViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLogin) name:LoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLogout) name:LogoutNotification object:nil];
    
    [self requestProductList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configStatusBarDefault];
    [self configNavigationBarHidden];
    [self checkLoanStatusForVisiableView];
}

- (void)requestProductList {
    [ApiManager requestWithTpye:@"GET" path:products_list parameters:@{@"sign":@"RgUfwcoJbWVPmT2dghPm4y6jRKF6i4"} success:^(NSURLSessionDataTask *task, id response) {
        if ([[response[ResponseCode] stringValue] isEqualToString:SuccessCode]) {
            if (response[ResponseData] && [response[ResponseData] isKindOfClass:[NSArray class]]) {
                [self.productList removeAllObjects];
                for (NSDictionary *dic in response[ResponseData]) {
                    TJHKLoanMarketModel *model = [TJHKLoanMarketModel modelWithDictionary:dic];
                    [self.productList addObject:model];
                }
                [self.myCollectionView reloadData];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)configViews {
    self.headerBackView = [[UIImageView alloc] init];
    self.headerBackView.frame = CGRectMake(0, 0, ScreenWidth, StatusBarHeight+NavigationBarHeight+139);
    self.headerBackView.image = TJHKImage(@"image_loan_header");
    [self.view addSubview:self.headerBackView];
    
    TJHKLogoView *logoView  = [[TJHKLogoView alloc] initWithFrame:CGRectMake(0, StatusBarHeight+NavigationBarHeight-20, ScreenWidth, Logo_Height)];
    [self.view addSubview:logoView];
    
    self.topBar = [[UIView alloc] init];
    self.topBar.frame = CGRectMake(15, StatusBarHeight+NavigationBarHeight+43, ScreenWidth-15*2, 175);
    self.topBar.backgroundColor = TJHKHexColor(@"#262523");
    self.topBar.layer.cornerRadius = 12.f;
    self.topBar.layer.masksToBounds = YES;
    [self.view addSubview:self.topBar];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(10, 34, self.topBar.width-10*2, 14);
    titleLabel.text = @"借款金额（元）";
    titleLabel.font = TJHKFont(14);
    titleLabel.textColor = TJHKHexColor(@"#FFF7EF");
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.topBar addSubview:titleLabel];
    
    self.loanMoneyLabel = [[UILabel alloc] init];
    self.loanMoneyLabel.frame = CGRectMake(10, titleLabel.bottom+19, self.topBar.width-10*2, 43);
    self.loanMoneyLabel.text = TJHKString(@"%zd", (NSInteger)Maximum);
    self.loanMoneyLabel.font = TJHKFont(43);
    self.loanMoneyLabel.textColor = TJHKHexColor(@"#FFF7EF");
    self.loanMoneyLabel.textAlignment = NSTextAlignmentCenter;
    [self.topBar addSubview:self.loanMoneyLabel];
    
    UIView *barBottomView = [[UIView alloc] init];
    barBottomView.frame = CGRectMake(0, self.topBar.height-47, self.topBar.width, 47);
    barBottomView.backgroundColor = TJHKHexColor(@"#171717");
    [self.topBar addSubview:barBottomView];
    
    self.loanDaysLabel = [[UILabel alloc] init];
    self.loanDaysLabel.frame = CGRectMake(0, 0, barBottomView.width/2, barBottomView.height);
    self.loanDaysLabel.text = TJHKString(@"期限 %zd天", (NSInteger)LoanDays);
    self.loanDaysLabel.font = TJHKFont(14);
    self.loanDaysLabel.textColor = TJHKHexColor(@"#FFF7EF");
    self.loanDaysLabel.textAlignment = NSTextAlignmentCenter;
    [barBottomView addSubview:self.loanDaysLabel];
    
    self.serviceMoneyLabel = [[UILabel alloc] init];
    self.serviceMoneyLabel.frame = CGRectMake(barBottomView.width/2, 0, barBottomView.width/2, barBottomView.height);
    self.serviceMoneyLabel.text = @"服务费率 0.05%";
    self.serviceMoneyLabel.font = TJHKFont(14);
    self.serviceMoneyLabel.textColor = TJHKHexColor(@"#FFF7EF");
    self.serviceMoneyLabel.textAlignment = NSTextAlignmentCenter;
    [barBottomView addSubview:self.serviceMoneyLabel];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = TJHKHexColor(@"#7C7871");
    line.frame = CGRectMake(barBottomView.width/2, (barBottomView.height-20)/2, 1, 20);
    [barBottomView addSubview:line];
    
    self.slider = [[TJHKSlider alloc] init];
    self.slider.frame = CGRectMake(25, self.topBar.bottom+80, ScreenWidth-22*2, 40);
    [self.slider setThumbImage:[UIImage imageNamed:@"icon_loan_slider_thumb"] forState:UIControlStateNormal];
    UIImage *minImage = [[UIImage imageWithColor:TJHKHexColor(@"#E8CDA3") size:CGSizeMake(self.slider.width, 4)] imageByRoundCornerRadius:2.f];
    UIImage *maxImage = [[UIImage imageWithColor:TJHKHexColor(@"#E4E4E4") size:CGSizeMake(self.slider.width, 4)] imageByRoundCornerRadius:2.f];
    [self.slider setMinimumTrackImage:[minImage resizableImageWithCapInsets:UIEdgeInsetsZero] forState:UIControlStateNormal];
    [self.slider setMaximumTrackImage:maxImage forState:UIControlStateNormal];
    [self.slider addTarget:self action:@selector(sliderChangeAction:) forControlEvents:UIControlEventValueChanged];
    [self.slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchUpOutside];
    [self.view addSubview:self.slider];
    [self.slider setMinimumValue:Minimum];
    [self.slider setMaximumValue:Maximum];
    [self.slider setValue:Maximum];
    self.sliderValue = Maximum;
    self.lastSliderValue = Maximum;
    
    self.minLabel = [[UILabel alloc] init];
    self.minLabel.frame = CGRectMake(25, self.slider.bottom+7, 150, 12);
    self.minLabel.font = TJHKFont(12);
    self.minLabel.textColor = TJHKHexColor(@"#787B80");
    self.minLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.minLabel];
    self.minLabel.text = TJHKString(@"%zd", (NSInteger)Minimum);
    
    self.maxLabel = [[UILabel alloc] init];
    self.maxLabel.frame = CGRectMake(ScreenWidth-25-150, self.slider.bottom+7, 150, 12);
    self.maxLabel.font = TJHKFont(12);
    self.maxLabel.textColor = TJHKHexColor(@"#787B80");
    self.maxLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.maxLabel];
    self.maxLabel.text = TJHKString(@"%zd", (NSInteger)Maximum);
    
    self.loanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loanBtn.frame = CGRectMake(15, self.minLabel.bottom+70, ScreenWidth-15*2, 55);
    self.loanBtn.layer.cornerRadius = 55/2;
    self.loanBtn.layer.masksToBounds = YES;
    [self.loanBtn setBackgroundImage:TJHKImage(@"image_loan_btn") forState:UIControlStateNormal];
    [self.loanBtn setBackgroundImage:[UIImage imageWithColor:TJHKHexColor(@"#D6D6D6")] forState:UIControlStateDisabled];
    self.loanBtn.titleLabel.font = TJHKFont(19);
    [self.loanBtn setTitleColor:TJHKHexColor(@"#333333") forState:UIControlStateNormal];
    [self.loanBtn setTitleColor:TJHKHexColor(@"#FFFFFF") forState:UIControlStateDisabled];
    [self.loanBtn setTitle:@"立即拿钱" forState:UIControlStateNormal];
    [self.loanBtn addTarget:self action:@selector(onLoanBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loanBtn];
    
    self.bottomTipView = [[UIView alloc] init];
    self.bottomTipView.frame = CGRectMake(0, ScreenHeight-TabBarHeight-16-17, ScreenWidth, 17);
    [self.view addSubview:self.bottomTipView];
    
    UIImageView *safeView = [[UIImageView alloc] init];
    CGFloat tipWidth = [TJHKTool getTextWidthWithText:LoanTip font:TJHKFont(12)];
    safeView.frame = CGRectMake((self.bottomTipView.width-15-7-tipWidth)/2, 0, 15, 17);
    safeView.image = TJHKImage(@"icon_loan_safe");
    [self.bottomTipView addSubview:safeView];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.frame = CGRectMake(safeView.right+7, 0, tipWidth, 17);
    tipLabel.font = TJHKFont(12);
    tipLabel.textColor = TJHKHexColorAlpha(@"#525864", 0.6f);
    tipLabel.text = LoanTip;
    [self.bottomTipView addSubview:tipLabel];
    
    self.statusView = [[TJHKVerifyStatusView alloc] initWithFrame:CGRectMake((ScreenWidth-VerifyStatus_Width)/2, StatusBarHeight+NavigationBarHeight+294, VerifyStatus_Width, VerifyStatus_Height)];
    [self.view addSubview:self.statusView];
    
    [self configMarketView];
}

- (void)configMarketView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    
    UIImageView *listBackImage = [[UIImageView alloc] init];
    listBackImage.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-StatusBarHeight-NavigationBarHeight-TabBarHeight-153);
    listBackImage.contentMode = UIViewContentModeScaleAspectFill;
    listBackImage.clipsToBounds = YES;
    listBackImage.image = TJHKImage(@"image_loan_list_back");
    
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, StatusBarHeight+NavigationBarHeight+153, ScreenWidth, ScreenHeight-StatusBarHeight-NavigationBarHeight-TabBarHeight-153) collectionViewLayout:flowLayout];
    self.myCollectionView.backgroundView = listBackImage;
    self.myCollectionView.backgroundColor = [UIColor clearColor];
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    self.myCollectionView.contentInset = UIEdgeInsetsZero;
    [self.view addSubview:self.myCollectionView];
    
    [self.myCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SectionHeader"];
    [self.myCollectionView registerClass:[TJHKLoanMarketCell class] forCellWithReuseIdentifier:[TJHKLoanMarketCell className]];
}

- (void)configViewsWithStatus {
    switch (self.loanStatus) {
        case LoanStatus_Normal:
            self.headerBackView.hidden = NO;
            self.topBar.hidden = NO;
            self.slider.hidden = NO;
            self.minLabel.hidden = NO;
            self.maxLabel.hidden = NO;
            self.loanBtn.hidden = NO;
            self.loanBtn.enabled = YES;
            [self.loanBtn setTitle:@"立即拿钱" forState:UIControlStateNormal];
            self.bottomTipView.hidden = NO;
            self.statusView.hidden = YES;
            self.myCollectionView.hidden = YES;
            break;
        case LoanStatus_Auditing:
            self.headerBackView.hidden = NO;
            self.topBar.hidden = NO;
            self.slider.hidden = YES;
            self.minLabel.hidden = YES;
            self.maxLabel.hidden = YES;
            self.loanBtn.hidden = NO;
            self.loanBtn.enabled = NO;
            [self.loanBtn setTitle:TJHKString(@"审核中(倒计时%@)", [TJHKTool getTime:self.time]) forState:UIControlStateNormal];
            self.bottomTipView.hidden = NO;
            self.statusView.hidden = NO;
            self.statusView.frame = CGRectMake((ScreenWidth-VerifyStatus_Width)/2, StatusBarHeight+NavigationBarHeight+294, VerifyStatus_Width, VerifyStatus_Height);
            self.statusView.status = self.loanStatus;
            self.myCollectionView.hidden = YES;
            break;
        case LoanStatus_Fail:
            self.headerBackView.hidden = YES;
            self.topBar.hidden = YES;
            self.slider.hidden = YES;
            self.minLabel.hidden = YES;
            self.maxLabel.hidden = YES;
            self.loanBtn.hidden = YES;
            self.bottomTipView.hidden = YES;
            self.statusView.hidden = NO;
            self.statusView.frame = ![TJHKHandle shareHandle].isShowApplyMarket ? CGRectMake((ScreenWidth-VerifyStatus_Width)/2, StatusBarHeight+NavigationBarHeight+189, VerifyStatus_Width, VerifyStatus_Height) : CGRectMake((ScreenWidth-VerifyStatus_Width)/2, StatusBarHeight+NavigationBarHeight+56, VerifyStatus_Width, VerifyStatus_Height);
            self.statusView.status = self.loanStatus;
            self.myCollectionView.hidden = ![TJHKHandle shareHandle].isShowApplyMarket;
            break;
            
        default:
            break;
    }
}

- (void)sliderChangeAction:(UISlider *)slider {
    self.sliderValue = [self getNewValue:slider.value];
    self.loanMoneyLabel.text = [NSString stringWithFormat:@"%zd", self.sliderValue];
}

- (void)sliderAction:(UISlider *)slider {
    self.lastSliderValue = [self getNewValue:slider.value];
    self.sliderValue = [self getNewValue:slider.value];
    self.lastSliderValue = [self getNewValue:slider.value];
    [slider setValue:self.sliderValue animated:YES];
}

- (NSInteger)getNewValue:(float)value {
    if (value > self.lastSliderValue)
    {
        NSInteger x = (value - self.lastSliderValue)/Interval;
        NSInteger interval = ((NSInteger)(value - self.lastSliderValue) % Interval);
        if (interval > Interval/2) {
            NSInteger y = self.lastSliderValue + (x + 1) * Interval;
            if (y >= Maximum || value == Maximum) {
                y = Maximum;
            }
            return y;
        } else {
            NSInteger y = self.lastSliderValue + x * Interval;
            if (y >= Maximum || value == Maximum) {
                y = Maximum;
            }
            return y;
        }
    }
    else if (value == self.lastSliderValue)
    {
        return self.lastSliderValue;
    }
    else
    {
        NSInteger x = (self.lastSliderValue - value)/Interval;
        NSInteger interval = ((NSInteger)(self.lastSliderValue - value) % Interval);
        if (interval > Interval/2) {
            NSInteger y = self.lastSliderValue - (x + 1) * Interval;
            if (y <= Minimum || value <= Minimum) {
                y = Minimum;
            }
            return y;
        } else {
            NSInteger y = self.lastSliderValue - x * Interval;
            if (y <= Minimum || value <= Minimum) {
                y = Minimum;
            }
            return y;
        }
    }
}

- (void)onLoanBtnClick {
    if (![TJHKHandle shareHandle].isLogin) {
        [TJHKTool jumpLogin];
        return;
    }
    [self checkVerifyStatusForJump];
}

- (void)checkVerifyStatusForJump {
    NSString *verifyCacheKey = [@"LoanVerifyCache_" stringByAppendingString:[TJHKHandle shareHandle].userId?:@""];
    NSDictionary *verifyCache = [KeyChainStore load:verifyCacheKey];
    NSString *IDCardJsonStr = verifyCache[@"IDCard"];
    NSString *contactsJsonStr = verifyCache[@"contacts"];
    NSString *sesameJsonStr = verifyCache[@"sesame"];
    
    if (NULLString(IDCardJsonStr)) {
        [self jumpToUserVerify];
        return ;
    }
    if (NULLString(contactsJsonStr)) {
        [self jumpToContactsVerify];
        return;
    }
    if (NULLString(sesameJsonStr)) {
        [self jumpToSesameVerify];
        return;
    }
}

- (void)jumpToUserVerify {
    TJHKIDVerifyViewController *vc = [[TJHKIDVerifyViewController alloc] init];
    vc.loanMoney = self.sliderValue;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToContactsVerify {
    TJHKContactsVerifyViewController *vc = [[TJHKContactsVerifyViewController alloc] init];
    vc.loanMoney = self.sliderValue;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)jumpToSesameVerify {
    TJHKSesameVerifyViewController *vc = [[TJHKSesameVerifyViewController alloc] init];
    vc.loanMoney = self.sliderValue;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onLogin {
    [self checkLoanStatusForVisiableView];
}

- (void)onLogout {
    self.loanStatus = LoanStatus_Normal;
    self.time = 0;
    [self configViewsWithStatus];
}

- (void)checkLoanStatusForVisiableView {
    if (![TJHKHandle shareHandle].isLogin) {
        self.loanStatus = LoanStatus_Normal;
        self.time = 0;
        [self configViewsWithStatus];
        return;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    NSString *loanTimeCacheKey = [@"LoanTimeCache_" stringByAppendingString:[TJHKHandle shareHandle].userId?:@""];
    NSString *loanTimeStr = [KeyChainStore load:loanTimeCacheKey];

    if (loanTimeStr) {
        NSDate *loanDate = [formatter dateFromString:loanTimeStr];
        NSDate *auditDate = [loanDate dateByAddingTimeInterval:5*60];
        NSDate *nowDate = [NSDate date];
        if ([nowDate timeIntervalSinceDate:loanDate] > 0) {
            int auditInterval = [auditDate timeIntervalSinceDate:nowDate];
            if (auditInterval > 0) {
                self.time = auditInterval;
                [self fireLoanStatusTimerWithAuditInterval:auditInterval];
            } else {
                self.loanStatus = LoanStatus_Fail;
                self.time = 0;
                [self configViewsWithStatus];
            }
        } else {
            self.loanStatus = LoanStatus_Fail;
            self.time = 0;
            [self configViewsWithStatus];
        }
    } else {
        self.loanStatus = LoanStatus_Normal;
        self.time = 0;
        [self configViewsWithStatus];
    }
}

- (void)fireLoanStatusTimerWithAuditInterval:(int)auditInterval {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);
    @weakify(self);
    dispatch_source_set_event_handler(self.timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            if (self.time > 0) {
                self.loanStatus = LoanStatus_Auditing;
                [self configViewsWithStatus];
                self.time--;
            } else {
                self.time = 0;
                self.loanStatus = LoanStatus_Fail;
                [self configViewsWithStatus];
                dispatch_source_cancel(self.timer);
            }
        });
    });
    dispatch_resume(self.timer);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(ScreenWidth, 70);
}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SectionHeader" forIndexPath:indexPath];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = TJHKFont(19);
    titleLabel.textColor = TJHKHexColor(@"#333333");
    titleLabel.text = @"借款推荐";
    titleLabel.frame = CGRectMake(15, 25, 80, 19);
    [headerView addSubview:titleLabel];
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame = CGRectMake(ScreenWidth-15-75, 25, 75, 19);
    moreBtn.titleLabel.font = TJHKFont(14);
    [moreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
    [moreBtn setTitleColor:TJHKHexColor(@"#333333") forState:UIControlStateNormal];
    [moreBtn setImage:TJHKImage(@"icon_loan_more") forState:UIControlStateNormal];
    moreBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -34, 0, 0);
    moreBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 60, 0, 0);
    [moreBtn addTarget:self action:@selector(onMoreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:moreBtn];
    return headerView;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.productList.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(ScreenWidth/4, 112);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TJHKLoanMarketCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[TJHKLoanMarketCell className] forIndexPath:indexPath];
    if (self.productList.count > indexPath.item) {
        TJHKLoanMarketModel *model = self.productList[indexPath.item];
        cell.model = model;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.productList.count > indexPath.item) {
        TJHKLoanMarketModel *model = self.productList[indexPath.item];
        if (model.url) {
            [TJHKTool jumpWebWithUrl:model.url];
        }
    }
}

- (void)onMoreBtnClick:(UIButton *)btn {
    [TJHKTool jumpWebWithUrl:[TJHKTool getHTMLWithPath:LoanPage_LoanMarketList_HTMLUrl]];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
