//
//  ActivityPlanCell.m
//  MobileSaleSystem
//
//  Created by wildyao on 14/12/26.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import "ActivityPlanCell.h"

@implementation ActivityPlanCell

- (void)awakeFromNib {
    // Initialization code
    
//    self.translatesAutoresizingMaskIntoConstraints = NO;
//    self.superview.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.detailLbl.backgroundColor = [UIColor yellowColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize size = [self.detailLbl.text sizeWithFont:self.detailLbl.font
                             constrainedToSize:CGSizeMake(self.frame.size.width-40, MAXFLOAT)
                                 lineBreakMode:NSLineBreakByWordWrapping];
    CGRect frame = self.detailLbl.frame;
    frame.size.height = size.height;
    self.detailLbl.frame = frame;
}

+ (CGFloat)getCellHeight:(NSString *)detail width:(CGFloat)width
{
    CGFloat totalHeight = 55;
    
    UILabel *detailLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    detailLbl.font = [UIFont systemFontOfSize:15.0];
    detailLbl.numberOfLines = 0;
    detailLbl.text = detail;
    
    CGSize size = [detailLbl.text sizeWithFont:detailLbl.font
                             constrainedToSize:CGSizeMake(width, MAXFLOAT)
                                 lineBreakMode:NSLineBreakByWordWrapping];
//    detailLbl.text boundingRectWithSize:CGSizeMake(detailLbl.frame.size.width, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine attributes:@{  } context:<#(NSStringDrawingContext *)#>
    
    totalHeight += size.height+10;
    
    return totalHeight;
}

@end
