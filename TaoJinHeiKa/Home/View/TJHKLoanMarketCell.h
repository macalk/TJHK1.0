//
//  TJHKLoanMarketCell.h
//  TaoJinHeiKa
//
//  Created by wzh-macpro on 2018/11/4.
//  Copyright © 2018年 TaoJinHeiKa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJHKLoanMarketModel : NSObject

Strong NSString *logo;
Strong NSString *name;
Strong NSString *url;
Strong NSString *sign;
Assign NSInteger status;

@end


@interface TJHKLoanMarketCell : UICollectionViewCell

Strong TJHKLoanMarketModel *model;

@end
