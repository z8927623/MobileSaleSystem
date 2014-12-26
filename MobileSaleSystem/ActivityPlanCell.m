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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)getCellHeight:(NSString *)detail
{
//    CGFloat totalHeight = 35;
//    
//    UILabel *detailLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 0)];
//    detailLbl.font = [UIFont systemFontOfSize:14.0];
//    detailLbl.numberOfLines = 0;
//    detailLbl.text = detail;
//    
//    CGSize size = [detailLbl.text sizeWithFont:detailLbl.font
//                             constrainedToSize:CGSizeMake(detailLbl.frame.size.width, MAXFLOAT)
//                                 lineBreakMode:NSLineBreakByWordWrapping];
//    
//    totalHeight += size.height+10;
//    
//    return totalHeight;
    
    return 0;
}

@end
