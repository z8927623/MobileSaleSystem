//
//  ActivityPlanCell.m
//  MobileSaleSystem
//
//  Created by wildyao on 14/12/26.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import "ActivityPlanCell.h"

#define SPACE 20

@implementation ActivityPlanCell

- (void)awakeFromNib {
    // Initialization code

//    self.timeLbl.backgroundColor = [UIColor cyanColor];
//    self.detailLbl.backgroundColor = [UIColor yellowColor];
}

- (void)setModel:(PlanModel *)model tableView:(UITableView *)tableView
{
    if (_model != model) {
        _model = model;
        
        self.timeLbl.text = _model.time;
        self.detailLbl.text = _model.detail;
        
        // 调整大小
        CGRect frame = self.timeLbl.frame;
        CGFloat left = self.creator.frame.origin.x+self.creator.frame.size.width+SPACE;
        CGFloat right = tableView.frame.size.width-20;
        frame.origin.x = left;
        frame.size.width = right-left;
        self.timeLbl.frame = frame;
        
        frame = self.detailLbl.frame;
        frame.size.width = tableView.frame.size.width-40;
        self.detailLbl.frame = frame;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize size;
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
        
        CGRect textRect = [self.detailLbl.text boundingRectWithSize:CGSizeMake(self.frame.size.width-40, MAXFLOAT)
                                                            options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                         attributes:@{NSFontAttributeName:self.detailLbl.font}
                                                            context:nil];
        size = textRect.size;
    } else {
        size = [self.detailLbl.text sizeWithFont:self.detailLbl.font
                                 constrainedToSize:CGSizeMake(self.frame.size.width-40, MAXFLOAT)
                                     lineBreakMode:NSLineBreakByWordWrapping];
        
    }

//#if __IPHONE_OS_VERSION_MAX_ALLOWED  >= 70000
//        
//        CGRect textRect = [self.detailLbl.text boundingRectWithSize:CGSizeMake(self.frame.size.width-40, MAXFLOAT)
//                                                            options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
//                                                         attributes:@{NSFontAttributeName:self.detailLbl.font}
//                                                            context:nil];
//        size = textRect.size;
//#else
//        size = [self.detailLbl.text sizeWithFont:self.detailLbl.font
//                               constrainedToSize:CGSizeMake(self.frame.size.width-40, MAXFLOAT)
//                                   lineBreakMode:NSLineBreakByWordWrapping];
//        
//#endif

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
    
    CGSize size;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
        
        CGRect textRect = [detailLbl.text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                                            options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                         attributes:@{NSFontAttributeName:detailLbl.font}
                                                            context:nil];
        size = textRect.size;
    } else {
        size = [detailLbl.text sizeWithFont:detailLbl.font
                           constrainedToSize:CGSizeMake(width, MAXFLOAT)
                               lineBreakMode:NSLineBreakByWordWrapping];
        
    }
    
    
    totalHeight += size.height+10;
    
    return totalHeight;
}

@end
