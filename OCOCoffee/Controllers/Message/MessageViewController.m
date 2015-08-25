//
//  MessageViewController.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/7/25.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//
#import "Global.h"
#import "UIColor+colorBuild.h"
#import <Masonry/Masonry.h>
#import <MJRefresh/MJRefresh.h>
#import "UIScrollView+MJRefresh.h"
#import "MessageViewController.h"

static const CGFloat kPhotoHeight = 126/2;
static const CGFloat kCellHeight = 188/2;

@interface MessageViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;

@end

@implementation MessageViewController


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
    self.title = @"消息";

    [self initSubViews];
    [self initTableData];
}

- (void) initSubViews {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    __weak typeof(self) weakSelf = self;
    
    //tableview
    UITableView *tableView = [UITableView new];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.estimatedRowHeight = kCellHeight;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    [_tableData addObject:[NSArray arrayWithObjects:@"sample_logo", @"随银风",@"大哥，我只是个教书的",@"3", @"13:00",nil]];
    
    [_tableData addObject:[NSArray arrayWithObjects:@"sample_logo", @"随银风",@"大哥，我只是个教书的",@"3", @"13:00",nil]];
    
    [_tableData addObject:[NSArray arrayWithObjects:@"sample_logo", @"随银风",@"大哥，我只是个教书的",@"3", @"13:00",nil]];
    
    [_tableData addObject:[NSArray arrayWithObjects:@"sample_logo", @"随银风",@"大哥，我只是个教书的",@"3", @"13:00",nil]];
    [_tableData addObject:[NSArray arrayWithObjects:@"sample_logo", @"随银风",@"大哥，我只是个教书的",@"3", @"13:00",nil]];
    
    [_tableData addObject:[NSArray arrayWithObjects:@"sample_logo", @"随银风",@"大哥，我只是个教书的",@"3", @"13:00",nil]];
    
    [_tableData addObject:[NSArray arrayWithObjects:@"sample_logo", @"随银风",@"大哥，我只是个教书的",@"3", @"13:00",nil]];
    
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
    static NSString *MyIdentifier = @"FriendCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    __weak typeof(cell) weakSelf = cell;
    
    NSArray * cellData = [self.tableData objectAtIndex:indexPath.row];
    UIFont *font = [UIFont systemFontOfSize:13];
    
    NSString *image =[cellData objectAtIndex:0];
    NSString *nickname =[cellData objectAtIndex:1];
    NSString *message = [cellData objectAtIndex:2];
    NSString *number = [cellData objectAtIndex:3];
    NSString *lastTime = [cellData objectAtIndex:4];
    
    //用户图像
    UIImageView *headerImageView = [UIImageView new];
    headerImageView.image = [UIImage imageNamed:image];
    headerImageView.layer.cornerRadius = (kPhotoHeight) /2;
    headerImageView.layer.masksToBounds = YES;
    headerImageView.userInteractionEnabled = YES;
    [cell addSubview:headerImageView];
    
    [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(weakSelf).offset(26/2);
        make.width.height.mas_equalTo(kPhotoHeight);
    }];
    
    UILabel *numLael = [UILabel new];
    numLael.text = number;
    numLael.layer.cornerRadius = 18/2;
    numLael.layer.masksToBounds = YES;
    numLael.textAlignment = NSTextAlignmentCenter;
    numLael.textColor = [UIColor whiteColor];
    numLael.backgroundColor = [UIColor colorFromHexString:@"#ee524d"];
    [cell addSubview:numLael];
    [numLael mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(18);
        make.top.mas_equalTo(headerImageView.mas_top);
        make.right.mas_equalTo(headerImageView.mas_right).offset(18/2);
    }];
    
    //用户昵称
    UILabel *nicknameLabel = [UILabel new];
    nicknameLabel.text = nickname;
    nicknameLabel.font = [UIFont systemFontOfSize:16];
    [cell addSubview:nicknameLabel];
    [nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headerImageView.mas_top).offset(16/2);
        make.left.mas_equalTo(headerImageView.mas_right).offset(36/2);
    }];
    
    UILabel *timeLabel = [UILabel new];
    timeLabel.text = lastTime;
    timeLabel.font = font;
    timeLabel.textColor = [UIColor colorFromHexString:@"#888888"];
    [cell addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nicknameLabel.mas_top);
        make.right.mas_equalTo(weakSelf.mas_right).offset(-8);
    }];

    UILabel *msgLabel = [UILabel new];
    msgLabel.text = message;
    msgLabel.textColor = [UIColor colorFromHexString:@"#888888"];
    msgLabel.font = font;
    [cell addSubview:msgLabel];
    [msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nicknameLabel.mas_bottom).offset(28/2);
        make.left.mas_equalTo(nicknameLabel);
    }];
    
    //
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor colorFromHexString:@"#f5f5f5"];
    [cell addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(msgLabel.mas_left);
        make.right.mas_equalTo(weakSelf.mas_right);
        make.top.mas_equalTo(msgLabel.mas_bottom).offset(26/2);
    }];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}

@end
