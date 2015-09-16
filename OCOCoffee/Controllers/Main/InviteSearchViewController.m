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
    NSMutableArray *_ptList;
    //double lat;
    //double lng;
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
    
    NSInteger row = [indexPath row];
    NSValue *ptValue =[_ptList objectAtIndex:row];
    CLLocationCoordinate2D coordinate;
    [ptValue getValue:&coordinate];
    NSLog(@"经度:%f  纬度:%f",coordinate.latitude,coordinate.longitude);
    NSString *lat = [NSString stringWithFormat:@"%f",coordinate.latitude];
    NSString *lng = [NSString stringWithFormat:@"%f",coordinate.longitude];
    [self.delegate getSelectedData:selectedText latitude: lat logitude:lng];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 28.0;
}


-(void)suggestionData {
    _mutData = [[NSMutableArray alloc] initWithCapacity:0];
    _ptList  = [[NSMutableArray alloc] initWithCapacity:0];
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
        [_ptList addObjectsFromArray:result.ptList];
    }else{
        CGRect rect = CGRectMake(self.view.center.x-75, self.view.frame.size.height - 100, 150, 30);
        [TipView displayView:self.view withFrame:rect withString:@"抱歉，未找到相应结果！"];
    }
    [searchTableview reloadData];
}
@end
