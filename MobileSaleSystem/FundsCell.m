//
//  FundsCell.m
//  MobileSaleSystem
//
//  Created by wildyao on 15/4/16.
//  Copyright (c) 2015年 Yang Yao. All rights reserved.
//

#import "FundsCell.h"

@implementation FundsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.lbl1 = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.lbl1];
        
        self.lbl1Value = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.lbl1Value];
        
        self.lbl2 = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.lbl2];
        
        self.lbl2Value = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.lbl2Value];
        
        self.statusLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.statusLbl];
    }
    return self;
}

- (void)setValue1:(NSString *)value1 value2:(NSString *)value2 status:(NSString *)status
{
    self.lbl1.text = @"用途：";
    self.lbl2.text = @"金额：";
    self.lbl1Value.text = value1;
    self.lbl2Value.text = value2;
    
    int st = [status intValue];
    if (st == 0) {
        self.statusLbl.text = @"待审核";
    } else if (st == 1) {
        self.statusLbl.text = @"已通过";
    } else {
        self.statusLbl.text = @"未通过";
    }
    

    [self.lbl1 sizeToFit];
    [self.lbl2 sizeToFit];
    [self.lbl1Value sizeToFit];
    [self.lbl2Value sizeToFit];
    [self.statusLbl sizeToFit];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.lbl1.left = 10;
    self.lbl1.top = 5;

    self.lbl2.left = 10;
    self.lbl2.top = self.lbl1.bottom+10;
    
    self.lbl1Value.left = self.lbl1.right;
    self.lbl1Value.top = 5;
    self.lbl1Value.width = self.width-5-self.lbl1.right;
    
    self.lbl2Value.left = self.lbl2.right;
    self.lbl2Value.top = self.lbl1.bottom+10;
    self.lbl2Value.width = self.width-5-self.lbl2.right;
    
    self.statusLbl.right = self.width-10;
    self.statusLbl.centerY = self.height/2;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
