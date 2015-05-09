//
//  MyInfoViewController.h
//  MobileSaleSystem
//
//  Created by Wild Yaoyao on 14/12/25.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import "CommonViewController.h"

@interface MyInfoViewController : CommonViewController

@property (weak, nonatomic) IBOutlet UIImageView *avatarIv;
@property (nonatomic, strong) NSMutableDictionary *dic;
@property (weak, nonatomic) IBOutlet UILabel *myNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *phoneLbl;
@property (weak, nonatomic) IBOutlet UILabel *emailLbl;
@property (weak, nonatomic) IBOutlet UILabel *genderLbl;
@property (weak, nonatomic) IBOutlet UILabel *ageLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;

@end
