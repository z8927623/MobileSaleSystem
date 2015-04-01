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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onBtnAdd:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.dataDictionary = [NSMutableDictionary dictionary];
    self.clientArr =[NSMutableArray arrayWithObjects:@"张三", @"李四", @"老五", @"小张", @"小杨", @"周杰伦", @"王力宏", @"林俊杰", @"张学友", @"刘德华", @"小赵", @"小莉", @"姚明", nil];
//    self.indexArr = [NSMutableArray arrayWithObjects:@"a", @"b", @"c", @"d", nil];

    self.indexArr = [NSMutableArray array];
    [self configData:self.clientArr];

    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:Identifier];
}

- (void)configData:(NSArray *)clientArr
{
    for (NSString *name in clientArr) {
        
        NSString *pinyin = [name toChinesePinyin];
        NSLog(@"piny: %@", pinyin);
        NSString *firstLetter = [[pinyin substringToIndex:1] uppercaseString];
//        model.chinesePinyin = pinyin;
//        model.chineseJianpin = [name toChineseJianpin];
        NSLog(@"fiff: %@", firstLetter);
        if (![self.indexArr containsObject:firstLetter]) {
            // 拼音首字母数组
            [self.indexArr addObject:firstLetter];
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
        NSMutableArray *nameArr = [NSMutableArray array];
        
        for (int j = index; j < _clientArr.count; j++) { // 在数据里遍历是否有匹配
            NSString *name = _clientArr[j];
            NSString *everyKey = [name.toChinesePinyin substringToIndex:1];
            NSComparisonResult comparRet = [key caseInsensitiveCompare:everyKey];  // 不区分大小写
            if (comparRet == NSOrderedSame) {   // 相等，说明都是同一个字母开头的，放入数组
                [nameArr addObject:name];
                if (j == _clientArr.count-1) {
                    [self.dataDictionary setObject:nameArr forKey:key];
                }
            } else {
                [self.dataDictionary setObject:nameArr forKey:key];
                //                index = j;
                //                break;
            }
        }
    }
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
    NSString *name = sectionArr[indexPath.row];
    cell.textLabel.text = name;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"toDetail" sender:selectedCell];
    
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
    if (editingStyle ==UITableViewCellEditingStyleDelete) {
        NSString *key = [_indexArr objectAtIndex:indexPath.section];
        NSMutableArray *arr = _dataDictionary[key];
        if (arr.count != 1) {
            [arr removeObjectAtIndex:indexPath.row];
            [_dataDictionary setObject:arr forKey:key];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [_dataDictionary removeObjectForKey:key];
            [self.indexArr removeObject:key];
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
        }
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
}


@end
