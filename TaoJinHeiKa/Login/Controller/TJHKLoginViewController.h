//
//  TJHKLoginViewController.h
//  TaoJinHeiKa
//
//  Created by wzh-macpro on 2018/10/23.
//  Copyright © 2018年 TaoJinHeiKa. All rights reserved.
//

#import "BaseViewController.h"

@interface TJHKLoginViewController : BaseViewController

typedef void (^LoginSuccessBlock) (void);

- (instancetype)initWithSuccessBlock:(LoginSuccessBlock)successBlock;

@end
