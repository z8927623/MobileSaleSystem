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

@interface MasterViewController ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initMapView];
    [self initSearch];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"MM-dd HH:mm"];
 
    self.dateLbl.text = [self.dateFormatter stringFromDate:[NSDate date]];
    
//    if (![[NSUserDefaults standardUserDefaults] objectForKey:UserKey]) {
//        LoginViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
//        [self presentViewController:nav animated:YES completion:nil];
//    }
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

@end
