//
//  ActivityPlanViewController.m
//  MobileSaleSystem
//
//  Created by Wild Yaoyao on 14/12/25.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import "ActivityPlanViewController.h"
#import "ActivityPlanCell.h"

@interface ActivityPlanViewController ()

@end

@implementation ActivityPlanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.modelArr = [NSMutableArray array];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.modelArr = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onBtnAdd:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    NSArray *array = [NSArray arrayWithObjects:@"i简单；十几分i；骚减肥；熬倒计时v哦朋；撒酒疯静安寺；放假啊是【发技术总监jjdsfijadifoyoiwyoweoayr7yohkfjskf  oi就；；放假阿迪；非", @"ijdsojf;osjf",
                      @"即将二分i傲娇",
                      @"lfijfjepafj",
                      @"ijd;oaf[I0[Q",
                      @"AJJAJAJJWD",
                      @"SEI放假哦啊见附件地方【安家费【ap9isfd[a9啊【死放大【啊大宋见附件地；v静安寺大劫案【哦几放大放假啊【非jsidfjasjidfpaisdfjwp8ruwqpfj",
                      @"dsfasdofoasfasdfdas",
                      @"i建瓯就打算激动啥金佛就是IE剪发",
                      @"dfj;asjdf",
                      @"呵呵",
                      nil];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    NSString *date = [dateFormatter stringFromDate:[NSDate date]];
    
    for (int i = 0; i < 10; i++) {
        PlanModel *model = [[PlanModel alloc] init];
        model.image = nil;
        model.time = date;
        model.detail = array[i];
        
        [self.modelArr addObject:model];
    }
    
//    [self.tableView registerNib:[UINib nibWithNibName:@"ActivityPlanCell.xib" bundle:nil] forCellReuseIdentifier:Identifier];
}

- (void)onBtnAdd:(id)sender
{
    
}

#pragma mark - UITableViewDataSource and Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"ActivityPlanCellIdentifer";
    
    ActivityPlanCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell) {
//        cell = [[ActivityPlanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ActivityPlanCell" owner:self options:nil] lastObject];
    }
    
    PlanModel *model = self.modelArr[indexPath.row];
    cell.timeLbl.text = model.time;
    cell.detailLbl.text = model.detail;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlanModel *model = self.modelArr[indexPath.row];
    
    return [ActivityPlanCell getCellHeight:model.detail width:tableView.frame.size.width-40];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
//    [self performSegueWithIdentifier:@"toDetail" sender:selectedCell];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
