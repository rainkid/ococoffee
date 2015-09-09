//
//  InviteSearchViewController.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/9/7.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#define kInviteCellIdentifier @"identifier"

#import "InviteSearchViewController.h"
#import "Global.h"
#import <BaiduMapAPI/BMapKit.h>
#import "TipView.h"

@interface InviteSearchViewController()<BMKSuggestionSearchDelegate> {
    UITableView *searchTableview;
    BMKSuggestionSearch *_searcher;
    BMKSuggestionSearchOption *options;
    
    NSMutableArray *_mutData;
}

@end

@implementation InviteSearchViewController

-(void)viewDidLoad {
    
    [self initView];
   
}

-(void)viewWillDisappear:(BOOL)animated {
    _searcher.delegate = self;
}

-(void)initView {
    
    UIView *subView = [[UIView alloc] init];
    subView.backgroundColor = [UIColor whiteColor];
    subView.frame = CGRectMake(0, 0, 245, 212);
    [self.view addSubview:subView];
    
    searchTableview = [[UITableView alloc] initWithFrame:subView.frame style:UITableViewStylePlain];
    searchTableview.backgroundColor = [UIColor whiteColor];
    searchTableview.delegate = self;
    searchTableview.dataSource = self;
    searchTableview.showsHorizontalScrollIndicator = NO;
    searchTableview.showsVerticalScrollIndicator = NO;
    searchTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    searchTableview.layer.borderWidth = 0.5;
    searchTableview.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [subView addSubview:searchTableview];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_mutData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = kInviteCellIdentifier;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = _mutData[indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"hervica" size:11.0];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSString *selectedText = cell.textLabel.text;
    [self.delegate getSelectedData:selectedText lat:@"12.00343" log:@"240.33454"];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 28.0;
}


//-(void)loadDataFromServer {
//    
//    NSString *urlString = BAIDUSUGGESTION;
//    NSString *ak = BAIDUKEY;
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    NSDictionary *params = @{@"q":_queryString,@"region":@"深圳",@"output":@"json",@"ak":ak};
//    NSLog(@"%@",params);
//    [manager GET:urlString parameters:params success:^(AFHTTPRequestOperation *operation , id responseObj){
//        
//        NSLog(@"%@",responseObj);
//        
//    }failure:^(AFHTTPRequestOperation *operation,NSError *error){
//        
//    }];
//    
//}

-(void)suggestionData {
    _mutData = [[NSMutableArray alloc] initWithCapacity:0];
    if(_searcher == nil){
        _searcher = [[BMKSuggestionSearch alloc] init];
        _searcher.delegate = self;
        options = [[BMKSuggestionSearchOption alloc] init];
        options.cityname = @"深圳";
    }
    
    options.keyword = _queryString;
    BOOL flag =  [_searcher suggestionSearch:options];
    if(flag){
        NSLog(@"成功");
    }else {
        NSLog(@"失败");
    }

}

-(void)onGetSuggestionResult:(BMKSuggestionSearch *)searcher result:(BMKSuggestionResult *)result errorCode:(BMKSearchErrorCode)error
{
    if(error == BMK_SEARCH_NO_ERROR){
        [_mutData addObjectsFromArray:result.keyList];
        
        NSLog(@"PT:%@",result.ptList);
        NSLog(@"POI:%@",result.poiIdList);
    }else{
        CGRect rect = CGRectMake(self.view.center.x-75, self.view.frame.size.height - 100, 150, 30);
        [TipView displayView:self.view withFrame:rect withString:@"抱歉，未找到相应结果！"];
    }
    [searchTableview reloadData];
}
@end
