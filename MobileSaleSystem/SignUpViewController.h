//
//  SignUpViewController.h
//  MobileSaleSystem
//
//  Created by Wild Yaoyao on 14/12/27.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import "CommonViewController.h"

@interface SignUpViewController : CommonViewController

@property (weak, nonatomic) IBOutlet UITextField *field1;
@property (weak, nonatomic) IBOutlet UITextField *field2;
@property (weak, nonatomic) IBOutlet UIButton *salerBtn;
@property (weak, nonatomic) IBOutlet UIButton *managerBtn;

- (IBAction)onBtnSaler:(id)sender;
- (IBAction)onBtnManager:(id)sender;

@end
