//
//  ActivityPlanViewController.m
//  MobileSaleSystem
//
//  Created by Wild Yaoyao on 14/12/25.
//  Copyright (c) 2014年 Yang Yao. All rights reserved.
//

#import "ActivityPlanViewController.h"
#import "ActivityPlanCell.h"
#import "ActivityDetailViewController.h"

#define Identifier @"ActivityPlanCellIdentifer"

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
    
    NSArray *array = [NSArray arrayWithObjects:@"i简单；十几分i；骚减肥；熬倒计时v哦朋；撒酒疯静安寺；放假啊是【发技术总监jjdsfijadifoyoiwyoweoayr7yohkfjskf",
                      @"即将二分i傲娇",
                      @"lfijfjepafj",
                      @"ijd;oaf[I0[Q",
                      @"down vote lt for a given SDK or deployment target. For exa",
                      @"SEI放假哦啊见附件地方【安家费【ap9isfd[a9啊【死放大【啊大宋见附件地；v静安寺大劫案【哦几放大放假啊【非jsidfjasjidfpaisdfjwp8ruwqpfj",
                      @"dsfasdofoasfasdfdas",
                      @"【春兰杯古力屠龙胜韩国金志锡 中国提前夺冠】http://t.cn/RZzydsc 第十届春兰杯半决赛刚刚结束一场，不久前十番棋失利的古力以围棋中最为酣畅淋漓的屠龙方式击败韩国金志锡，中国包揽冠亚军。韩国二号棋手金志锡近期首夺三星杯以及进入LG杯决赛，期间击败中国多位年轻世界冠军，终于倒在了古力面前。"
                      @""
                      @"i建瓯就打算激动啥金佛就是IE剪发",
                      @"尼泊尔和孟加拉国都是中国传统友好邻邦。明年是中尼建交60周年，也是中孟建交40周年。中方期待通过此访推动落实中尼、中孟两国领导人重要共识，规划明年建交纪念活动，拓展双方在经贸、互联互通、人文等领域合作，推进中尼、中孟关系进一步发展。问美韩日三方将签订一项防卫情报备忘录，共享有关朝鲜核武器和导弹项目的机密信息。中方对此有何评论？\
                      答：我们注意到有关报道。当前朝鲜半岛形势总体缓和，但这一局面仍较脆弱。希望有关各方多做有利于促进对话和互信、有利于维护半岛和本地区和平稳定大局的事，而不是相反。这符合有关各方的共同利益",
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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ActivityPlanCell" bundle:nil] forCellReuseIdentifier:Identifier];
}

- (void)onBtnAdd:(id)sender
{
    [self performSegueWithIdentifier:@"toAddNewPlan" sender:nil];
}

#pragma mark - UITableViewDataSource and Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityPlanCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier forIndexPath:indexPath];
    
    PlanModel *model = self.modelArr[indexPath.row];
    [cell setModel:model tableView:tableView];

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
    
    ActivityDetailViewController *detailVC = [[ActivityDetailViewController alloc] init];
    PlanModel *model = self.modelArr[indexPath.row];
    detailVC.model = model;
    [self.navigationController pushViewController:detailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.modelArr removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([[segue identifier] isEqualToString:@"toDetail"]) {
//        ActivityPlanCell *cell = (ActivityPlanCell *)sender;
//        ActivityDetailViewController *activityDetailVC = (ActivityDetailViewController *)segue.destinationViewController;
//        activityDetailVC.model = cell.model;
//    }
//}

@end
