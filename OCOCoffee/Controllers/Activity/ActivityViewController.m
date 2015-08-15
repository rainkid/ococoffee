//
//  ActivityTableViewController.m
//  OCOCoffee
//
//  Created by sam on 15/8/10.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "Golbal.h"
#import "UIColor+colorBuild.h"
#import <Masonry/Masonry.h>
#import <MJRefresh/MJRefresh.h>
#import "UIScrollView+MJRefresh.h"
#import "DetailViewController.h"
#import "ActivityViewController.h"


static const CGFloat kPhotoHeight = 126/2;
static const CGFloat kCellHeight = 522/2;

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
    static NSString *MyIdentifier = @"MyIdentifier";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    __weak typeof(cell) weakSelf = cell;

    // Configure the cell...
    
    NSArray * cellData = [self.tableData objectAtIndex:indexPath.row];
    UIFont *font = [UIFont systemFontOfSize:14];
    UIColor *labelTextCollor = [UIColor colorFromHexString:@"#888888"];
    
    NSString *image =[cellData objectAtIndex:0];
    NSString *nickname =[cellData objectAtIndex:1];
    NSString *age = [cellData objectAtIndex:2];
    NSString *con = [cellData objectAtIndex:3];
    NSString *address =[cellData objectAtIndex:4];
    NSString *time =[cellData objectAtIndex:5];
    NSString *desc =[cellData objectAtIndex:6];
    NSString *timeBefore = [cellData objectAtIndex:7];
    NSString *status = [cellData objectAtIndex:8];
    NSString *sex = @"sex_girl";
    

    //用户图像
    UIImageView *headerImageView = [UIImageView new];
    headerImageView.image = [UIImage imageNamed:image];
    headerImageView.layer.cornerRadius = (kPhotoHeight) /2;
    headerImageView.layer.masksToBounds = YES;
    headerImageView.userInteractionEnabled = YES;
    [cell addSubview:headerImageView];
    
    [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(weakSelf).offset(32/2);
        make.width.height.mas_equalTo(kPhotoHeight);
    }];
    
    //状态图片
    UIImageView *statusImageView =[UIImageView new];
    statusImageView.image = [UIImage imageNamed:status];
    [cell addSubview:statusImageView];
    [statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_equalTo(cell);
    }];

    //用户昵称
    UILabel *nicknameLabel = [UILabel new];
    nicknameLabel.text = nickname;
    nicknameLabel.font = [UIFont systemFontOfSize:16];
    [cell addSubview:nicknameLabel];
    [nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headerImageView.mas_top).offset(22/2);
        make.left.mas_equalTo(headerImageView.mas_right).offset(36/2);
    }];

    //用户性别,星座
    UIView *firstView = [UIView new];
    firstView.backgroundColor = [UIColor redColor];
    [cell addSubview:firstView];
    [firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nicknameLabel.mas_bottom).offset(24/2);
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
        make.left.mas_equalTo(sexView.mas_right).offset(14/2);
    }];

    UILabel *conLabel =[UILabel new];
    conLabel.text = con;
    conLabel.font = font;
    conLabel.textColor = [UIColor colorFromHexString:@"#f16681"];
    [firstView addSubview:conLabel];
    [conLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(firstView);
        make.left.mas_equalTo(ageLabel.mas_right).offset(14/2);
    }];
    
    
    //
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor colorFromHexString:@"#f5f5f5"];
    [cell addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(headerImageView.mas_left);
        make.right.mas_equalTo(weakSelf.mas_right);
        make.top.mas_equalTo(headerImageView.mas_bottom).offset(24/2);
    }];

    
    //计算address的高度
    CGSize constraint = CGSizeMake(line.frame.size.width, MAXFLOAT);
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGRect textsize = [address boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    float textHeight = textsize.size.height;
    
    //
    UIView *secondView = [UIView new];
    [cell addSubview:secondView];
    [secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(textHeight+20);
        make.right.mas_equalTo(weakSelf.mas_right).offset(-20);
        make.top.mas_equalTo(line.mas_bottom).offset(24/2);
        make.left.mas_equalTo(headerImageView);
    }];

    
    UIImageView *addressImageView = [UIImageView new];
    addressImageView.image = [UIImage imageNamed:@"center_address"];
    [secondView addSubview:addressImageView];
    [addressImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(26/2);
        make.left.top.mas_equalTo(secondView);
    }];

    
    //address标签
    UILabel *addressLabel = [UILabel new];
    addressLabel.text = address;
    addressLabel.font = font;
    addressLabel.numberOfLines = 0;
    addressLabel.textColor = labelTextCollor;
    addressLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [secondView addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(addressImageView.mas_right).offset(24/2);
        make.right.mas_equalTo(secondView.mas_right);
        make.top.mas_equalTo(secondView.mas_top);
    }];

    //timeview
    UIView *threeView = [UIView new];
    [cell addSubview:threeView];
    [threeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(28/2);
        make.top.mas_equalTo(secondView.mas_bottom).offset(24/2);
        make.left.right.mas_equalTo(secondView);
    }];

    UIImageView *timeImageView = [UIImageView new];
    timeImageView.image= [UIImage imageNamed:@"center_time"];
    [threeView addSubview:timeImageView];
    [timeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerY.mas_equalTo(threeView.mas_centerY);
        make.left.mas_equalTo(threeView.mas_left);
    }];

    UILabel *timeLabel = [UILabel new];
    timeLabel.text = time;
    timeLabel.font = font;
    timeLabel.textColor = labelTextCollor;
    [threeView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(timeImageView.mas_right).offset(24/2);
        make.centerY.mas_equalTo(threeView.mas_centerY);
    }];

    //descview
    
    UIView *fourView = [UIView new];
    [cell addSubview:fourView];
    [fourView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30/2);
        make.top.mas_equalTo(threeView.mas_bottom).offset(24/2);
        make.left.right.mas_equalTo(threeView);
    }];
    
    UIImageView *descImageView = [UIImageView new];
    descImageView.image= [UIImage imageNamed:@"center_desc"];
    [fourView addSubview:descImageView];
    [descImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(fourView);
        make.left.mas_equalTo(fourView);
    }];

    UILabel *descLabel = [UILabel new];
    descLabel.text = desc;
    descLabel.font = font;
    descLabel.textColor = labelTextCollor;
    [fourView addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(descImageView.mas_right).offset(24/2);
        make.centerY.mas_equalTo(fourView);
    }];

    UIView *lineTwo = [UIView new];
    lineTwo.backgroundColor = [UIColor colorFromHexString:@"#f5f5f5"];
    [cell addSubview:lineTwo];
    [lineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.left.mas_equalTo(line);
        make.top.mas_equalTo(fourView.mas_bottom).offset(24/2);
    }];

    UILabel *beforeLabel = [UILabel new];
    beforeLabel.text = timeBefore;
    beforeLabel.textColor = labelTextCollor;
    beforeLabel.font = font;
    [cell addSubview:beforeLabel];
    [beforeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineTwo.mas_bottom).offset(24/2);
        make.right.mas_equalTo(weakSelf.mas_right).offset(-2);
    }];

    UIView *bottom = [UIView new];
    bottom.backgroundColor = [UIColor colorFromHexString:@"#f5f5f5"];
    [cell addSubview:bottom];
    [bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(weakSelf);
        make.top.mas_equalTo(beforeLabel.mas_bottom).offset(24/2);
        make.height.mas_equalTo(14/2);
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    DetailViewController *detail = [[DetailViewController alloc] init];
    [self.navigationController pushViewController:detail animated:YES];
}

@end