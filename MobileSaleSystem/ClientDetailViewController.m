//
//  ClientDetailViewController.m
//  MobileSaleSystem
//
//  Created by wildyao on 14/12/26.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import "ClientDetailViewController.h"
#import "EditClientViewController.h"

@interface ClientDetailViewController ()

@end

@implementation ClientDetailViewController

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    

}

- (void)reloadAvatar
{
    //    [self.tableView headerBeginRefreshing];
    
    if (!self.forManager) {
        self.avatarImage.image = self.dic[@"headPic"];
    } else {
        
    }
}

- (void)reload1
{
    if (!self.forManager) {
        self.name.text = self.dic[@"name"];
        self.phone.text = self.dic[@"linkPhone"];
        self.email.text = self.dic[@"email"];
        self.gender.text = self.dic[@"sex"];
        self.age.text = self.dic[@"age"];
        self.address.text = self.dic[@"address"];
    } else {
        self.name.text = self.dic[@"nickName"];
        self.phone.text = self.dic[@"linkPhone"];
        self.email.text = self.dic[@"email"];
        self.gender.text = self.dic[@"sex"];
        self.age.text = self.dic[@"age"];
        self.address.text = self.dic[@"address"];
    }
}
- (void)dealloc {
    //    [HTTPManager cancelOperation:@"GET" path:ClientList_Url];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(onBtnEdit:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload1) name:Noti1 object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAvatar) name:NotiAvatar object:nil];

    
    if (!self.forManager) {
        self.name.text = self.dic[@"name"];
        self.phone.text = self.dic[@"linkPhone"];
        self.email.text = self.dic[@"email"];
        self.gender.text = self.dic[@"sex"];
        self.age.text = self.dic[@"age"];
        self.address.text = self.dic[@"address"];
    } else {
        self.name.text = self.dic[@"nickName"];
        self.phone.text = self.dic[@"linkPhone"];
        self.email.text = self.dic[@"email"];
        self.gender.text = self.dic[@"sex"];
        self.age.text = self.dic[@"age"];
        self.address.text = self.dic[@"address"];
    }
 
    
    if ([self.dic[@"headPic"] isKindOfClass:[UIImage class]]) {
        self.avatarImage.image = self.dic[@"headPic"];
    } else {
        NSString *urlString = [NSString stringWithFormat:@"%@%@", Base_Url , [self.dic[@"headPic"] substringFromIndex:1]];
        [self.avatarImage setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"0.png"]];
    }
    
    
    if (!self.forManager) {
        self.navigationItem.title = @"客户详情";
    } else {
        self.navigationItem.title = @"销售员详情";
    }
}

- (void)onBtnEdit:(id)sender
{
//    [self performSegueWithIdentifier:@"toEditClient" sender:nil];
    
    EditClientViewController *editVC = [self.storyboard instantiateViewControllerWithIdentifier:@"editclient"];
    editVC.dic = _dic;
    editVC.forManager = self.forManager;
    [self.navigationController pushViewController:editVC animated:YES];
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
