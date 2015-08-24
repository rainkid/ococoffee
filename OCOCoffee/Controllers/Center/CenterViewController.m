//
//  CenterViewController.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/7/25.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import "Global.h"
#import "UIColor+colorBuild.h"
#import "CenterViewController.h"
#import "CenterTableViewCell.h"
#import "ActivityViewController.h"
#import "FriendTableViewController.h"
#import "MessageViewController.h"
#import <Masonry/Masonry.h>

static const CGFloat kPhotoHeight = 82;

@interface CenterViewController ()<UITableViewDataSource, UITableViewDelegate>
    
@property(nonatomic, strong) UIImageView *imageView;

@end

@implementation CenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    
    self.title = @"我的";
    self.view.backgroundColor = [UIColor whiteColor];

    UIImageView *bg_imageView = [UIImageView new];
    bg_imageView.image =[UIImage imageNamed:@"center_bg"];
    [self.view addSubview:bg_imageView];
    [bg_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(274/2);
        make.top.mas_equalTo(weakSelf.view.mas_top).offset(PHONE_TOP_HEIGHT);
    }];
    
    //photo cyctle
    UIView *photoView = [UIView new];
    long kPhotoSlide = 8;
    long kCPhotoHeight =kPhotoHeight+kPhotoSlide;
    photoView.layer.cornerRadius = kCPhotoHeight/2;
    photoView.layer.masksToBounds = YES;
    photoView.layer.borderWidth = 1.0f;
    photoView.layer.borderColor = [UIColor whiteColor].CGColor;
    photoView.alpha = 0.9;
    [self.view addSubview:photoView];
    [photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.height.and.width.mas_equalTo(kCPhotoHeight);
        make.top.mas_equalTo(bg_imageView.mas_top).offset(3);
    }];
    
    //phone inner image
    _imageView = [UIImageView new];
    _imageView.image = [UIImage imageNamed:@"sample_logo"];
    _imageView.layer.cornerRadius = (kPhotoHeight) /2;
    _imageView.layer.masksToBounds = YES;    
    
    [self.view addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.mas_equalTo(photoView.mas_top).offset(kPhotoSlide/2);
        make.height.and.width.mas_equalTo(kPhotoHeight);
    }];
    
    //labels
    UILabel *label_1 = [UILabel new];
    label_1.text = @"董事长";
    label_1.font = [UIFont systemFontOfSize:15];
    label_1.textColor = [UIColor colorFromHexString:@"#7d4c28"];
    [self.view addSubview:label_1];
    [label_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_imageView.mas_bottom).offset(14/3);
        make.centerX.equalTo(weakSelf.view);
    }];
    
    UILabel *label_2 = [UILabel new];
    label_2.text = @"ID:123456";
    label_2.font = [UIFont systemFontOfSize:15];
    label_2.textColor = [UIColor colorFromHexString:@"#7d4c28"];
    [self.view addSubview:label_2];
    [label_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label_1.mas_bottom).offset(2);
        make.centerX.equalTo(weakSelf.view);
    }];
    
    UIView * botView= [UIView new];
    botView.backgroundColor = [UIColor colorFromHexString:@"#f5f5f5"];
    [self.view addSubview:botView];
    [botView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bg_imageView.mas_bottom);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.left.right.mas_equalTo(weakSelf.view);
    }];
    
    //bot view
    UIView *centerView = [UIView new];
    [self.view addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(80.2);
        make.left.right.width.mas_equalTo(weakSelf.view);
        make.top.mas_equalTo(bg_imageView.mas_bottom);
    }];

    //notice view
    UIView *noticeView = [UIView new];
    noticeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:noticeView];
    [noticeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.top.mas_equalTo(centerView);
        make.left.mas_equalTo(centerView);
        make.width.mas_equalTo(SCREEN_WIDTH/2 - 1);
    }];
    
    //notice image view
    UIImageView *noticeImageView = [UIImageView new];
    noticeImageView.image = [UIImage imageNamed:@"center_notice"];
    [self.view addSubview:noticeImageView];
    [noticeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(noticeView);
    }];
    
    //msg view
    UIView *msgView = [UIView new];
    msgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:msgView];
    [msgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.top.mas_equalTo(centerView);
        make.centerY.mas_equalTo(centerView);
        make.right.equalTo(centerView.mas_right);
        make.width.mas_equalTo(SCREEN_WIDTH/2 - 1);
    }];
    
    //msg image view
    UIImageView *msgImageView = [UIImageView new];
    msgImageView.image = [UIImage imageNamed:@"center_msg"];
    [self.view addSubview:msgImageView];
    [msgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(msgView);
    }];

    
    //table view
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.centerX.equalTo(weakSelf.view);
        make.height.mas_equalTo(kCellHeight*4 + 32);
        make.top.mas_equalTo(msgView.mas_bottom).offset(28/3);
    }];
}

#pragma tableview delegate methods

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellidentifier = @"cellIdentifier";
    CenterTableViewCell *cell=[[CenterTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    NSLog(@"%ld==%ld", section, row);
    if(section == 0){
        switch (row) {
            case 0:{
                [cell.limageView setImage:[UIImage imageNamed:@"center_01"]];
                cell.tag = CENTER_MY_ACTIVITY;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.label.text = @"我的活动";
            } break;
                
            case 1:{
                [cell.limageView setImage:[UIImage imageNamed:@"center_02"]];
                cell.tag = CENTER_MY_FRIEND;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.label.text = @"我的好友";

            } break;
        }
        
    }else if (section == 1){
        switch (row) {
            case 0:{
                [cell.limageView setImage:[UIImage imageNamed:@"center_03"]];
                cell.tag = CENTER_SYS_MSG;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.label.text = @"系统消息";
            } break;
                
            case 1:{
                [cell.limageView setImage:[UIImage imageNamed:@"center_03"]];
                cell.tag = CENTER_SETTING;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.label.text = @"设置";
            } break;
        }
    }
    
    
    return cell;
}

#pragma tableview datasource method

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 1.0f;
    } else {
        return 1.0f;
    }
}

- (NSString*) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    } else {
        // return some string here ...
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CenterTableViewCell *cell = (CenterTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    switch (cell.tag) {
        case CENTER_MY_ACTIVITY:{
            ActivityViewController *activity = [[ActivityViewController alloc] init];
            [self.navigationController pushViewController:activity animated:YES];
        }
            break;
        case CENTER_MY_FRIEND: {
            FriendTableViewController *friend = [[FriendTableViewController alloc] init];
            [self.navigationController pushViewController:friend animated:YES];
        }
            break;
        case CENTER_SYS_MSG:{
            MessageViewController *message = [[MessageViewController alloc] init];
            [self.navigationController pushViewController:message animated:YES];
        }
            break;
        case CENTER_SETTING:{
            
        }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
