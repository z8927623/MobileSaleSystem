//
//  AppDelegate.m
//  MobileSaleSystem
//
//  Created by Wild Yaoyao on 14/12/17.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import "AppDelegate.h"
#import "DCIntrospect.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)configureAPIKey
{
    if ([APIKey length] == 0)
    {
#define kMALogTitle @"提示"
#define kMALogContent @"apiKey为空，请检查key是否正确设置"
        
        NSString *log = [NSString stringWithFormat:@"[MAMapKit] %@", kMALogContent];
        NSLog(@"%@", log);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kMALogTitle message:kMALogContent delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
        });
    }
    
    [MAMapServices sharedServices].apiKey = (NSString *)APIKey;
}

// 修正高德在iOS8下无法定位的bug
- (void)fixMAMapLocationOnIOS8
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    
    [UIApplication sharedApplication].idleTimerDisabled = TRUE;
    
    _locationmanager = [[CLLocationManager alloc] init];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 8.0) {
        [_locationmanager requestAlwaysAuthorization];        // NSLocationAlwaysUsageDescription
        [_locationmanager requestWhenInUseAuthorization];     // NSLocationWhenInUseDescription
    }
   
    _locationmanager.delegate = self;
#else
    
#endif
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 使用backBarButtonItem，无法调整位置，但手势返回可用，但是push到第二个页面返回按钮不会随着手势返回而渐变
//    [[UINavigationBar appearance] setTintColor:[UIColor redColor]];
//    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"navigation-bar-back-icon"]];
//    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"navigation-bar-back-icon"]];
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -64) forBarMetrics:UIBarMetricsDefault];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self configureAPIKey];
    [self fixMAMapLocationOnIOS8];
    [self setupInterfaceDebug];
    
    return YES;
}


- (void)setupInterfaceDebug
{
#if DEBUG
    // create a custom tap gesture recognizer so introspection can be invoked from a device
    // this one is a two finger triple tap
    UITapGestureRecognizer *defaultGestureRecognizer = [[UITapGestureRecognizer alloc] init];
    defaultGestureRecognizer.cancelsTouchesInView = NO;
    defaultGestureRecognizer.delaysTouchesBegan = NO;
    defaultGestureRecognizer.delaysTouchesEnded = NO;
    defaultGestureRecognizer.numberOfTapsRequired = 2;
    defaultGestureRecognizer.numberOfTouchesRequired = 2;
    [DCIntrospect sharedIntrospector].invokeGestureRecognizer = defaultGestureRecognizer;
    
    UITapGestureRecognizer *defaultGestureRecognizer_ = [[UITapGestureRecognizer alloc] init];
    defaultGestureRecognizer_.cancelsTouchesInView = NO;
    defaultGestureRecognizer_.delaysTouchesBegan = NO;
    defaultGestureRecognizer_.delaysTouchesEnded = NO;
    defaultGestureRecognizer_.numberOfTapsRequired = 2;
    defaultGestureRecognizer_.numberOfTouchesRequired = 3;
    [DCIntrospect sharedIntrospector].invokeAllOutlinesGestureRecognizer = defaultGestureRecognizer_;
    
    // always insert this AFTER makeKeyAndVisible so statusBarOrientation is reported correctly.
    [[DCIntrospect sharedIntrospector] start];
#endif
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
