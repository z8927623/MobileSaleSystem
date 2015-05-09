//
//  FundsCell.h
//  MobileSaleSystem
//
//  Created by wildyao on 15/4/16.
//  Copyright (c) 2015年 Yang Yao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FundsCell : UITableViewCell

@property (nonatomic, strong) UILabel *lbl1;
@property (nonatomic, strong) UILabel *lbl1Value;

@property (nonatomic, strong) UILabel *lbl2;
@property (nonatomic, strong) UILabel *lbl2Value;

@property (nonatomic, strong) UILabel *statusLbl;

- (void)setValue1:(NSString *)value1 value2:(NSString *)value2 status:(NSString *)status;


@end
