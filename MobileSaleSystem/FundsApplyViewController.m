//
//  FundsApplyViewController.m
//  MobileSaleSystem
//
//  Created by Wild Yaoyao on 14/12/25.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import "FundsApplyViewController.h"
#import "FundsCell.h"

@interface FundsApplyViewController () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation FundsApplyViewController

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
    
    [self.tableView registerClass:[FundsCell class] forCellReuseIdentifier:@"Identifier"];
    
    [self setupRefresh];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFundsList) name:Noti2 object:nil];
  
    if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupRefresh
{
    if (!self.forManager) {
        if (![[NSUserDefaults standardUserDefaults] objectForKey:UserIdKey]) {
            self.navigationItem.rightBarButtonItem.enabled = NO;
            [SVProgressHUD showHUDWithImage:nil status:@"请登录" duration:TimeInterval];
            return;
        }
    } else {
        if (![[NSUserDefaults standardUserDefaults] objectForKey:ManagerIdKey]) {
            self.navigationItem.rightBarButtonItem.enabled = NO;
            [SVProgressHUD showHUDWithImage:nil status:@"请登录" duration:TimeInterval];
            return;
        }
    }
    
    if (!self.forManager) {
        [self.tableView addHeaderWithTarget:self action:@selector(getFundsList) dateKey:@"message"];
        [self.tableView headerBeginRefreshing];
        self.tableView.headerPullToRefreshText = @"下拉刷新";
        self.tableView.headerReleaseToRefreshText = @"松开刷新";
        self.tableView.headerRefreshingText = @"刷新中，请稍候";
    } else {
        [self.tableView addHeaderWithTarget:self action:@selector(getAllFundsList) dateKey:@"message"];
        [self.tableView headerBeginRefreshing];
        self.tableView.headerPullToRefreshText = @"下拉刷新";
        self.tableView.headerReleaseToRefreshText = @"松开刷新";
        self.tableView.headerRefreshingText = @"刷新中，请稍候";
    }
    
}

- (void)getFundsList
{
    [self.dataArr removeAllObjects];
    
    [HTTPManager getFundsListWithUserId:nil completionBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
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

- (void)getAllFundsList
{
    [self.dataArr removeAllObjects];
    
    [HTTPManager getAllFundsListWithCompletionBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    [self performSegueWithIdentifier:@"toNew" sender:nil];
}

- (void)fundsReviewWithId:(NSNumber *)ID status:(int)status
{
    [SVProgressHUD showProgress];
    
    [HTTPManager editFundsWithId:ID status:[NSString stringWithFormat:@"%d", status] completionBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"jsonDic: %@\n%@", jsonObject, jsonString);
        NSString *result_code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        
        if ([result_code isEqualToString:@"0"]) {
            [SVProgressHUD dismiss];
            
            [self getAllFundsList];
            
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

#pragma mark - UITableViewDataSource and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FundsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Identifier" forIndexPath:indexPath];
//    [cell setValue1:@"交通费用" value2:@"30"];
    

    NSDictionary *dic = self.dataArr[indexPath.row];
    NSString *usage = dic[@"usage"];
    NSNumber *money = dic[@"money"];
    NSString *moneyStr = [NSString stringWithFormat:@"%@", money];
    
    [cell setValue1:usage value2:moneyStr status:dic[@"status"]];

   
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.indexPath = indexPath;
    
    if (self.forManager) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"是否通过申请" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"通过" otherButtonTitles:@"不通过", nil];
        [actionSheet showInView:self.view];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSDictionary *dic = self.dataArr[self.indexPath.row];
    if (buttonIndex == 0) {
        [self fundsReviewWithId:dic[@"id"] status:1];
    } else if (buttonIndex == 1) {
        [self fundsReviewWithId:dic[@"id"] status:2];
    }
}

@end
