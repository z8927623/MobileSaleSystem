//
//  RecordManageViewController.m
//  MobileSaleSystem
//
//  Created by Wild Yaoyao on 14/12/25.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import "RecordManageViewController.h"
#import "RecordDetailViewController.h"
#import "NewRecordViewController.h"

@interface RecordManageViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation RecordManageViewController

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
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onBtnAdd)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    self.arr = [NSMutableArray arrayWithObjects:@"i哇二姐夫；安静；过生日我", @"诶放假啊四句", @"代码v线段v交流电机女里四大金刚六点十分i结构", @"hi铝合金门帮你们白毛女慢病", @"n.jn.knk,jb,jvhvmgv", @"和；FIJA;SINZ", @"SDLAS;JASUH;i就；v偶觉得；新放假老规矩；哦i价格多少", @"我还以为扬我国威别误会我那我就叫", @"eow8urerghuldihgljgu饿疯了胡 方", @"i基督教董家渡街道就地解决董家渡街道简单", @"建瓯i人多间隔i哦啊二换个i色u混个脸熟的", @"好舒服；接哈石佛i骄傲；大姐夫i；安家费i欧舒丹", @"i皓玟；发i安稳觉；发i经费i按时间哦v发酵法发个", nil];
    [self setupRefresh];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getRecordList) name:Noti5 object:nil];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)setupRefresh
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:UserIdKey]) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [SVProgressHUD showHUDWithImage:nil status:@"请登录" duration:TimeInterval];
        return;
    }
    
    [self.tableView addHeaderWithTarget:self action:@selector(getRecordList) dateKey:@"message"];
    [self.tableView headerBeginRefreshing];
    self.tableView.headerPullToRefreshText = @"下拉刷新";
    self.tableView.headerReleaseToRefreshText = @"松开刷新";
    self.tableView.headerRefreshingText = @"刷新中，请稍候";
}

- (void)getRecordList
{
    [self.dataArr removeAllObjects];
    
    [HTTPManager getRecordListWithUserId:nil completionBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
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


- (void)deleteClient:(NSNumber *)ID
{
    [SVProgressHUD show];
    
    [HTTPManager deleteRecordWithUserId:nil noteId:@(0) completionBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"jsonDic: %@\n%@", jsonObject, jsonString);
        NSString *result_code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        
        if ([result_code isEqualToString:@"0"]) {
            [SVProgressHUD dismiss];
            
            [self getRecordList];
            
        } else {
            [SVProgressHUD showHUDWithImage:nil status:@"失败" duration:TimeInterval];
        }
        
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showHUDWithImage:nil status:@"失败" duration:TimeInterval];
        NSLog(@"err: %@", error);
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *iden = @"iden";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    
    NSDictionary *dic = self.dataArr[indexPath.row];
    cell.textLabel.text = dic[@"note"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RecordDetailViewController *detailVC = [[RecordDetailViewController alloc] init];
//    detailVC.text = self.arr[indexPath.row];
    NSMutableDictionary *dic = self.dataArr[indexPath.row];
    detailVC.dic = dic;
    [self.navigationController pushViewController:detailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [self.arr removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        NSDictionary *dic = self.dataArr[indexPath.row];
        [self deleteRecord:dic[@"id"]];
    }
}

- (void)deleteRecord:(NSNumber *)ID
{
    [SVProgressHUD show];
    
    [HTTPManager deleteRecordWithUserId:nil noteId:ID completionBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"jsonDic: %@\n%@", jsonObject, jsonString);
        NSString *result_code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        
        if ([result_code isEqualToString:@"0"]) {
            [SVProgressHUD dismiss];
            
            [self getRecordList];
            
        } else {
            [SVProgressHUD showHUDWithImage:nil status:@"失败" duration:TimeInterval];
        }
        
    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showHUDWithImage:nil status:@"失败" duration:TimeInterval];
        NSLog(@"err: %@", error);
    }];
}

- (void)onBtnAdd
{
    NewRecordViewController *new = [[NewRecordViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:new];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
