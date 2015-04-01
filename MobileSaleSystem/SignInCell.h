//
//  SignInCell.h
//  MobileSaleSystem
//
//  Created by wildyao on 15/3/25.
//  Copyright (c) 2015年 Yang Yao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInCell : UITableViewCell

@property (nonatomic, strong) UILabel *timeLbl;
@property (nonatomic, strong) UILabel *addressLbl;
@property (nonatomic, strong) UILabel *nameLbl;

- (void)setName:(NSString *)name time:(NSString *)time address:(NSString *)address;

@end
