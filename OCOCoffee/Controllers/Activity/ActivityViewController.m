//
//  ActivityTableViewController.m
//  OCOCoffee
//
//  Created by sam on 15/8/10.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "Global.h"
#import "UIColor+colorBuild.h"
#import <Masonry/Masonry.h>
#import <MJRefresh/MJRefresh.h>
#import "UIScrollView+MJRefresh.h"
#import "ActivityTableViewCell.h"
#import "DetailViewController.h"
#import "ActivityViewController.h"


static const CGFloat kCellHeight = 440/2;

@interface ActivityViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;

@end

@implementation ActivityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _tableData = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"日程";
    
    [self initSubViews];
    [self initTableData];
}

- (void) initSubViews {
    
    __weak typeof(self) weakSelf = self;
    [self.view setBackgroundColor:[UIColor colorFromHexString:@"#f5f5f5"]];

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
        make.size.mas_equalTo(weakSelf.view);
    }];
    
    //set header
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullToRefresh)];

    //set footer
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
}

#pragma mark 

- (void) pullToRefresh
{
    static const CGFloat MJDuration = 2.0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self initTableData];
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
    });
}


#pragma mark 上拉加载更多数据
- (void)loadMoreData
{
    static const CGFloat MJDuration = 2.0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self initTableData];
        [self.tableView reloadData];
        [self.tableView.footer endRefreshing];
    });
}

- (void) initTableData {
    
    [_tableData addObject:[NSArray arrayWithObjects:@"sample_logo", @"随银风",@"28",@"巨蟹座", @"福田深南大道7008号阳光高尔夫大厦15F星吧克", @"7月15号周一下午17:00", @"记得带名片",@"15分钟前", @"center_pending",nil]];
    
    [_tableData addObject:[NSArray arrayWithObjects:@"sample_logo", @"随银风",@"28",@"巨蟹座", @"福田深南大道7008号阳光高尔夫大厦15F星吧克咖啡厅一号厅楼", @"7月15号周一下午17:00", @"记得带名片",@"15分钟前",@"center_cancel", nil]];
    
    [_tableData addObject:[NSArray arrayWithObjects:@"sample_logo", @"随银风",@"28",@"巨蟹座", @"福田深南大道7008号阳光高尔夫大厦15F星吧克咖啡厅一号厅楼", @"7月15号周一下午17:00", @"记得带名片",@"15分钟前",@"center_accept", nil]];
    
    [_tableData addObject:[NSArray arrayWithObjects:@"sample_logo", @"随银风",@"28",@"巨蟹座", @"福田深南大道7008号阳光高尔夫大厦15F星吧克咖啡厅一号厅楼", @"7月15号周一下午17:00", @"记得带名片",@"15分钟前",@"center_refuse", nil]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"activityCell";
    ActivityTableViewCell *cell = [[ActivityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    // Configure the cell...
    NSArray * cellData = [self.tableData objectAtIndex:indexPath.row];    

    cell.headerImageView.image = [UIImage imageNamed:[cellData objectAtIndex:0]];
    cell.nicknameLabel.text = [cellData objectAtIndex:1];
    cell.sexAgeLabel.text =[NSString stringWithFormat:@"%@ %@",@"♀", [cellData objectAtIndex:2]];
    cell.conLabel.text =[cellData objectAtIndex:3];
    cell.addressLabel.text =[cellData objectAtIndex:4];
    cell.nearTimeLabel.text = [cellData objectAtIndex:5];
    cell.descLabel.text =[cellData objectAtIndex:6];
    cell.beforeLabel.text = [cellData objectAtIndex:7];
    cell.statusImageView.image = [UIImage imageNamed:[cellData objectAtIndex:8]];
    cell.sexImageView.image = [UIImage imageNamed:@"sex_girl"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

//    ActivityTableViewCell *cell = (ActivityTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSString *addressStr = [[self.tableData objectAtIndex:indexPath.row] objectAtIndex:4];
    NSDictionary *attrbute = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    CGFloat textHeight = [addressStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrbute context:nil].size.height;
    
    return textHeight + kCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detail = [[DetailViewController alloc] init];
    [self.navigationController pushViewController:detail animated:YES];
}

@end
