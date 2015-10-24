//
//  CenterViewController.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/7/25.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import "Global.h"
#import "Common.h"
#import "UIColor+colorBuild.h"
#import "CenterViewController.h"
#import "CenterTableViewCell.h"
#import "FriendTableViewController.h"
#import "MessageViewController.h"
#import "CenterEditTableViewController.h"
#import "LoginViewController.h"
#import "SystemMessageViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFNetworking/AFNetworking.h>
#import <Masonry/Masonry.h>
#import "ActivityDetailViewController.h"
#import "ActivityTableViewController.h"

static const CGFloat kPhotoHeight = 82;

@interface CenterViewController ()<UITableViewDataSource, UITableViewDelegate, LoginSuccessProtocol,CenterEditTableViewControllerDelegate>
    
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UILabel *nickname;
@property(nonatomic, strong) UILabel *uniqueId;
@property(nonatomic, strong) UILabel *sysPoint;
@property(nonatomic, strong) UILabel *msgPoint;

@property(nonatomic,strong) NSMutableDictionary *userData;


@end

@implementation CenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的";
    self.view.backgroundColor = [UIColor whiteColor];

    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    [self loginOut];
    [self initSubViews];
    [self checkLogin];
    
    _userData = [[NSMutableDictionary alloc] initWithCapacity:1];
}

-(void)initSubViews
{
    __weak typeof(self) weakSelf = self;

    UIImageView *bg_imageView = [UIImageView new];
    bg_imageView.image =[UIImage imageNamed:@"center_bg"];
    [self.view addSubview:bg_imageView];
    [bg_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(274/2);
        make.top.mas_equalTo(weakSelf.view.mas_top).offset(PHONE_TOP_HEIGHT);
    }];
    
    //photo cyctle
    long kPhotoSlide = 8;
    long kCPhotoHeight =kPhotoHeight+kPhotoSlide;
    UIView *photoView = [UIView new];
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
    self.imageView = ({
        UIImageView *imageView = [UIImageView new];
        imageView.layer.cornerRadius = (kPhotoHeight) /2;
        imageView.layer.masksToBounds = YES;
        imageView;
    });
    
    self.imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editMsg:)];
    [self.imageView addGestureRecognizer:tap];
    
    [self.view addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.mas_equalTo(photoView.mas_top).offset(kPhotoSlide/2);
        make.height.and.width.mas_equalTo(kPhotoHeight);
    }];
    
    //labels
    self.nickname = ({
        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor colorFromHexString:@"#7d4c28"];
        label;
    });
    [self.view addSubview:self.nickname];
    [self.nickname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_imageView.mas_bottom).offset(14/3);
        make.centerX.equalTo(weakSelf.view);
    }];
    
    self.uniqueId = ({
        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor colorFromHexString:@"#7d4c28"];
        label;
    });
    [self.view addSubview:self.uniqueId];
    [self.uniqueId mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.nickname.mas_bottom).offset(2);
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
    
    CGFloat pointWH = 35/2;
    self.sysPoint = ({
        UILabel *label = [UILabel new];
        label.layer.cornerRadius = pointWH/2;
        label.layer.masksToBounds = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:12];
        label.backgroundColor = [UIColor colorFromHexString:@"#ee524d"];
        label;
    });
    [self.view addSubview:self.sysPoint];
    [self.sysPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(pointWH);
        make.centerX.mas_equalTo(noticeView.mas_centerX).offset(30);
        make.centerY.mas_equalTo(noticeView.mas_centerY).offset(-25);
    }];
    
    //notice image view
    UIImageView *noticeImageView = [UIImageView new];
    noticeImageView.image = [UIImage imageNamed:@"center_notice"];
    [self.view addSubview:noticeImageView];
    [noticeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(noticeView);
    }];
    
    noticeImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *noticeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showNotice:)];
    [noticeImageView addGestureRecognizer:noticeTap];
    
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
    
    self.msgPoint = ({
        UILabel *label = [UILabel new];
        label.layer.cornerRadius = pointWH/2;
        label.layer.masksToBounds = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:12];
        label.backgroundColor = [UIColor colorFromHexString:@"#ee524d"];
        label;
    });
    [self.view addSubview:self.msgPoint];
    [self.msgPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(pointWH);
        make.centerX.mas_equalTo(msgView.mas_centerX).offset(30);
        make.centerY.mas_equalTo(msgView.mas_centerY).offset(-25);
    }];
    
    //msg image view
    UIImageView *msgImageView = [UIImageView new];
    msgImageView.image = [UIImage imageNamed:@"center_msg"];
    [self.view addSubview:msgImageView];
    [msgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(msgView);
    }];
    
    UITapGestureRecognizer *messageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMessage:)];
    msgImageView.userInteractionEnabled = YES;
    [msgImageView addGestureRecognizer:messageTap];
    //table view
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
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


-(void)editMsg:(UITapGestureRecognizer *) gestureRecognizer {
    NSLog(@"编辑个人资料");
    CenterEditTableViewController *editViewController = [[CenterEditTableViewController alloc] init];
    editViewController.userDict = _userData;
    editViewController.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:editViewController];
    [self.navigationController presentViewController:navController animated:YES completion:^(void){
        NSLog(@"completed");
    }];
}

-(void)showNotice:(UITapGestureRecognizer *)tap {
    SystemMessageViewController *sysViewController = [[SystemMessageViewController alloc] init];
    UINavigationController *navSysController = [[UINavigationController alloc] initWithRootViewController:sysViewController];
    [self.navigationController presentViewController:navSysController animated:YES completion:nil];
}

-(void)showMessage:(UITapGestureRecognizer *)tap{
    
    MessageViewController *messageViewController = [[MessageViewController alloc] init];
    [self.navigationController pushViewController:messageViewController animated:YES];
    
}


-(void) loadDataFromServer
{
    NSString *listApiUrl = API_DOMAIN@"api/user/center";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //get cookie data

    [manager POST:listApiUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        if([responseObject[@"data"] isKindOfClass:[NSDictionary class]]){
            [_userData addEntriesFromDictionary:responseObject[@"data"]];
            [self analyseInfoResponse:responseObject];
            
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(void)UserLoginSuccess {
    NSLog(@"LoginSuccess");
    [self loadDataFromServer];
}

-(void) loginOut
{;
    NSLog(@"login out");
    [Common userLogOut];
}

-(void)checkLogin
{
    if(![Common userIsLogin] == false) {
        [self showLoginPage];
    } else {
        [self loadDataFromServer];
    }
}

-(void) analyseInfoResponse:(NSDictionary *)jsonObject
{
    if ([jsonObject isKindOfClass:[NSDictionary class]]) {
        if ([jsonObject[@"success"] integerValue] == 1) {
            NSDictionary *data = jsonObject[@"data"];
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:data[@"headimgurl"]]];
            [self.nickname setText:data[@"nickname"]];
            [self.uniqueId setText:data[@"uid"]];
            [self.sysPoint setText:data[@"sys_msg_count"]];
            [self.msgPoint setText:data[@"friend_msg_count"]];
        } else {
            [self showLoginPage];
        }
    } else {
        NSLog(@"response error");
    }

}

-(void) showLoginPage
{
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    loginViewController.delegate = self;
    [self.parentViewController presentViewController:loginViewController animated:YES completion:nil];
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
            ActivityTableViewController *activity = [[ActivityTableViewController alloc] init];
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


-(void)loadNewDataFromServer{
    [self loadDataFromServer];
}
@end
