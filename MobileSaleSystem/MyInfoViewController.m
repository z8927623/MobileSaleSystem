//
//  MyInfoViewController.m
//  MobileSaleSystem
//
//  Created by Wild Yaoyao on 14/12/25.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import "MyInfoViewController.h"
#import "EditMyInfoViewController.h"

@interface MyInfoViewController ()

@end

@implementation MyInfoViewController

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
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(onBtnEdit:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:UserIdKey] && ![[NSUserDefaults standardUserDefaults] objectForKey:ManagerIdKey]) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [SVProgressHUD showHUDWithImage:nil status:@"请登录" duration:TimeInterval];
        return;
    } 

    [self fetchMyInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload1) name:Noti1 object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAvatar) name:NotiAvatar object:nil];
}

- (void)reload1
{
    self.myNameLbl.text = self.dic[@"nickName"];
    self.phoneLbl.text = self.dic[@"linkPhone"];
    self.emailLbl.text = self.dic[@"email"];
    self.genderLbl.text = self.dic[@"sex"];
    self.ageLbl.text = self.dic[@"age"];
    self.addressLbl.text = self.dic[@"address"];
}

- (void)reloadAvatar
{
    self.avatarIv.image = self.dic[@"headPic"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    

}

- (void)fetchMyInfo
{
    [SVProgressHUD showProgress];
    
    [HTTPManager getUserInfoWithUserId:nil completionBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"jsonDic: %@\n%@", jsonObject, jsonString);
        NSString *result_code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        
        if ([result_code isEqualToString:@"0"]) {
            [SVProgressHUD dismiss];
            
            NSDictionary *dic = jsonObject[@"data"];
            
            self.dic = [dic mutableCopy];
            
            self.myNameLbl.text = dic[@"nickName"];
            self.phoneLbl.text = dic[@"linkPhone"];
            self.emailLbl.text = dic[@"email"];
            self.genderLbl.text = dic[@"sex"];
            self.ageLbl.text = dic[@"age"];
            self.addressLbl.text = dic[@"address"];
            NSString *urlString = [NSString stringWithFormat:@"%@%@", Base_Url , [dic[@"headPic"] substringFromIndex:1]];
            [self.avatarIv setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"0.png"]];
            
        } else {
            [SVProgressHUD showHUDWithImage:nil status:@"失败" duration:TimeInterval];
        }
        
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showHUDWithImage:nil status:@"失败" duration:TimeInterval];
        NSLog(@"err: %@", error);
    }];
}

- (void)onBtnEdit:(id)sender
{
    EditMyInfoViewController *editVC = [self.storyboard instantiateViewControllerWithIdentifier:@"editmyinfo"];
    editVC.dic = _dic;
    [self.navigationController pushViewController:editVC animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
