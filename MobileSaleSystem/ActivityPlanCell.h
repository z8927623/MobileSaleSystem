//
//  ActivityPlanCell.h
//  MobileSaleSystem
//
//  Created by wildyao on 14/12/26.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityPlanCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *creator;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *detailLbl;

+ (CGFloat)getCellHeight:(NSString *)detail;


@end
