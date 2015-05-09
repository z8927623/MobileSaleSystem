//
//  EditClientViewController.h
//  MobileSaleSystem
//
//  Created by wildyao on 14/12/26.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import "CommonViewController.h"

@interface EditClientViewController : CommonViewController

@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *genderField;
@property (weak, nonatomic) IBOutlet UITextField *ageField;
@property (weak, nonatomic) IBOutlet UITextField *addressField;

@property (nonatomic, strong) NSMutableDictionary *dic;

- (IBAction)onBtnChooseImage:(id)sender;
- (IBAction)tapAction:(id)sender;

@property (nonatomic, assign) BOOL forManager;

@end
