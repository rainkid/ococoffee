//
//  SystemMessageViewController.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/9/20.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#define kSymtemMessageURL       @"api/message/sys"

#import "SystemMessageViewController.h"
#import "ViewStyles.h"
#import "Global.h"
#import "UIColor+colorBuild.h"

#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <MJRefresh/MJRefresh.h>

#import "SystemMsgViewCell.h"
#import "InfoViewController.h"

@interface SystemMessageViewController (){
    
    UITableView *subTableview;
    NSInteger page;
    BOOL hasNext;
    NSMutableArray *dataList;
}

@end

@implementation SystemMessageViewController

-(void)viewDidLoad {
    [ViewStyles setNaviControllerStyle:self.navigationController];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(returnBack)
                                   ];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    self.title = @"小咖提醒";
    [self initView];
}

-(void)initView {
    
    subTableview = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    subTableview.tag = 10;
    subTableview.delegate = self;
    subTableview.dataSource = self;
    subTableview.bounces = YES;
    subTableview.backgroundColor = [UIColor colorFromHexString:@"#f5f5f5"];
    subTableview.showsHorizontalScrollIndicator = NO;
    subTableview.showsVerticalScrollIndicator = YES;
    subTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:subTableview];
    
    subTableview.header = [MJRefreshNormalHeader  headerWithRefreshingBlock:^(void){
        NSString *urlString = [NSString stringWithFormat:@"%@%@",API_DOMAIN,kSymtemMessageURL];
        [self loadDataFromServer:urlString params:nil];
    }];
    [subTableview.header beginRefreshing];
    
    if(hasNext){
        subTableview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^(void){
            NSString *urlString = [NSString stringWithFormat:@"%@%@",API_DOMAIN,kSymtemMessageURL];
            [self loadDataFromServer:urlString params:nil];
         }];
    }
}

-(void)loadDataFromServer:(NSString *)urlString params:(NSDictionary *)params {
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    [manager GET:urlString parameters:params success:^(AFHTTPRequestOperation *operation,id obj){
        if(obj[@"data"][@"list"] && [obj[@"data"][@"list"] isKindOfClass:[NSArray class]]){
            dataList = [[NSMutableArray alloc] initWithArray:obj[@"data"][@"list"]];
            hasNext = obj[@"data"][@"hasnext"];
            [subTableview reloadData];
            [subTableview.header endRefreshing];
            [subTableview.footer endRefreshing];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        NSLog(@"%@",error);
    }];
}

-(void)returnBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma tableview datasource methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [dataList count];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString static *identifier = @"cellIdentifier";
    SystemMsgViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[SystemMsgViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.backgroundColor = [UIColor colorFromHexString:@"#f5f5f5"];
    NSDictionary *dict = [dataList objectAtIndex:indexPath.section];
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = dict[@"title"];
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"from_headimgurl"]]placeholderImage:[UIImage imageNamed:@"default"]];
    //cell.messageLabel.text = dict[@"message"];
    
//    NSRange range = [dict[@"message"] rangeOfString:@"</em>"];
//    NSLog(@"%@",NSStringFromRange(range));
//    NSLog(@"%@",[dict[@"message"]substringWithRange:range]);
    
    NSMutableAttributedString *attrString = [self formatedString:dict[@"message"] splideStr:@"</em>"];
    cell.messageLabel.attributedText = attrString;
    return cell;
}


#pragma tableview delegate methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 26)];
    headerView.backgroundColor = [UIColor colorFromHexString:@"#f5f5f5"];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 26)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Helvetica" size:13.0];
    NSDictionary *dict = [dataList objectAtIndex:section];
    label.text = dict[@"time_str"];
    [headerView addSubview:label];
    return headerView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 26.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

-(NSMutableAttributedString *)formatedString:(NSString *)str splideStr:(NSString *)splideString {
  
    NSArray *arr = [str componentsSeparatedByString:splideString];
    NSString *name = [arr[0] substringWithRange:NSMakeRange(4, [arr[0] length]- 4)];
    NSInteger nameLength = [name length];
    NSString *string = [NSString stringWithFormat:@"%@%@",name,arr[1]];
    NSDictionary *first = @{
                            NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:14.0],
                            NSForegroundColorAttributeName:[UIColor colorFromHexString:@"#f595a6"],
                        };
    NSDictionary *second = @{
                             NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:14.0],
                             NSForegroundColorAttributeName:[UIColor blackColor]
                            };
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString setAttributes:first range:NSMakeRange(0, nameLength)];
    [attributedString setAttributes:second range:NSMakeRange(nameLength, [string length]-nameLength)];
    return attributedString;
    
}
@end
