//
//  SignInCell.m
//  MobileSaleSystem
//
//  Created by wildyao on 15/3/25.
//  Copyright (c) 2015年 Yang Yao. All rights reserved.
//

#import "SignInCell.h"

@implementation SignInCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.nameLbl = [[UILabel alloc] initWithFrame:CGRectZero];
//        [self.contentView addSubview:self.nameLbl];
     
        self.timeLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.timeLbl];
        
        self.addressLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.addressLbl];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setName:(NSString *)name time:(NSString *)time address:(NSString *)address
{
//    self.nameLbl.text = name;
    self.timeLbl.text = time;
    self.addressLbl.text = address;
    
//    [self.nameLbl sizeToFit];
    [self.timeLbl sizeToFit];
    [self.addressLbl sizeToFit];
}

- (void)layoutSubviews {
    [super layoutSubviews];

//    self.nameLbl.left = 10;
//    self.nameLbl.top = 10;
    
    self.timeLbl.top = 10;
    self.timeLbl.left = 10;
    
    self.addressLbl.left = 10;
    self.addressLbl.top = self.timeLbl.bottom+5;
    self.addressLbl.width = self.width-20;
}


@end
