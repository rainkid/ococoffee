//
//  MessageViewController.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/7/25.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#define kMessageListURL         @"api/message/my"

#import "Global.h"
#import "UIColor+colorBuild.h"
#import <Masonry/Masonry.h>
#import <MJRefresh/MJRefresh.h>
#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIScrollView+MJRefresh.h"
#import "MessageViewController.h"
#import "MessageCell.h"

static const CGFloat kCellHeight = 188/2;

@interface MessageViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_subTableView;
    NSMutableArray *_tableData;
    BOOL hasNext;
}

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
    self.title = @"咖友来信";

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
    [ _subTableView.header  beginRefreshing];
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
   
        [self initTableData];
        [_subTableView reloadData];
        [_subTableView.header endRefreshing];
}


#pragma mark 上拉加载更多数据
- (void)loadMoreData
{
    static const CGFloat MJDuration = 2.0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self initTableData];
        [_subTableView reloadData];
        [_subTableView.footer endRefreshing];
    });
}


- (void) initTableData {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",API_DOMAIN,kMessageListURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation,id obj){
        
        if(obj[@"data"][@"list"] && [obj[@"data"][@"list"] isKindOfClass:[NSArray class]]){
            _tableData = [[NSMutableArray alloc] initWithArray:obj[@"data"][@"list"] ];
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
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"FriendCell";
    
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if(cell == nil){
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *dict = [_tableData objectAtIndex:indexPath.row];
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"from_headimgurl"]]];
    cell.nicknameLabel.text = dict[@"from_nickname"];
    cell.timeLabel.text = dict[@"time_str"];
    cell.messageLabel.text = dict[@"message"];
    cell.numLabel.hidden = YES;
    //cell.nicknameLabel.text = @"1";
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}

@end
