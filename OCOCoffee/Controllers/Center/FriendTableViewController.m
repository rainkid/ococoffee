//
//  FriendTableViewController.m
//  OCOCoffee
//
//  Created by sam on 15/8/12.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//
#import "Global.h"
#import "UIColor+colorBuild.h"
#import <Masonry/Masonry.h>
#import <MJRefresh/MJRefresh.h>
#import "UIScrollView+MJRefresh.h"
#import "FriendTableViewController.h"

static const CGFloat kPhotoHeight = 126/2;
static const CGFloat kCellHeight = 188/2;

@interface FriendTableViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;

@end

@implementation FriendTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _tableData = [[NSMutableArray alloc] init];
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

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
    
    [_tableData addObject:[NSArray arrayWithObjects:@"sample_logo", @"随银风",@"28",@"巨蟹座",@"最近预约时间:7月15号周一下午17:00",nil]];
    
    [_tableData addObject:[NSArray arrayWithObjects:@"sample_logo", @"随银风",@"28",@"巨蟹座",@"最近预约时间:7月15号周一下午17:00",nil]];
    
    [_tableData addObject:[NSArray arrayWithObjects:@"sample_logo", @"随银风",@"28",@"巨蟹座",@"最近预约时间:7月15号周一下午17:00",nil]];
    
    [_tableData addObject:[NSArray arrayWithObjects:@"sample_logo", @"随银风",@"28",@"巨蟹座",@"最近预约时间:7月15号周一下午17:00",nil]];
    [_tableData addObject:[NSArray arrayWithObjects:@"sample_logo", @"随银风",@"28",@"巨蟹座",@"最近预约时间:7月15号周一下午17:00",nil]];

    [_tableData addObject:[NSArray arrayWithObjects:@"sample_logo", @"随银风",@"28",@"巨蟹座",@"最近预约时间:7月15号周一下午17:00",nil]];

    [_tableData addObject:[NSArray arrayWithObjects:@"sample_logo", @"随银风",@"28",@"巨蟹座",@"最近预约时间:7月15号周一下午17:00",nil]];

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
    NSString *age = [cellData objectAtIndex:2];
    NSString *con = [cellData objectAtIndex:3];
    NSString *lastTime =[cellData objectAtIndex:4];
    NSString *sex = @"sex_girl";
    
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
    
    //用户昵称
    UILabel *nicknameLabel = [UILabel new];
    nicknameLabel.text = nickname;
    nicknameLabel.font = [UIFont systemFontOfSize:16];
    [cell addSubview:nicknameLabel];
    [nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headerImageView.mas_top).offset(10/2);
        make.left.mas_equalTo(headerImageView.mas_right).offset(36/2);
    }];
    
    //用户性别,星座
    UIView *firstView = [UIView new];
    firstView.backgroundColor = [UIColor redColor];
    [cell addSubview:firstView];
    [firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nicknameLabel.mas_bottom).offset(8/2);
        make.height.left.mas_equalTo(nicknameLabel);
    }];
    
    UIImageView *sexView = [UIImageView new];
    sexView.image = [UIImage imageNamed:sex];
    [firstView addSubview:sexView];
    [sexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(firstView);
        make.left.mas_equalTo(firstView);
    }];
    
    UILabel *ageLabel = [UILabel new];
    ageLabel.font = font;
    ageLabel.text = age;
    ageLabel.textColor = [UIColor colorFromHexString:@"#f16681"];
    [firstView addSubview:ageLabel];
    [ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(firstView);
        make.left.mas_equalTo(sexView.mas_right).offset(16/2);
    }];
    
    UILabel *conLabel =[UILabel new];
    conLabel.text = con;
    conLabel.font = font;
    conLabel.textColor = [UIColor colorFromHexString:@"#f16681"];
    [firstView addSubview:conLabel];
    [conLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(firstView);
        make.left.mas_equalTo(ageLabel.mas_right).offset(16/2);
    }];
    
    UILabel *lastLabel = [UILabel new];
    lastLabel.text = lastTime;
    lastLabel.textColor = [UIColor colorFromHexString:@"#888888"];
    lastLabel.font = font;
    [cell addSubview:lastLabel];
    [lastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(firstView.mas_bottom).offset(8/2);
        make.left.mas_equalTo(firstView);
    }];
    
    
    //
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor colorFromHexString:@"#f5f5f5"];
    [cell addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(lastLabel.mas_left);
        make.right.mas_equalTo(weakSelf.mas_right);
        make.top.mas_equalTo(lastLabel.mas_bottom).offset(26/2);
    }];
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}

@end
