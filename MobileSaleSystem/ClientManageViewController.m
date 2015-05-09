//
//  ClientManageViewController.m
//  MobileSaleSystem
//
//  Created by Wild Yaoyao on 14/12/25.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import "ClientManageViewController.h"
#import "ClientDetailViewController.h"

#define Identifier @"ClientManageCellIdentifer"

@interface ClientManageViewController ()

@property (nonatomic, strong) NSMutableArray *indexArr;
@property (nonatomic, strong) NSMutableDictionary *dataDictionary;

@end

@implementation ClientManageViewController

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

- (void)setForManager:(BOOL)forManager {
    if (!forManager) {
        self.navigationItem.title = @"客户管理";
    } else {
        self.navigationItem.title = @"销售员管理";
    }
    _forManager = forManager;
}

- (void)dealloc {
//    [HTTPManager cancelOperation:@"GET" path:ClientList_Url];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (!self.forManager) {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onBtnAdd:)];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
   
    self.dataDictionary = [NSMutableDictionary dictionary];
    
//    self.clientArr =[NSMutableArray arrayWithObjects:@"张三", @"李四", @"老五", @"小张", @"小杨", @"周杰伦", @"王力宏", @"林俊杰", @"张学友", @"刘德华", @"小赵", @"小莉", @"姚明", nil];
//    self.indexArr = [NSMutableArray arrayWithObjects:@"a", @"b", @"c", @"d", nil];

    self.clientArr = [NSMutableArray array];
//    self.clientInfoArr = [NSMutableArray array];
    self.indexArr = [NSMutableArray array];
//    [self configData:self.clientArr];

    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:Identifier];
    
    [self setupRefresh];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:Noti1 object:nil];
}

- (void)reload
{
//    [self.tableView headerBeginRefreshing];
    
    if (!self.forManager) {
        [self getClientList];
    } else {
        [self getSalerList];
    }
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
        [self.tableView addHeaderWithTarget:self action:@selector(getClientList) dateKey:@"message"];
    } else {
        [self.tableView addHeaderWithTarget:self action:@selector(getSalerList) dateKey:@"message"];
    }
    
    [self.tableView headerBeginRefreshing];
    self.tableView.headerPullToRefreshText = @"下拉刷新";
    self.tableView.headerReleaseToRefreshText = @"松开刷新";
    self.tableView.headerRefreshingText = @"刷新中，请稍候";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self getList:NO]

//    [self.tableView reloadData];
    
 
}

- (void)reset
{
    [self.clientArr removeAllObjects];
    [self.indexArr removeAllObjects];
    [self.dataDictionary removeAllObjects];
}

- (void)getClientList
{
//    if (show) {
//        [SVProgressHUD showProgress];
//    }

//    __weak typeof(self) weakSelf = self;

    [self reset];
     
    [HTTPManager getClientListWithUserId:nil completionBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"here");
//        weakSelf.forManager = YES;
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"jsonDic: %@\n%@", jsonObject, jsonString);
        NSString *result_code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        
        if ([result_code isEqualToString:@"0"]) {
            [SVProgressHUD dismiss];
        
            NSArray *arr = jsonObject[@"data"];
            [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [self.clientArr addObject:(NSDictionary *)obj];
            }];
            
            [self configData:self.clientArr];
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

- (void)getSalerList
{
    [self reset];
    
    [HTTPManager getSalerListWithCompletionBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"jsonDic: %@\n%@", jsonObject, jsonString);
        NSString *result_code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        
        if ([result_code isEqualToString:@"0"]) {
            [SVProgressHUD dismiss];
            
            NSArray *arr = jsonObject[@"data"];
            [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [self.clientArr addObject:(NSDictionary *)obj];
            }];
            
            [self configData:self.clientArr];
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


- (void)configData:(NSArray *)clientArr
{
    for (NSDictionary *dic in clientArr) {
        NSString *name = dic[@"nickName"];
        
        if (name == nil) {
            name = dic[@"name"];
        }
        
        NSString *pinyin = [name toChinesePinyin];

        NSString *firstLetter = [[pinyin substringToIndex:1] uppercaseString];
//        model.chinesePinyin = pinyin;
//        model.chineseJianpin = [name toChineseJianpin];
        
        if (firstLetter != nil) {
            if (![self.indexArr containsObject:firstLetter]) {
                // 拼音首字母数组
                [self.indexArr addObject:firstLetter];
            }
        }
 
    }
    
    NSLog(@"ind: %@", self.indexArr);
    
    [self organizeData];
}

// 组成字典
- (void)organizeData
{
    // 排序
    self.indexArr = [NSMutableArray arrayWithArray:[self.indexArr sortedArrayUsingComparator:^(NSString * obj1, NSString * obj2){
        return (NSComparisonResult)[obj1 compare:obj2 options:NSNumericSearch];
    }]];
    
    int index = 0;
    for (int i = 0; i < _indexArr.count; i++) {
        NSString *key = _indexArr[i];   // 取出key
        NSMutableArray *dicArr = [NSMutableArray array];

        for (int j = index; j < _clientArr.count; j++) { // 在数据里遍历是否有匹配
            NSDictionary *dic = _clientArr[j];
            NSString *name = dic[@"nickName"];
            if (name == nil) {
                name = dic[@"name"];
            }
            
            NSString *everyKey = [name.toChinesePinyin substringToIndex:1];
            NSComparisonResult comparRet = [key caseInsensitiveCompare:everyKey];  // 不区分大小写
            if (comparRet == NSOrderedSame) {   // 相等，说明都是同一个字母开头的，放入数组
                [dicArr addObject:dic];
                if (j == _clientArr.count-1) {
                    [self.dataDictionary setObject:dicArr forKey:key];
                }
            } else {
                [self.dataDictionary setObject:dicArr forKey:key];
                //                index = j;
                //                break;
            }
        }
    }
}


- (void)deleteClient:(NSNumber *)ID
{
    [SVProgressHUD show];
    
    [HTTPManager deleteClientInfoWithUserId:nil clientId:ID completionBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"jsonDic: %@\n%@", jsonObject, jsonString);
        NSString *result_code = [NSString stringWithFormat:@"%@", jsonObject[@"code"]];
        
        if ([result_code isEqualToString:@"0"]) {
            [SVProgressHUD dismiss];
            
            [self getClientList];
        
        } else {
            [SVProgressHUD showHUDWithImage:nil status:@"失败" duration:TimeInterval];
        }

    } failureBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showHUDWithImage:nil status:@"失败" duration:TimeInterval];
        NSLog(@"err: %@", error);
    }];
}

- (void)onBtnAdd:(id)sender
{
    [self performSegueWithIdentifier:@"toAddNewClient" sender:nil];
}

#pragma mark - UITableViewDataSource and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataDictionary.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *sectionArr = _dataDictionary[_indexArr[section]];
    return sectionArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    
    NSMutableArray *sectionArr = _dataDictionary[_indexArr[indexPath.section]];
    NSDictionary *dic = sectionArr[indexPath.row];
    NSString *name = dic[@"nickName"];
    if (name == nil) {
        name = dic[@"name"];
    }
    cell.textLabel.text = name;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
//    [self performSegueWithIdentifier:@"toDetail" sender:selectedCell];

    ClientDetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"clientdetail"];
    detailVC.forManager = self.forManager;
    NSMutableArray *sectionArr = _dataDictionary[_indexArr[indexPath.section]];
    NSMutableDictionary *dic = [sectionArr[indexPath.row] mutableCopy];
    [sectionArr replaceObjectAtIndex:indexPath.row withObject:dic];
    detailVC.dic = dic;
    [self.navigationController pushViewController:detailVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// lead to crash
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleDelete;
//}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (editingStyle ==UITableViewCellEditingStyleDelete) {
//        NSString *key = [_indexArr objectAtIndex:indexPath.section];
//        NSMutableArray *arr = _dataDictionary[key];
//        if (arr.count != 1) {
//            [arr removeObjectAtIndex:indexPath.row];
//            [_dataDictionary setObject:arr forKey:key];
//            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        } else {
//            [_dataDictionary removeObjectForKey:key];
//            [self.indexArr removeObject:key];
//            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
//        }
//    }
    
    
    if (editingStyle ==UITableViewCellEditingStyleDelete) {
        NSMutableArray *sectionArr = _dataDictionary[_indexArr[indexPath.section]];
        NSDictionary *dic = sectionArr[indexPath.row];
        [self deleteClient:dic[@"id"]];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.indexArr[section];
}

// index
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.indexArr;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UITableViewCell *cell = (UITableViewCell *)sender;
    
//    [self.clientInfoArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//
//    }];
    
 
}


@end
