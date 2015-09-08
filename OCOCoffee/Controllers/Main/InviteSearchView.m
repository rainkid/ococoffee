//
//  InviteSearchView.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/9/6.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#define kInviteCellIdentifier @"identifier"

#import "InviteSearchView.h"
#import "Global.h"
#import <AFNetworking/AFNetworking.h>
#import <BaiduMapAPI/BMapKit.h>

@interface InviteSearchView ()<BMKSuggestionSearchDelegate> {
    
    UITableView *searchTableview;
    BMKSuggestionSearch *_searcher;
    BMKSuggestionSearchOption *_options ;
}

@end

@implementation InviteSearchView

-(instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
        
        [self initView];
    }
    return self;
}

-(void)initView {
    
    UIView *subView = [[UIView alloc] init];
    subView.backgroundColor = [UIColor whiteColor];
    subView.frame = CGRectMake(0, 0, 245, 212);
    [self addSubview:subView];
    
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
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = kInviteCellIdentifier;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = @"testst";
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

-(void)requestSuggestionData {
    
    if(_searcher == nil){
        _searcher = [[BMKSuggestionSearch alloc] init];
        _searcher.delegate = self;
    }
   
    _options = [[BMKSuggestionSearchOption alloc] init];
    _options.cityname  = @"深圳";
    _options.keyword   = _queryString;
    BOOL flag = [_searcher suggestionSearch:_options];
    if(flag){
        NSLog(@"发送请求成功!");
    }else{
        NSLog(@"发送失败!");
    }
    
}

-(void)onGetSuggestionResult:(BMKSuggestionSearch *)searcher result:(BMKSuggestionResult *)result errorCode:(BMKSearchErrorCode)error
{
    if(error == BMK_SEARCH_NO_ERROR){
        NSLog(@"%@",result);
    }else{
        NSLog(@"%u",error);
    }
}
@end
