//
//  SignInManageViewController.m
//  MobileSaleSystem
//
//  Created by Wild Yaoyao on 14/12/25.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import "SignInManageViewController.h"
#import "NewSigninViewController.h"
#import "SignInCell.h"

@interface SignInManageViewController ()

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation SignInManageViewController

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
    
    self.dataArr = [NSMutableArray array];
    
    if (!self.forManager) {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onBtnAdd:)];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self setupRefresh];
    
    if (!self.forManager) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSignInList) name:Noti3 object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAllSignInInfo) name:Noti3 object:nil];
    }
    
    if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)getAllSignInInfo
{
    [self.dataArr removeAllObjects];
    
    [HTTPManager getAllSignInListWithCompletionBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"jsonDic: %@\n%@", jsonObject, jsonString);
        NSString *result_code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        
        if ([result_code isEqualToString:@"0"]) {
            [SVProgressHUD dismiss];
            
            NSArray *arr = jsonObject[@"data"];
            [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [self.dataArr addObject:(NSDictionary *)obj];
            }];
            
            [self.tableView reloadData];
            
        } else {
            [SVProgressHUD showHUDWithImage:nil status:@"失败" duration:TimeInterval];
        }
        
        [self.tableView  headerEndRefreshing];
        
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showHUDWithImage:nil status:@"失败" duration:TimeInterval];
        NSLog(@"err: %@", error);
        
        [self.tableView  headerEndRefreshing];
    }];
}


- (void)setupRefresh
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:UserIdKey]) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [SVProgressHUD showHUDWithImage:nil status:@"请登录" duration:TimeInterval];
        return;
    }
    
    if (!self.forManager) {
        [self.tableView addHeaderWithTarget:self action:@selector(getSignInList) dateKey:@"message"];
    } else {
        [self.tableView addHeaderWithTarget:self action:@selector(getAllSignInInfo) dateKey:@"message"];
    }
 
    [self.tableView headerBeginRefreshing];
    self.tableView.headerPullToRefreshText = @"下拉刷新";
    self.tableView.headerReleaseToRefreshText = @"松开刷新";
    self.tableView.headerRefreshingText = @"刷新中，请稍候";
}

- (void)getSignInList
{
    [self.dataArr removeAllObjects];
    
    [HTTPManager getSignInListWithUserId:nil completionBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"jsonDic: %@\n%@", jsonObject, jsonString);
        NSString *result_code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        
        if ([result_code isEqualToString:@"0"]) {
            [SVProgressHUD dismiss];
            
            NSArray *arr = jsonObject[@"data"];
            [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [self.dataArr addObject:(NSDictionary *)obj];
            }];
            
            [self.tableView reloadData];
            
        } else {
            [SVProgressHUD showHUDWithImage:nil status:@"失败" duration:TimeInterval];
        }
        
        [self.tableView  headerEndRefreshing];
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showHUDWithImage:nil status:@"失败" duration:TimeInterval];
        NSLog(@"err: %@", error);
        
        [self.tableView  headerEndRefreshing];
    }];
}


- (void)onBtnAdd:(id)sender
{
    NewSigninViewController *signinVC = [[NewSigninViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:signinVC];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *iden = @"iden";
    SignInCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[SignInCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    
    NSDictionary *dic = self.dataArr[indexPath.row];
    [cell setName:@"😄" time:dic[@"signTime"] address:dic[@"signPlace"]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

@end
