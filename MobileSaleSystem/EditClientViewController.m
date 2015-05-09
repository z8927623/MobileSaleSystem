//
//  EditClientViewController.m
//  MobileSaleSystem
//
//  Created by wildyao on 14/12/26.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import "EditClientViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

#define StatusAndNavigationHeight 64

@interface EditClientViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIImage *chosenImage;
@property (nonatomic, assign) CGFloat keyboardHeight;

@end

@implementation EditClientViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(onBtnSave:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismiss)];
    [self.view addGestureRecognizer:tap];
    
    
    if (!self.forManager) {
        self.navigationItem.title = @"编辑客户信息";
    } else {
        self.navigationItem.title = @"编辑销售员信息";
    }
    
    
    if (!self.forManager) {
        self.nameField.text = self.dic[@"name"];
        self.phoneField.text = self.dic[@"linkPhone"];
        self.emailField.text = self.dic[@"email"];
        self.genderField.text = self.dic[@"sex"];
        self.ageField.text = self.dic[@"age"];
        self.addressField.text = self.dic[@"address"];
    } else {
        self.nameField.text = self.dic[@"nickName"];
        self.phoneField.text = self.dic[@"linkPhone"];
        self.emailField.text = self.dic[@"email"];
        self.genderField.text = self.dic[@"sex"];
        self.ageField.text = self.dic[@"age"];
        self.addressField.text = self.dic[@"address"];
    }
       
    if ([self.dic[@"headPic"] isKindOfClass:[UIImage class]]) {
        self.avatarImage.image = self.dic[@"headPic"];
    } else {
        NSString *urlString = [NSString stringWithFormat:@"%@%@", Base_Url , [self.dic[@"headPic"] substringFromIndex:1]];
        [self.avatarImage setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"0.png"]];
    }
}

- (void)dismiss
{
    [self.view endEditing:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)onBtnSave:(id)sender
{
    [self.view endEditing:YES];
    
    [SVProgressHUD showProgress];
    
    if (!self.forManager) {
        [HTTPManager editClientInfoWithUserId:nil clientId:self.dic[@"id"] name:self.nameField.text age:self.ageField.text phone:self.phoneField.text sex:self.genderField.text address:self.addressField.text email:self.emailField.text headPic:nil completionBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"jsonDic: %@\n%@", jsonObject, jsonString);
            NSString *result_code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
            if ([result_code isEqualToString:@"0"]) {
                [SVProgressHUD dismiss];
                [self.dic setObject:self.nameField.text forKey:@"name"];
                [self.dic setObject:self.phoneField.text forKey:@"linkPhone"];
                [self.dic setObject:self.emailField.text forKey:@"email"];
                [self.dic setObject:self.genderField.text forKey:@"sex"];
                [self.dic setObject:self.ageField.text forKey:@"age"];
                [self.dic setObject:self.addressField.text forKey:@"address"];
//                [self.dic setObject:self.chosenImage forKey:@"headPic"];
                [self.navigationController popViewControllerAnimated:YES];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:Noti1 object:nil];
                
            } else {
                [SVProgressHUD showHUDWithImage:nil status:@"失败" duration:TimeInterval];
            }
        } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showHUDWithImage:nil status:@"失败" duration:TimeInterval];
            NSLog(@"err: %@", error);
        }];
    } else {
        [HTTPManager editUserInfoWithUserId:_dic[@"id"] name:self.nameField.text age:self.ageField.text phone:self.phoneField.text sex:self.genderField.text address:self.addressField.text email:self.emailField.text headPic:[UIImageJPEGRepresentation(self.chosenImage, 0.1) base64Encoding] completionBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"jsonDic: %@\n%@", jsonObject, jsonString);
            NSString *result_code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
            if ([result_code isEqualToString:@"0"]) {
                [SVProgressHUD dismiss];
                
                [self.dic setObject:self.nameField.text forKey:@"nickName"];
                [self.dic setObject:self.phoneField.text forKey:@"linkPhone"];
                [self.dic setObject:self.emailField.text forKey:@"email"];
                [self.dic setObject:self.genderField.text forKey:@"sex"];
                [self.dic setObject:self.ageField.text forKey:@"age"];
                [self.dic setObject:self.addressField.text forKey:@"address"];
                [self.navigationController popViewControllerAnimated:YES];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:Noti1 object:nil];
                
                [[NSUserDefaults standardUserDefaults] setObject:self.nameField.text forKey:UserNameKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            } else {
                [SVProgressHUD showHUDWithImage:nil status:@"失败" duration:TimeInterval];
            }
        } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showHUDWithImage:nil status:@"失败" duration:TimeInterval];
            NSLog(@"err: %@", error);
        }];
    }
}

- (IBAction)onBtnChooseImage:(id)sender {
//    [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"用户相册", nil];
    [actionSheet showInView:self.view];
}

- (IBAction)tapAction:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark - Notification

// 监听键盘frame变化
- (void)keyboardWillChangeFrameNotification:(NSNotification *)notification
{
    NSValue *value = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect frame = [value CGRectValue];
    
    self.keyboardHeight = frame.size.height;
    
    for (UIView *view in self.view.subviews) {

        if ([view isKindOfClass:[UITextField class]] && view.isFirstResponder) {
            UITextField *textField = (UITextField *)view;

            if (textField.frame.origin.y+textField.frame.size.height+20 > self.view.frame.size.height-self.keyboardHeight) {
                
                CGFloat newFieldFrameY = self.view.frame.size.height-self.keyboardHeight-textField.frame.size.height-30;
                CGFloat delta = textField.frame.origin.y-newFieldFrameY;
                
                [UIView animateWithDuration:0.35 animations:^{
                    CGRect frame = self.view.frame;
                    frame.origin.y = -delta;
                    self.view.frame = frame;
                }];
            }
        }
    }
}

- (void)keyboardWillHideNotification:(NSNotification *)notification
{
    [UIView animateWithDuration:0.35 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        self.view.frame = frame;
    }];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CGRect rectToWindow = [self.view.superview convertRect:textField.frame fromView:self.view];
    
    if (textField.frame.origin.y+textField.frame.size.height+20 > self.view.frame.size.height-self.keyboardHeight) {
        
        CGFloat newFieldFrameY = self.view.frame.size.height-self.keyboardHeight-textField.frame.size.height-30;
        CGFloat delta = textField.frame.origin.y-newFieldFrameY;
        
        [UIView animateWithDuration:0.35 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = -delta;
            self.view.frame = frame;
        }];
        
    } else if (rectToWindow.origin.y - StatusAndNavigationHeight < 0) {
        
        [UIView animateWithDuration:0.35 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y += 30;
            self.view.frame = frame;
        }];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger currentTag = textField.tag;
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UITextField class]] && (view.tag - currentTag == 1)) {
            UITextField *textField = (UITextField *)view;
            [textField becomeFirstResponder];
            break;
        } else {
            [textField resignFirstResponder];
        }

    }
//    [self keyboardWillChangeFrameNotification:nil];
    return YES;
}

#pragma mark - UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerControllerSourceType sourceType;
    if (buttonIndex == 0) {
        // 拍照
        BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (!isCamera) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"此设备没有摄像头" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            return;
        }
        sourceType = UIImagePickerControllerSourceTypeCamera;
        
    } else if (buttonIndex == 1) {
        // 用户相册
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else if (buttonIndex == 2) {
        // 取消
        return;
    }
    
//    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//    imagePicker.sourceType = sourceType;
//    imagePicker.delegate = self;
//    [self presentViewController:imagePicker animated:YES completion:nil];
    
    [self getMediaFromSource:sourceType];
}

- (void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType
{
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    
    if ([UIImagePickerController isSourceTypeAvailable:sourceType] && [mediaTypes count] > 0) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        /** photo and video
         NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
         picker.mediaTypes = mediaTypes;
         */
        // only photo
        picker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error accessing media" message:@"Device doesn't support that media source" delegate:nil cancelButtonTitle:@"Drat!" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)uploadAvatar:(NSString *)avatar ID:(NSNumber *)ID type:(int)type
{
    [SVProgressHUD showProgress];
    
    [HTTPManager uploadAvatar:avatar ID:ID type:type completionBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"jsonDic: %@\n%@", jsonObject, jsonString);
        NSString *result_code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        if ([result_code isEqualToString:@"0"]) {
            [SVProgressHUD showHUDWithImage:nil status:@"成功" duration:TimeInterval];
            
            [self.dic setObject:self.chosenImage forKey:@"headPic"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotiAvatar object:nil];
            
        } else {
            [SVProgressHUD showHUDWithImage:nil status:@"失败" duration:TimeInterval];
        }
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showHUDWithImage:nil status:@"失败" duration:TimeInterval];
        NSLog(@"err: %@", error);
    }];
}

#pragma mark - UIImagePickerController delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    self.chosenImage = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        int type = self.forManager ? 0 : 1;
        [self uploadAvatar:[UIImageJPEGRepresentation(self.chosenImage, 0.1) base64Encoding] ID:self.dic[@"id"] type:type];
        
        self.avatarImage.image = chosenImage;
    }];
}

- (void)imageWasSavedSuccessfully:(UIImage *)paramImage
         didFinishSavingWithError:(NSError *)paramError
                      contextInfo:(void *)paramContextInfo
{
    if (paramError == nil) {
        NSLog(@"Image was saved successfully.");
        
    } else {
        NSLog(@"An error happened while saving the image");
        NSLog(@"Error = %@", paramError);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
