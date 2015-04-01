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
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onBtnAdd:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)onBtnAdd:(id)sender
{
    NewSigninViewController *signinVC = [[NewSigninViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:signinVC];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *iden = @"iden";
    SignInCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[SignInCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    
    [cell setName:@"ehhe" time:@"2015-01-01" address:@"浙江理工大学"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

@end
