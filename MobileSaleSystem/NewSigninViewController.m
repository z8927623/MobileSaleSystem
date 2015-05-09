//
//  NewSigninViewController.m
//  MobileSaleSystem
//
//  Created by wildyao on 15/3/23.
//  Copyright (c) 2015年 Yang Yao. All rights reserved.
//

#import "NewSigninViewController.h"
#import "CKCalendarView.h"

@interface NewSigninViewController () <CKCalendarDelegate>

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation NewSigninViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(onBtnCancel:)];

    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"新建签到";


    self.lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 74, self.view.frame.size.width-20, 30)];
    self.lbl.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.lbl];
    
    self.addressLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, _lbl.frame.origin.y+_lbl.frame.size.height+10, 0, 0)];
    self.addressLbl.text = @"签到地点：";
    self.addressLbl.font = [UIFont systemFontOfSize:15];
    [self.addressLbl sizeToFit];
    [self.view addSubview:self.addressLbl];
    
    self.field = [[UITextField alloc] initWithFrame:CGRectMake(_addressLbl.right, _addressLbl.top-5, self.view.width-10-_addressLbl.right, 30)];
    self.field.borderStyle = UITextBorderStyleRoundedRect;
    self.field.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.field];
    
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startSunday];
    calendar.delegate = self;
    calendar.frame = CGRectMake(10, self.field.bottom+10, self.view.frame.size.width-20, 470);
    [self.view addSubview:calendar];
    
    NSString *dateString = [self.dateFormatter stringFromDate:[NSDate date]];
    self.lbl.text = [NSString stringWithFormat:@"签到时间：%@", dateString];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismiss)];
    [self.view addGestureRecognizer:tap];
    
    
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    //    [self.locationManager requestAlwaysAuthorization];   // iOS8 配合plist NSLocationAlwaysUsageDescription
//    [self.locationManager requestWhenInUseAuthorization];  // iOS8，配合plist NSLocationWhenInUseUsageDescription
    [self.locationManager setDelegate:self];
    [self.locationManager startUpdatingLocation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
    __weak typeof(self) weakSelf = self;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    // 根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            CLPlacemark *placemark = [array objectAtIndex:0];
            
            NSString *country = placemark.country;
            NSString *province = placemark.administrativeArea;
            NSString *city = placemark.locality;
            
            if (!city) {
                // 四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            
            NSLog(@"city = %@  province: %@ country: %@", city, province, country);
 
            self.field.text = placemark.name;
//            self.addressLbl.text = [NSString stringWithFormat:@"签到地点：%@", self.field.text];
            
            [self.locationManager stopUpdatingLocation];
            
        } else if (error == nil && [array count] == 0) {
            
            [weakSelf.locationManager stopUpdatingLocation];
            
            NSLog(@"No results were returned.");
            
        } else if (error != nil) {
            
            NSLog(@"An error occurred = %@", error);
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"location error");
    
    if ([error code] == kCLErrorDenied) {
        NSLog(@"kCLErrorDenied");
    }
    if ([error code] == kCLErrorLocationUnknown) {
        NSLog(@"kCLErrorLocationUnknown");
    }
}


- (void)dismiss
{
    [self.view endEditing:YES];
}

- (void)save
{
    [self.view endEditing:YES];
    
    [SVProgressHUD showProgress];
    
    [HTTPManager addSignInWithUserId:nil date:self.lbl.text place:self.field.text completionBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"jsonDic: %@\n%@", jsonObject, jsonString);
        NSString *result_code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        
        if ([result_code isEqualToString:@"0"]) {
            [SVProgressHUD showHUDWithImage:nil status:@"成功" duration:TimeInterval];
            [self dismissViewControllerAnimated:YES completion:nil];
            
             [[NSNotificationCenter defaultCenter] postNotificationName:Noti3 object:nil];
        } else {
            [SVProgressHUD showHUDWithImage:nil status:@"失败" duration:TimeInterval];
        }
        
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showHUDWithImage:nil status:@"失败" duration:TimeInterval];
        NSLog(@"err: %@", error);
    }];
}

- (void)onBtnCancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - CKCalendarDelegate
- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date
{
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    
    self.lbl.text = [NSString stringWithFormat:@"签到时间：%@", dateString];
    
    NSLog(@"date: %@", date);
    
    
}

@end
