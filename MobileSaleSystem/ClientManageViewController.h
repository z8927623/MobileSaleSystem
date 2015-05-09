//
//  ClientManageViewController.h
//  MobileSaleSystem
//
//  Created by Wild Yaoyao on 14/12/25.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import "CommonViewController.h"

@interface ClientManageViewController : CommonViewController 

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *clientArr;

@property (nonatomic, assign) BOOL forManager;

//@property (nonatomic, strong) NSMutableArray *clientInfoArr;

@end
