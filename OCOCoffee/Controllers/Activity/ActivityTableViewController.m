//
//  ActivityTableViewController.m
//  OCOCoffee
//
//  Created by sam on 15/8/10.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#define kSendActivityListUrl      @"/api/activity/mysend"
#define kRecvActivityListUrl      @"/api/activity/myrecv"

#import "Global.h"
#import "UIColor+colorBuild.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <MJRefresh/MJRefresh.h>
#import "UIScrollView+MJRefresh.h"
#import "ActivityTableViewCell.h"
#import <AFNetworking/AFNetworking.h>
#import "ActivityListItem.h"
#import "ActivityDetailViewController.h"
#import "ActivityTableViewController.h"



@interface ActivityTableViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, assign) NSInteger pageIndex;
@property(nonatomic, assign) NSInteger hasNextPage;
@property(nonatomic, strong) NSMutableArray *listDataArray;

@end

@implementation ActivityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"日程";
    self.pageIndex = 0;
    self.listDataArray = [NSMutableArray array];

    [self initSubViews];
}

- (void) initSubViews {
    
    __weak typeof(self) weakSelf = self;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"我发出的", @"我接受的"]];
    segmentedControl.selectedSegmentIndex = 0;

    [self.view addSubview:segmentedControl];
    [segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view).offset(PHONE_NAVIGATIONBAR_HEIGHT+PHONE_STATUSBAR_HEIGHT+5);
        make.left.mas_equalTo(weakSelf.view).offset(20);
        make.right.mas_equalTo(weakSelf.view).offset(-20);
    }];

    //tableview
    self.tableView = ({
        UITableView *tableView = [UITableView new];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.estimatedRowHeight = kCellHeight;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView;
    });
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(segmentedControl.mas_bottom).offset(5);
        make.left.right.mas_equalTo(weakSelf.view);
        make.bottom.mas_equalTo(weakSelf.view).offset(-PHONE_NAVIGATIONBAR_HEIGHT);
    }];
    
    //set header
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullToRefresh)];
    [self.tableView.header beginRefreshing];

    //set footer
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
}

#pragma mark -pullToRefresh

- (void) pullToRefresh
{
    static const CGFloat MJDuration = 2.0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.pageIndex = 0;
        [self.listDataArray removeAllObjects];

        [self loadDataFromServer];
        [self.tableView.header endRefreshing];
    });
}


#pragma mark-loadMoreData
- (void)loadMoreData
{
    static const CGFloat MJDuration = 2.0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadDataFromServer];
        [self.tableView.footer endRefreshing];
    });
}

- (void) loadDataFromServer
{
    NSString *listApiUrl = [NSString stringWithFormat:@"%@%@", API_DOMAIN, kSendActivityListUrl];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSNumber *pageIndex = [[NSNumber alloc] initWithLong:self.pageIndex+1];
    NSDictionary *parameters = @{@"page":pageIndex};
    [manager GET:listApiUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        [self analyseListJsonObject:responseObject];
        [self.tableView.header endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)analyseListJsonObject:(NSDictionary *)jsonObject
{
    if ([jsonObject[@"data"] isKindOfClass:[NSDictionary class]]) {
        NSArray *dicts;
        if (jsonObject[@"data"][@"list"]) {
            dicts = jsonObject[@"data"][@"list"];
        }
        if (jsonObject[@"data"][@"curpage"]) {
            self.pageIndex = [jsonObject[@"data"][@"curpage"] integerValue];
        }
        if (jsonObject[@"data"][@"hasnext"]) {
            self.hasNextPage = [jsonObject[@"data"][@"hasnext"] boolValue];
        }
        
        if([dicts count] >0){
            for (NSDictionary *dict in dicts) {
                ActivityListItem *item = [ActivityListItem activityListItemWithDictionary:dict];
                [self.listDataArray addObject:item];
            }
        }
        [self.tableView reloadData];
        
    } else if ([jsonObject[@"data"] respondsToSelector:@selector(count)] && [jsonObject[@"data"] count] == 0) {
        self.pageIndex = 1;
        self.hasNextPage = NO;
        [self.listDataArray removeAllObjects];
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listDataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"activityCell";
    ActivityTableViewCell *cell = [[ActivityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    // Configure the cell...
    ActivityListItem *activityItem = [self.listDataArray objectAtIndex:indexPath.row];

    [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:activityItem.to_headimgurl]];
    cell.nicknameLabel.text = activityItem.to_nickname;
    
    if ([activityItem.sex floatValue] == 1) {
        cell.sexAgeLabel.text = [NSString stringWithFormat:@"♂ %@", activityItem.to_age];
    } else {
        cell.sexAgeLabel.text = [NSString stringWithFormat:@"♀ %@", activityItem.to_age];
    }
    cell.conLabel.text = activityItem.to_constellation;
    cell.addressLabel.text = activityItem.address;
    cell.dateLineLabel.text = activityItem.dateline;
    if ([activityItem.desc length] == 0) {
        cell.descLabel.text = @"什么都没说";
    } else {
        cell.descLabel.text = activityItem.desc;
    }
    cell.beforeLabel.text = activityItem.fmt_date;
    float status = [activityItem.status floatValue];
    if (status == 1 || status == 2) {
        cell.statusImageView.image = [UIImage imageNamed:@"center_pending"];
    } else if(status == 3)  {
        cell.statusImageView.image = [UIImage imageNamed:@"center_accept"];
    } else if(status == 5) {
        cell.statusImageView.image = [UIImage imageNamed:@"center_refuse"];
    } else if (status == 7) {
        cell.statusImageView.image = [UIImage imageNamed:@"center_cancel"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    ActivityListItem *activityItem = [self.listDataArray objectAtIndex:indexPath.row];
    NSDictionary *attrbute = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    CGFloat textHeight = [activityItem.address boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrbute context:nil].size.height;

    return textHeight + kCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityDetailViewController *detail = [[ActivityDetailViewController alloc] init];
    [self.navigationController pushViewController:detail animated:YES];
}

@end
