//
//  MasterViewController.m
//  MobileSaleSystem
//
//  Created by wildyao on 14/12/26.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import "MasterViewController.h"
#import "NavigationViewController.h"

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
}

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
