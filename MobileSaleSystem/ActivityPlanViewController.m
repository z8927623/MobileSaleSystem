//
//  ActivityPlanViewController.m
//  MobileSaleSystem
//
//  Created by Wild Yaoyao on 14/12/25.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import "ActivityPlanViewController.h"
#import "ActivityPlanCell.h"

#define Identifier @"ActivityPlanCellIdentifer"

@interface ActivityPlanViewController ()

@end

@implementation ActivityPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onBtnAdd:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)onBtnAdd:(id)sender
{
    
}

#pragma mark - UITableViewDataSource and Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityPlanCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    cell.timeLbl.text = @"2014.12.26";
    cell.detailLbl.text = @"i简单；十几分i；骚减肥；熬倒计时v哦朋；撒酒疯静安寺；放假啊是【发技术总监";
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
//    [self performSegueWithIdentifier:@"toDetail" sender:selectedCell];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
