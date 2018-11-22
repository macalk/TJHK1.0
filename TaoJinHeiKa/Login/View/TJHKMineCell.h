//
//  TJHKMineCell.h
//  TaoJinHeiKa
//
//  Created by wzh-macpro on 2018/11/1.
//  Copyright © 2018年 TaoJinHeiKa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJHKMineCell : UITableViewCell

- (void)setIcon:(NSString *)icon title:(NSString *)title;

- (void)hideLine:(BOOL)isHidden;

@end
