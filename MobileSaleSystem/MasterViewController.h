//
//  MasterViewController.h
//  MobileSaleSystem
//
//  Created by wildyao on 14/12/26.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import "CommonViewController.h"

@interface MasterViewController : CommonViewController

@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;
@property (weak, nonatomic) IBOutlet UILabel *roleLbl;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;

@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UILabel *firstLbl;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet UILabel *secondLbl;
@property (weak, nonatomic) IBOutlet UIButton *thirdBtn;
@property (weak, nonatomic) IBOutlet UILabel *thirdLbl;
@property (weak, nonatomic) IBOutlet UIButton *fourthBtn;
@property (weak, nonatomic) IBOutlet UILabel *fourthLbl;
@property (weak, nonatomic) IBOutlet UIButton *fifthBtn;
@property (weak, nonatomic) IBOutlet UILabel *fifthLbl;
@property (weak, nonatomic) IBOutlet UIButton *sixthBtn;
@property (weak, nonatomic) IBOutlet UILabel *sixthLbl;
@property (weak, nonatomic) IBOutlet UIButton *seventhBtn;
@property (weak, nonatomic) IBOutlet UILabel *seventhLbl;
@property (weak, nonatomic) IBOutlet UIButton *eighthBtn;
@property (weak, nonatomic) IBOutlet UILabel *eighthLbl;

- (IBAction)onBtnToManage:(id)sender;
- (IBAction)onBtnToFunds:(id)sender;
- (IBAction)onBtnToAfterSaleOrManagersInfo:(id)sender;
- (IBAction)onBtnToActivity:(id)sender;




@end
