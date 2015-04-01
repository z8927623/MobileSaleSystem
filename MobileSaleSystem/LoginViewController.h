//
//  LoginViewController.h
//  MobileSaleSystem
//
//  Created by Wild Yaoyao on 14/12/27.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import "CommonViewController.h"

@interface LoginViewController : CommonViewController

@property (weak, nonatomic) IBOutlet UITextField *field1;
@property (weak, nonatomic) IBOutlet UITextField *field2;


- (IBAction)onBtnClose:(id)sender;

@end
