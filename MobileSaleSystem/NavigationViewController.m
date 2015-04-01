//
//  NavigationViewController.m
//  SearchV3Demo
//
//  Created by songjian on 13-8-14.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "NavigationViewController.h"
#import "RouteDetailViewController.h"
#import "CommonUtility.h"
#import "LineDashPolyline.h"
#import "GeocodeAnnotation.h"
#import "GeoDetailViewController.h"
#import "ReGeocodeAnnotation.h"
#import "CusAnnotationView.h"

const NSString *NavigationViewControllerStartTitle       = @"起点";
const NSString *NavigationViewControllerDestinationTitle = @"终点";

@interface NavigationViewController () <UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) AMapSearchType searchType;
@property (nonatomic, strong) AMapRoute *route;
@property (nonatomic, strong) MAAnnotationView *userLocationAnnotationView;

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *displayController;

@property (nonatomic, strong) NSMutableArray *tips;

// 当前路线方案索引值.
@property (nonatomic) NSInteger currentCourse;
// 路线方案个数.
@property (nonatomic) NSInteger totalCourse;

@property (nonatomic, strong) UIBarButtonItem *previousItem;
@property (nonatomic, strong) UIBarButtonItem *nextItem;

// 起始点经纬度.
@property (nonatomic) CLLocationCoordinate2D startCoordinate;
// 终点经纬度.
@property (nonatomic) CLLocationCoordinate2D destinationCoordinate;

@property (nonatomic, strong) CusAnnotationView *annotationView;

@property (nonatomic, strong) UITapGestureRecognizer *tap;

@property (nonatomic, assign) CGPoint annotationPoint;

@end

@implementation NavigationViewController

@synthesize userLocationAnnotationView = _userLocationAnnotationView;
@synthesize searchType  = _searchType;
@synthesize route       = _route;

@synthesize currentCourse = _currentCourse;
@synthesize totalCourse   = _totalCourse;

@synthesize previousItem = _previousItem;
@synthesize nextItem     = _nextItem;

@synthesize startCoordinate         = _startCoordinate;
@synthesize destinationCoordinate   = _destinationCoordinate;


#pragma mark - Life Cycle

- (id)init
{
    if (self = [super init]) {

    }
    
    return self;
}

- (void)startLocation
{
    self.mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
//    self.mapView.userTrackingMode = MAUserTrackingModeNone;
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initConfiguration];
    
    [self initNavigationBar];
    
    [self initToolBar];
    
    [self updateCourseUI];
    
    [self updateDetailUI];
    
    [self initNavigationTitle:@"路线规划"];
    
    [self initSearchBar];
    [self initSearchDisplay];

    [self initSourceDestinationBtn];
    
    [self startLocation];
    
    [self initGestureRecognizer];
}

- (void)dealloc {
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController setToolbarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController setToolbarHidden:YES animated:animated];
}

#pragma mark - Initialization

- (void)initGestureRecognizer
{
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.mapView addGestureRecognizer:self.tap];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture
{
    [SVProgressHUD showHUDWithImage:nil status:@"请稍候" duration:-1];
    
    // 关闭定位功能
    self.mapView.showsUserLocation = NO;
    self.mapView.customizeUserLocationAccuracyCircleRepresentation = NO;
    self.mapView.userTrackingMode = MAUserTrackingModeNone;

    
    // 获取触摸点坐标
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:[tapGesture locationInView:self.mapView] toCoordinateFromView:self.mapView];
    
    // 记住点击的点的位置
    self.annotationPoint = CGPointMake(coordinate.latitude, coordinate.longitude);
    
    // 先清除之前的
    [self clearSearch];
    // 初始化搜索
    [self initSearch];
    
    // 搜索位置
    [self searchReGeocodeWithCoordinate:coordinate];
}

- (void)initConfiguration
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.startCoordinate        = CLLocationCoordinate2DMake(39.910267, 116.370888);
    self.destinationCoordinate  = CLLocationCoordinate2DMake(39.989872, 116.481956);
    self.tips = [NSMutableArray array];
}

- (void)initSearch
{
    self.search = [[AMapSearchAPI alloc] initWithSearchKey:[MAMapServices sharedServices].apiKey Delegate:nil];
    self.search.delegate = self;
}

- (void)initNavigationBar
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"详情"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(detailAction)];
}

- (void)initToolBar
{
    UIBarButtonItem *flexbleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                 target:self
                                                                                 action:nil];
    // 导航类型.
    UISegmentedControl *searchTypeSegCtl = [[UISegmentedControl alloc] initWithItems:
                                            [NSArray arrayWithObjects:
                                             @"  驾 车  ",
                                             @"  步 行  ",
                                             @"  公 交  ",
                                             nil]];
    
    searchTypeSegCtl.segmentedControlStyle = UISegmentedControlStyleBar;
    [searchTypeSegCtl addTarget:self action:@selector(searchTypeAction:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *searchTypeItem = [[UIBarButtonItem alloc] initWithCustomView:searchTypeSegCtl];
    
    // 上一个.
    UIBarButtonItem *previousItem = [[UIBarButtonItem alloc] initWithTitle:@"上一个"
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(previousCourseAction)];
    self.previousItem = previousItem;
    
    // 下一个.
    UIBarButtonItem *nextItem = [[UIBarButtonItem alloc] initWithTitle:@"下一个"
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self
                                                                action:@selector(nextCourseAction)];
    self.nextItem = nextItem;
    
    self.toolbarItems = [NSArray arrayWithObjects:flexbleItem, searchTypeItem, flexbleItem, previousItem, flexbleItem, nextItem, flexbleItem, nil];
}

- (void)initSearchBar
{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 44)];
    self.searchBar.barStyle = UIBarStyleDefault;
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"搜索地点";
    self.searchBar.keyboardType = UIKeyboardTypeDefault;
    [self.view addSubview:self.searchBar];
}

- (void)initSearchDisplay
{
    self.displayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchDisplayController.delegate = self;
    self.displayController.searchResultsDataSource = self;
    self.displayController.searchResultsDelegate = self;
}

- (void)initNavigationTitle:(NSString *)title
{
    self.navigationItem.title = title;
}

- (void)initSourceDestinationBtn
{
    UIView *bgView1 = [[UIView alloc] initWithFrame:CGRectMake(20, self.searchBar.frame.origin.y+self.searchBar.frame.size.height+10, self.view.frame.size.width-40, 40)];
    bgView1.backgroundColor = [UIColor whiteColor];
    bgView1.layer.cornerRadius = 5;
    bgView1.layer.borderColor = [[UIColor blackColor] CGColor];
    bgView1.layer.borderWidth = 1;
    [self.view addSubview:bgView1];
    
    self.sourceLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 0, 0)];
    self.sourceLbl.backgroundColor = [UIColor whiteColor];
    self.sourceLbl.text = @"起点：";
    self.sourceLbl.font = [UIFont boldSystemFontOfSize:20];
    [self.sourceLbl sizeToFit];
    self.sourceLbl.centerY = bgView1.height/2;
    [bgView1 addSubview:self.sourceLbl];
    
    self.sourceSiteLbl = [[UILabel alloc] initWithFrame:CGRectMake(_sourceLbl.right-5, 0, bgView1.width-_sourceLbl.right-10, bgView1.height)];
    self.sourceSiteLbl.backgroundColor = [UIColor whiteColor];
    self.sourceSiteLbl.text = @"";
    self.sourceSiteLbl.font = [UIFont systemFontOfSize:13];
    self.sourceSiteLbl.centerY = bgView1.height/2;
    [bgView1 addSubview:self.sourceSiteLbl];
    
    UIButton *sourceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sourceBtn setFrame:bgView1.bounds];
    [sourceBtn addTarget:self action:@selector(onBtnSource:) forControlEvents:UIControlEventTouchUpInside];
    [bgView1 addSubview:sourceBtn];
    
    UIView *bgView2 = [[UIView alloc] initWithFrame:CGRectMake(bgView1.left, bgView1.bottom+10, bgView1.width, bgView1.height)];
    bgView2.backgroundColor = [UIColor whiteColor];
    bgView2.layer.cornerRadius = 5;
    bgView2.layer.borderColor = [[UIColor blackColor] CGColor];
    bgView2.layer.borderWidth = 1;
    [self.view addSubview:bgView2];
    
    self.destinationLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 0, 0)];
    self.destinationLbl.backgroundColor = [UIColor whiteColor];
    self.destinationLbl.text = @"终点：";
    self.destinationLbl.font = self.sourceLbl.font;
    [self.destinationLbl sizeToFit];
    self.destinationLbl.centerY = bgView2.height/2;
    [bgView2 addSubview:self.destinationLbl];
    
    self.destinationSiteLbl = [[UILabel alloc] initWithFrame:CGRectMake(_destinationSiteLbl.right-5, 0, bgView2.width-_destinationLbl.right-10, bgView2.height)];
    self.destinationSiteLbl.backgroundColor = [UIColor whiteColor];
    self.destinationSiteLbl.text = @"";
    self.destinationSiteLbl.font = [UIFont systemFontOfSize:17];
    [self.destinationSiteLbl sizeToFit];
    self.destinationSiteLbl.centerY = bgView1.height/2;
    [bgView1 addSubview:self.destinationSiteLbl];
    
    UIButton *destinationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [destinationBtn setFrame:bgView2.bounds];
    [destinationBtn addTarget:self action:@selector(onBtnDestination:) forControlEvents:UIControlEventTouchUpInside];
    [bgView2 addSubview:destinationBtn];
}

// 更新"上一个", "下一个"按钮状态.
- (void)updateCourseUI
{
    // 上一个.
    self.previousItem.enabled = (self.currentCourse > 0);
    
    // 下一个.
    self.nextItem.enabled = (self.currentCourse < self.totalCourse - 1);
}

// 更新"详情"按钮状态.
- (void)updateDetailUI
{
    self.navigationItem.rightBarButtonItem.enabled = self.route != nil;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *key = searchBar.text;
    
    // 清除annotation并且进行地理搜索
    [self clearAndSearchGeocodeWithKey:key];
     // 收回键盘
    [self.displayController setActive:NO animated:NO];
    
    self.searchBar.placeholder = key;
}

#pragma mark - UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // 输入提示 搜索.
    [self searchTipsWithKey:searchString];
    
    return YES;
}

#pragma mark - MAMapViewDelegate

- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[LineDashPolyline class]]) {
        
        MAPolylineView *overlayView = [[MAPolylineView alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline];
        
        overlayView.lineWidth    = 4;
        overlayView.strokeColor  = [UIColor magentaColor];
        overlayView.lineDash     = YES;

        return overlayView;
    } else if ([overlay isKindOfClass:[MAPolyline class]]) {
        
        MAPolylineView *overlayView = [[MAPolylineView alloc] initWithPolyline:overlay];
        
        overlayView.lineWidth    = 8;
        overlayView.strokeColor  = [UIColor magentaColor];
        
        return overlayView;
    } else if (overlay == mapView.userLocationAccuracyCircle) {  // 自定义定位精度对应的MACircleView.
        
        MACircleView *accuracyCircleView = [[MACircleView alloc] initWithCircle:overlay];
        
        accuracyCircleView.lineWidth    = 2.f;
        accuracyCircleView.strokeColor  = [UIColor lightGrayColor];
        accuracyCircleView.fillColor    = [UIColor colorWithRed:1 green:0 blue:0 alpha:.3];
        
        return accuracyCircleView;
    }
    
    return nil;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
//    if ([annotation isKindOfClass:[MAPointAnnotation class]])
//    {
        static NSString *customReuseIndetifier = @"customReuseIndetifier";
        
        CusAnnotationView *annotationView = (CusAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        
        if (annotationView == nil) {
            annotationView = [[CusAnnotationView alloc] initWithAnnotation:annotation
                                                           reuseIdentifier:customReuseIndetifier];
        }
        
        // must set to NO, so we can show the custom callout view.
        annotationView.canShowCallout   = NO;
        annotationView.draggable        = YES;
        annotationView.calloutOffset    = CGPointMake(0, -5);
        
        annotationView.portrait         = [UIImage imageNamed:@"place_04"];
        annotationView.calloutText             = self.sourceSiteLbl.text;
    
        self.annotationView = annotationView;
        self.userLocationAnnotationView = annotationView;
    
        return annotationView;
//    }
    
//    return nil;
    
    /*
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        
        static NSString *navigationCellIdentifier = @"navigationCellIdentifier";
        
        MAAnnotationView *poiAnnotationView = (MAAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:navigationCellIdentifier];
        
        if (poiAnnotationView == nil) {
            poiAnnotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:navigationCellIdentifier];
        }
        
        poiAnnotationView.canShowCallout = YES;
        
        // 起点.
        if ([[annotation title] isEqualToString:(NSString *)NavigationViewControllerStartTitle]) {
            poiAnnotationView.image = [UIImage imageNamed:@"startPoint"];
        // 终点.
        } else if([[annotation title] isEqualToString:(NSString *)NavigationViewControllerDestinationTitle]) {
            poiAnnotationView.image = [UIImage imageNamed:@"endPoint"];
        }
        
        return poiAnnotationView;
    } else if ([annotation isKindOfClass:[MAUserLocation class]]) {  // 自定义userLocation对应的annotationView.
       
        static NSString *userLocationStyleReuseIndetifier = @"userLocationStyleReuseIndetifier";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
        if (annotationView == nil) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:userLocationStyleReuseIndetifier];
        }
        
        annotationView.image = [UIImage imageNamed:@"userPosition"];
        
        self.userLocationAnnotationView = annotationView;
        
        return annotationView;
        
    } else if ([annotation isKindOfClass:[GeocodeAnnotation class]]) {
        
        static NSString *geoCellIdentifier = @"geoCellIdentifier";
        
        MAPinAnnotationView *poiAnnotationView = (MAPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:geoCellIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation
                                                                reuseIdentifier:geoCellIdentifier];
        }
        
        poiAnnotationView.canShowCallout            = YES;
        poiAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        return poiAnnotationView;
    }
    
    return nil;*/
}

- (void)gotoDetailForGeocode:(AMapGeocode *)geocode
{
    if (geocode != nil) {
        GeoDetailViewController *geoDetailViewController = [[GeoDetailViewController alloc] init];
        geoDetailViewController.geocode = geocode;
        
        [self.navigationController pushViewController:geoDetailViewController animated:YES];
    }
}

// callout点击操作
- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([view.annotation isKindOfClass:[GeocodeAnnotation class]]) {
        [self gotoDetailForGeocode:[(GeocodeAnnotation*)view.annotation geocode]];
    }
}

// 位置或者设备方向更新后，会调用此函数
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (!updatingLocation && self.userLocationAnnotationView != nil) {
    
        [UIView animateWithDuration:0.1 animations:^{
//            double degree = userLocation.heading.trueHeading - self.mapView.rotationDegree;
//            self.userLocationAnnotationView.transform = CGAffineTransformMakeRotation(degree * M_PI / 180.f );
            
            // 记下第一次定位的点的位置
            self.annotationPoint = CGPointMake(mapView.userLocation.location.coordinate.latitude, mapView.userLocation.location.coordinate.longitude);
            
            // 搜索位置
            [self searchReGeocodeWithCoordinate:CLLocationCoordinate2DMake(self.annotationPoint.x, self.annotationPoint.y)];
        
        }];
    }
}

/* 逆地理编码 搜索. */
- (void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension = YES;
    
    [self.search AMapReGoecodeSearch:regeo];
}


#pragma mark - AMapSearchDelegate

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil) {
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(request.location.latitude, request.location.longitude);
        ReGeocodeAnnotation *reGeocodeAnnotation = [[ReGeocodeAnnotation alloc] initWithCoordinate:coordinate reGeocode:response.regeocode];
        self.sourceSiteLbl.text = reGeocodeAnnotation.reGeocode.formattedAddress;
        self.annotationView.calloutText             = self.sourceSiteLbl.text;
    }
}

#pragma mark - AMapSearchDelegate

// 输入提示回调.
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    [self.tips setArray:response.tips];
    
    // 刷新tableview
    // UISearchDisplayController
    [self.displayController.searchResultsTableView reloadData];
}

// 导航搜索回调.
- (void)onNavigationSearchDone:(AMapNavigationSearchRequest *)request
                      response:(AMapNavigationSearchResponse *)response
{
    if (self.searchType != request.searchType) {
        return;
    }
    
    if (response.route == nil) {
        return;
    }
    
    self.route = response.route;
    [self updateTotal];
    self.currentCourse = 0;
    
    [self updateCourseUI];
    [self updateDetailUI];
    
    // 展示当前路线方案.
    [self presentCurrentCourse];
}

// 地理编码回调.
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    if (response.geocodes.count == 0) {
        return;
    }
    
    NSMutableArray *annotations = [NSMutableArray array];
    
    [response.geocodes enumerateObjectsUsingBlock:^(AMapGeocode *obj, NSUInteger idx, BOOL *stop) {
        GeocodeAnnotation *geocodeAnnotation = [[GeocodeAnnotation alloc] initWithGeocode:obj];
        [annotations addObject:geocodeAnnotation];
    }];
    
    if (annotations.count == 1) {
        [self.mapView setCenterCoordinate:[annotations[0] coordinate] animated:YES];
    } else {
        [self.mapView setVisibleMapRect:[CommonUtility minMapRectForAnnotations:annotations]
                               animated:YES];
    }
    
    [self.mapView addAnnotations:annotations];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tips.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tipCellIdentifier = @"tipCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tipCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:tipCellIdentifier];
    }
    
    AMapTip *tip = self.tips[indexPath.row];
    
    cell.textLabel.text = tip.name;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AMapTip *tip = self.tips[indexPath.row];
    
    // 清除annotation并且进行地理搜索
    [self clearAndSearchGeocodeWithKey:tip.name];
    
    // 收回键盘
    [self.displayController setActive:NO animated:NO];
    
    self.searchBar.placeholder = tip.name;
}

#pragma mark - Handle Action

// 输入提示 搜索.
- (void)searchTipsWithKey:(NSString *)key
{
    if (key.length == 0) {
        return;
    }
    
    AMapInputTipsSearchRequest *tips = [[AMapInputTipsSearchRequest alloc] init];
    tips.keywords = key;
    
    [self.search AMapInputTipsSearch:tips];
}

// 清除annotation并且进行地理搜索
- (void)clearAndSearchGeocodeWithKey:(NSString *)key
{
    // 清除annotation.
    [self clearAnnotations];
    // 地理编码 搜索.
    [self searchGeocodeWithKey:key];
}

// 地理编码 搜索.
- (void)searchGeocodeWithKey:(NSString *)key
{
    if (key.length == 0) {
        return;
    }
    
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.address = key;
    
    [self.search AMapGeocodeSearch:geo];
}

// 切换导航搜索类型.
- (void)searchTypeAction:(UISegmentedControl *)segmentedControl
{
    self.searchType = [self searchTypeForSelectedIndex:segmentedControl.selectedSegmentIndex];
    
    self.route = nil;
    self.totalCourse   = 0;
    self.currentCourse = 0;
    
    [self updateDetailUI];
    [self updateCourseUI];
    
    // 清除overlay
    [self clearOverlays];
    
    // 发起导航搜索请求.
    [self searchNaviWithType:self.searchType];
}

// 将selectedIndex 转换为响应的AMapSearchType.
- (AMapSearchType)searchTypeForSelectedIndex:(NSInteger)selectedIndex
{
    AMapSearchType searchType = 0;
    
    switch (selectedIndex) {
        case 0:
            searchType = AMapSearchType_NaviDrive;
            break;
        case 1:
            searchType = AMapSearchType_NaviWalking;
            break;
        case 2:
            searchType = AMapSearchType_NaviBus;
            break;
        default:
            NSAssert(NO, @"%s: selectedindex = %ld is invalid for Navigation", __func__, (long)selectedIndex);
            break;
    }
    
    return searchType;
}

// 根据searchType来执行响应的导航搜索
- (void)searchNaviWithType:(AMapSearchType)searchType
{
    switch (searchType) {
        case AMapSearchType_NaviDrive:
        {
            [self searchNaviDrive];
            
            break;
        }
        case AMapSearchType_NaviWalking:
        {
            [self searchNaviWalk];
            
            break;
        }
        default:AMapSearchType_NaviBus:
        {
            [self searchNaviBus];
            
            break;
        }
    }
}

// 公交导航搜索.
- (void)searchNaviBus
{
    AMapNavigationSearchRequest *navi = [[AMapNavigationSearchRequest alloc] init];
    navi.searchType       = AMapSearchType_NaviBus;
    navi.requireExtension = YES;
    navi.city             = @"beijing";
    
    // 出发点.
    navi.origin = [AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude
                                           longitude:self.startCoordinate.longitude];
    // 目的地.
    navi.destination = [AMapGeoPoint locationWithLatitude:self.destinationCoordinate.latitude
                                                longitude:self.destinationCoordinate.longitude];
    
    [self.search AMapNavigationSearch:navi];
}

// 步行导航搜索.
- (void)searchNaviWalk
{
    AMapNavigationSearchRequest *navi = [[AMapNavigationSearchRequest alloc] init];
    navi.searchType       = AMapSearchType_NaviWalking;
    navi.requireExtension = YES;
    
    // 出发点.
    navi.origin = [AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude
                                           longitude:self.startCoordinate.longitude];
    // 目的地.
    navi.destination = [AMapGeoPoint locationWithLatitude:self.destinationCoordinate.latitude
                                                longitude:self.destinationCoordinate.longitude];

    [self.search AMapNavigationSearch:navi];
}

// 驾车导航搜索.
- (void)searchNaviDrive
{
    AMapNavigationSearchRequest *navi = [[AMapNavigationSearchRequest alloc] init];
    navi.searchType       = AMapSearchType_NaviDrive;
    navi.requireExtension = YES;
    
    // 出发点.
    navi.origin = [AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude
                                           longitude:self.startCoordinate.longitude];
    // 目的地.
    navi.destination = [AMapGeoPoint locationWithLatitude:self.destinationCoordinate.latitude
                                                longitude:self.destinationCoordinate.longitude];
    
    [self.search AMapNavigationSearch:navi];
}

#pragma mark - Actions

// 更新方案列表
- (void)updateTotal
{
    NSUInteger total = 0;
    
    if (self.route != nil) {
        
        switch (self.searchType) {
            case AMapSearchType_NaviDrive   :
            case AMapSearchType_NaviWalking : total = self.route.paths.count;    break;
            case AMapSearchType_NaviBus     : total = self.route.transits.count; break;
            default: total = 0; break;
        }
    }
    // 总方案个数
    self.totalCourse = total;
}

// 切到上一个方案路线.
- (void)previousCourseAction
{    
    if ([self decreaseCurrentCourse]) {
        // 清除overlays
        [self clearOverlays];
        // 更新UI
        [self updateCourseUI];
        // 展现当前路线
        [self presentCurrentCourse];
    }
}

// 切到下一个方案路线.
- (void)nextCourseAction
{
    if ([self increaseCurrentCourse]) {
        // 清除overlays
        [self clearOverlays];
        // 更新UI
        [self updateCourseUI];
        // 展现当前路线
        [self presentCurrentCourse];
    }
}

// 展示当前路线方案.
- (void)presentCurrentCourse
{
    NSArray *polylines = nil;
    
    if (self.searchType == AMapSearchType_NaviBus) {    // 公交导航.
        polylines = [CommonUtility polylinesForTransit:self.route.transits[self.currentCourse]];
    } else {                                            // 步行，驾车导航.
        polylines = [CommonUtility polylinesForPath:self.route.paths[self.currentCourse]];
    }
    
    [self.mapView addOverlays:polylines];
    
    // 缩放地图使其适应polylines的展示.
    self.mapView.visibleMapRect = [CommonUtility mapRectForOverlays:polylines];
}

// 清空地图上的overlay.
- (void)clearOverlays
{
    [self.mapView removeOverlays:self.mapView.overlays];
}

// 清除annotation.
- (void)clearAnnotations
{
    [self.mapView removeAnnotations:self.mapView.annotations];
}

// 切换到下一个方案
- (BOOL)increaseCurrentCourse
{
    BOOL result = NO;
    
    if (self.currentCourse < self.totalCourse - 1) {
        self.currentCourse++;
        
        result = YES;
    }
    
    return result;
}

// 切换到上一个方案
- (BOOL)decreaseCurrentCourse
{
    BOOL result = NO;
    
    if (self.currentCourse > 0) {
        self.currentCourse--;
        
        result = YES;
    }
    
    return result;
}


// 进入详情页面.
- (void)detailAction
{
    if (self.route == nil) {
        return;
    }
    
    [self gotoDetailForRoute:self.route type:self.searchType];
}

// 进入详情页面.
- (void)gotoDetailForRoute:(AMapRoute *)route type:(AMapSearchType)type
{
    RouteDetailViewController *routeDetailViewController = [[RouteDetailViewController alloc] init];
    routeDetailViewController.route      = route;
    routeDetailViewController.searchType = type;
    
    [self.navigationController pushViewController:routeDetailViewController animated:YES];
}

#pragma mark - Utility

- (void)onBtnSource:(id)sender
{
    self.searchBar.placeholder = @"设置起点";
}


- (void)onBtnDestination:(id)sender
{
    self.searchBar.placeholder = @"设置终点";
}

@end
