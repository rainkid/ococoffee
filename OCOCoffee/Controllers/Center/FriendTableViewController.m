//
//  FriendTableViewController.m
//  OCOCoffee
//
//  Created by sam on 15/8/12.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#define kFriendListURL      @"api/message/friend"

#import "Global.h"
#import "UIColor+colorBuild.h"
#import <Masonry/Masonry.h>
#import <MJRefresh/MJRefresh.h>
#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIScrollView+MJRefresh.h"
#import "FriendTableViewController.h"
#include "FriendListViewCell.h"

static const CGFloat kCellHeight = 188/2;

@interface FriendTableViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_subTableView;
    NSMutableArray *_friendsList;
    BOOL hasNext;
}


@end

@implementation FriendTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"我的好友";
    
    [self initSubViews];
    [self initTableData];
}

- (void) initSubViews {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    __weak typeof(self) weakSelf = self;
    
    //tableview
    _subTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _subTableView.dataSource = self;
    _subTableView.delegate = self;
    _subTableView.bounces = YES;
    _subTableView.showsHorizontalScrollIndicator  = NO;
    _subTableView.showsVerticalScrollIndicator = YES;
    _subTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _subTableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:_subTableView];
    //set header
    _subTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullToRefresh)];
    
    [_subTableView.header beginRefreshing];
    //set footer
    
    if(hasNext){
        _subTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadMoreData];
        }];
    }
}

#pragma mark

- (void) pullToRefresh
{
    static const CGFloat MJDuration = 0.5;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self initTableData];
        [_subTableView reloadData];
        [_subTableView.header endRefreshing];
    });
}


#pragma mark 上拉加载更多数据
- (void)loadMoreData
{
        [self initTableData];
        [_subTableView reloadData];
        [_subTableView.header endRefreshing];
}

- (void) initTableData {
    NSString *urlString = [NSString stringWithFormat:@"%@%@",API_DOMAIN,kFriendListURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation,id obj){
        
        if(obj[@"data"][@"list"] && [obj[@"data"][@"list"] isKindOfClass:[NSArray class]]){
            _friendsList = [[NSMutableArray alloc] initWithArray:obj[@"data"][@"list"] ];
            hasNext = obj[@"data"][@"hasnext"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        NSLog(@"%@",error);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%lu",(unsigned long)[_friendsList count]);
    return [_friendsList count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"FriendCell";
    FriendListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if(cell == nil){
        cell = [[FriendListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSInteger row = [indexPath row];
    NSDictionary * dict = [_friendsList objectAtIndex:row];
   
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"f_headimgurl"]]];
    cell.nameLabel.text = dict[@"f_nickname"];
    UIImage *sexImage;
    if([dict[@"sex"] isEqualToString:@"1"]){
        sexImage = [UIImage imageNamed:@"sex_girl"];
    }else{
        sexImage = [UIImage imageNamed:@"sex_boy"];
    }
    cell.sexImageView.image = sexImage;
    
    cell.ageLabel.text = [NSString stringWithFormat:@"%@",dict[@"age"]];
    cell.constellationLabel.text = dict[@"constellation"];
    cell.messageLabel.text = [NSString stringWithFormat:@"最近预约时间：%@",dict[@"activity_time"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}

@end
