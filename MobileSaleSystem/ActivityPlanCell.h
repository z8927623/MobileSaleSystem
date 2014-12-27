//
//  ActivityPlanCell.h
//  MobileSaleSystem
//
//  Created by wildyao on 14/12/26.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlanModel.h"

@interface ActivityPlanCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *creator;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *detailLbl;

@property (strong, nonatomic) PlanModel *model;

+ (CGFloat)getCellHeight:(NSString *)detail width:(CGFloat)width;

@end
