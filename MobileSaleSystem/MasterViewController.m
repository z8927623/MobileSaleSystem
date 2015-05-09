//
//  MasterViewController.m
//  MobileSaleSystem
//
//  Created by wildyao on 14/12/26.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import "MasterViewController.h"
#import "NavigationViewController.h"
#import "LoginViewController.h"
#import "ClientManageViewController.h"
#import "FundsApplyViewController.h"
#import "AfterSaleServiceViewController.h"
#import "MyInfoViewController.h"
#import "ActivityPlanViewController.h"
#import "SignInManageViewController.h"

@interface MasterViewController ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;

@property (nonatomic, assign) BOOL forManager;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([[NSUserDefaults standardUserDefaults] objectForKey:ManagerIdKey]) {
        [self configForManager];
    } else if ([[NSUserDefaults standardUserDefaults] objectForKey:UserIdKey]) {
        [self configForSalesman];
    } else {
        [self configForSalesman];
    }
    
    [self fetchMyInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchMyInfo) name:NotiLogin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(layout:) name:NotiLoginLayout object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAvatar:) name:NotiAvatar object:nil];
}

- (void)reloadAvatar:(NSNotification *)noti
{
    UIImage *image = noti.object;
    self.userAvatar.image = image;
}

- (void)layout:(NSNotification *)noti
{
    NSNumber *num = noti.object;
    if ([num isEqualToNumber:@(0)]) {
        [self configForSalesman];
    } else {
        [self configForManager];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:UserNameKey];
    if (name) {
        self.nameLbl.text = name;
    }
}

- (void)fetchMyInfo
{
    [HTTPManager getUserInfoWithUserId:nil completionBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"jsonDic: %@\n%@", jsonObject, jsonString);
        NSString *result_code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        
        if ([result_code isEqualToString:@"0"]) {
            
            NSDictionary *dic = jsonObject[@"data"];
            self.nameLbl.text = dic[@"nickName"];
            
            NSString *urlString = [NSString stringWithFormat:@"%@%@", Base_Url , [dic[@"headPic"] substringFromIndex:1]];
            [self.userAvatar setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"0.png"]];
            
            [[NSUserDefaults standardUserDefaults] setObject:self.nameLbl.text forKey:UserNameKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        } else {

        }
        
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"err: %@", error);
    }];
}


- (void)logout
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserIdKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserNameKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:ManagerIdKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.nameLbl.text = @"姓名";
    self.userAvatar.image = [UIImage imageNamed:@"0.png"];
    
    LoginViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)configForSalesman
{
    self.forManager = NO;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
    
    if (!self.mapView) {
        [self initMapView];
    }
    
    if (!self.search) {
        [self initSearch];
    }
    

    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"MM-dd HH:mm"];

    self.dateLbl.text = [self.dateFormatter stringFromDate:[NSDate date]];
    self.roleLbl.text = @"销售员";
    self.firstLbl.text = @"客户管理";
    self.secondLbl.text = @"经费申请";
    
    [self.thirdBtn setBackgroundImage:[UIImage imageNamed:@"3.jpg"] forState:UIControlStateNormal];
    self.thirdLbl.text = @"售后服务";
    
    [self.fourthBtn setBackgroundImage:[UIImage imageNamed:@"4.jpg"] forState:UIControlStateNormal];
    self.fourthLbl.text = @"活动计划";

    if (![[NSUserDefaults standardUserDefaults] objectForKey:UserIdKey]) {
        LoginViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
        [self presentViewController:nav animated:YES completion:nil];
    }

//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStylePlain target:self action:@selector(login)];
    
//    self.fourthBtn.hidden = NO;
//    self.fourthLbl.hidden = NO;
    self.fifthBtn.hidden = NO;
    self.fifthLbl.hidden = NO;
    self.sixthBtn.hidden = NO;
    self.sixthLbl.hidden = NO;
    self.seventhBtn.hidden = NO;
    self.seventhLbl.hidden = NO;
    self.eighthBtn.hidden = NO;
    self.eighthLbl.hidden = NO;
}

- (void)configForManager
{
    self.forManager = YES;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"MM-dd HH:mm"];
    
    self.dateLbl.text = [self.dateFormatter stringFromDate:[NSDate date]];
    
    self.roleLbl.text = @"经理";
    self.firstLbl.text = @"我的销售员";
    self.secondLbl.text = @"经费审批";
    
    [self.thirdBtn setBackgroundImage:[UIImage imageNamed:@"6.png"] forState:UIControlStateNormal];
    self.thirdLbl.text = @"签到信息";
    
    [self.fourthBtn setBackgroundImage:[UIImage imageNamed:@"8.jpg"] forState:UIControlStateNormal];
    self.fourthLbl.text = @"我的资料";
    
//    self.fourthBtn.hidden = YES;
//    self.fourthLbl.hidden = YES;
    self.fifthBtn.hidden = YES;
    self.fifthLbl.hidden = YES;
    self.sixthBtn.hidden = YES;
    self.sixthLbl.hidden = YES;
    self.seventhBtn.hidden = YES;
    self.seventhLbl.hidden = YES;
    self.eighthBtn.hidden = YES;
    self.eighthLbl.hidden = YES;
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:ManagerIdKey]) {
        LoginViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (void)login
{
    LoginViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
    [self presentViewController:nav animated:YES completion:nil];
}

//- (void)configData
//{
//    NSArray *clientArr = @[
//                           @{ @"name" : @"haha", @"phone" : @"12345", @"email" : @"123@qq.com", @"gender" : @"男", @"age" : @"17", @"address" : @"dsfsdf" },
//                           @{ @"name" : @"haha", @"phone" : @"12345", @"email" : @"123@qq.com", @"gender" : @"男", @"age" : @"17", @"address" : @"dsfsdf" },
//                           @{ @"name" : @"haha", @"phone" : @"12345", @"email" : @"123@qq.com", @"gender" : @"男", @"age" : @"17", @"address" : @"dsfsdf" },
//                           @{ @"name" : @"haha", @"phone" : @"12345", @"email" : @"123@qq.com", @"gender" : @"男", @"age" : @"17", @"address" : @"dsfsdf" },
//                           @{ @"name" : @"haha", @"phone" : @"12345", @"email" : @"123@qq.com", @"gender" : @"男", @"age" : @"17", @"address" : @"dsfsdf" },
//                           @{ @"name" : @"haha", @"phone" : @"12345", @"email" : @"123@qq.com", @"gender" : @"男", @"age" : @"17", @"address" : @"dsfsdf" },
//                           @{ @"name" : @"haha", @"phone" : @"12345", @"email" : @"123@qq.com", @"gender" : @"男", @"age" : @"17", @"address" : @"dsfsdf" },
//                           @{ @"name" : @"haha", @"phone" : @"12345", @"email" : @"123@qq.com", @"gender" : @"男", @"age" : @"17", @"address" : @"dsfsdf" },
//                           @{ @"name" : @"haha", @"phone" : @"12345", @"email" : @"123@qq.com", @"gender" : @"男", @"age" : @"17", @"address" : @"dsfsdf" },
//                           @{ @"name" : @"haha", @"phone" : @"12345", @"email" : @"123@qq.com", @"gender" : @"男", @"age" : @"17", @"address" : @"dsfsdf" },
//                           @{ @"name" : @"haha", @"phone" : @"12345", @"email" : @"123@qq.com", @"gender" : @"男", @"age" : @"17", @"address" : @"dsfsdf" },
//                           @{ @"name" : @"haha", @"phone" : @"12345", @"email" : @"123@qq.com", @"gender" : @"男", @"age" : @"17", @"address" : @"dsfsdf" },
//                           @{ @"name" : @"haha", @"phone" : @"12345", @"email" : @"123@qq.com", @"gender" : @"男", @"age" : @"17", @"address" : @"dsfsdf" },
//                           @{ @"name" : @"haha", @"phone" : @"12345", @"email" : @"123@qq.com", @"gender" : @"男", @"age" : @"17", @"address" : @"dsfsdf" },
//                           @{ @"name" : @"haha", @"phone" : @"12345", @"email" : @"123@qq.com", @"gender" : @"男", @"age" : @"17", @"address" : @"dsfsdf" },
//                           @{ @"name" : @"haha", @"phone" : @"12345", @"email" : @"123@qq.com", @"gender" : @"男", @"age" : @"17", @"address" : @"dsfsdf" }
//                           ];
//
//    [[NSUserDefaults standardUserDefaults] setObject:clientArr forKey:ClientListKey];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}

- (IBAction)onBtnToRoute:(id)sender {
//    NavigationViewController *navVC = [[NavigationViewController alloc] init];
//    navVC.mapView = self.mapView;
//    navVC.search = self.search;
//    [self.navigationController pushViewController:navVC animated:YES];
    
//    NavigationViewController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationViewController"];
//    navVC.mapView = self.mapView;
//    navVC.search = self.search;
//    [self.navigationController pushViewController:navVC animated:YES];
    
//    [self performSegueWithIdentifier:@"toNav" sender:nil];
}

- (void)initMapView
{
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
}

/* 初始化search. */
- (void)initSearch
{
    self.search = [[AMapSearchAPI alloc] initWithSearchKey:[MAMapServices sharedServices].apiKey Delegate:nil];
}


- (void)viewDidAppear:(BOOL)animated
{
//    [self performSegueWithIdentifier:@"toLogin" sender:nil];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toNav"]) {
        NavigationViewController *navVC = segue.destinationViewController;
        navVC.mapView = self.mapView;
        navVC.search = self.search;
    }
}

- (IBAction)onBtnToManage:(id)sender {
    if (!self.forManager) {
        ClientManageViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"clientmanage"];
        vc.forManager = NO;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        ClientManageViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"clientmanage"];
        vc.forManager = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)onBtnToFunds:(id)sender {
    if (!self.forManager) {
        FundsApplyViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"fundsapply"];
        vc.forManager = NO;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        FundsApplyViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"fundsapply"];
        vc.forManager = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)onBtnToAfterSaleOrManagersInfo:(id)sender {
    if (!self.forManager) {
        AfterSaleServiceViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"aftersale"];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        SignInManageViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"signin"];
        vc.forManager = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)onBtnToActivity:(id)sender {
    if (!self.forManager) {
        ActivityPlanViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"activity"];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        MyInfoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"myinfo"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
