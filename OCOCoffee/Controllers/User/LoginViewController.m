//
//  LoginViewController.m
//  ococoffee
//
//  Created by sam on 15/7/27.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "Golbal.h"
#import "LoginViewController.h"
#import "LoginTableViewCell.h"
#import "RegisStepOneViewController.h"
#import "UIColor+colorBuild.h"

@interface LoginViewController()<UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initialize];
    NSLog(@"%@", self.navigationController);
    self.navigationController.delegate = self;
}

- (void) initialize{
    [self intializeView];
}

- (void) intializeView {
    UIImage *bg_image = [UIImage imageNamed:@"background.png"];
    UIImageView *bg_imageView = [[UIImageView alloc] initWithImage:bg_image];
    [bg_imageView setFrame:self.view.bounds];
    
    [self.view addSubview: bg_imageView];
    
    long logoWith = 80.3;
    long logoHeight = 104;
    long logoLeft = (SCREEN_WIDTH - logoWith) /2;
    
    UIImage *image = [UIImage imageNamed:@"login_logo.png"];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(logoLeft, PHONE_NAVIGATIONBAR_HEIGHT+38, logoWith, logoHeight)];
    imageView.image = image;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.view addSubview:imageView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(kTableLeftSide, PHONE_NAVIGATIONBAR_HEIGHT + 181.6, SCREEN_WIDTH - (kTableLeftSide*2), self.view.bounds.size.height - logoHeight)];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, 94.6)];

    _tableView.layer.cornerRadius = 3;
    _tableView.layer.masksToBounds = YES;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.alpha = 0.7;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [view addSubview:_tableView];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loginBtn.frame = CGRectMake(0, 115, view.frame.size
                                .width, 46.4);
    loginBtn.backgroundColor = [UIColor colorFromHexString:@"#4a2320"];
    loginBtn.layer.cornerRadius = 3;
    loginBtn.layer.masksToBounds = YES;
    [loginBtn setTitle:@"登录"  forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [view addSubview:loginBtn];
    
    UIButton *regisBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    regisBtn.frame = CGRectMake(0, 253.3, view.frame.size
                                .width, 46.4);
    regisBtn.backgroundColor = [UIColor whiteColor];
    regisBtn.layer.cornerRadius = 3;
    regisBtn.layer.masksToBounds = YES;
    regisBtn.alpha = 0.7;
    [regisBtn setTitle:@"注册"  forState:UIControlStateNormal];
    [regisBtn setTitleColor:[UIColor colorFromHexString:@"#4a2320"] forState:UIControlStateNormal];
    
    [regisBtn addTarget:self action:@selector(registerOnePage:) forControlEvents:UIControlEventTouchUpInside];
    
   
    [view addSubview:regisBtn];
    
    [self.view addSubview:view];
}

// 点击事件
- (IBAction)registerOnePage:(id)sender {
    RegisStepOneViewController *one = [[RegisStepOneViewController alloc] init];
    [self.navigationController pushViewController:one animated:YES];
}


#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController != self) {
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.navigationController.navigationBar.alpha = 1.0;
        } completion:NULL];
    }
}

#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LoginTableViewCell *cell=[[LoginTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    
    
    if (indexPath.row == 0){
        [cell.imageView setImage:[UIImage imageNamed:@"login_username"]];
        [cell.textField setPlaceholder:@"请输入手机号码"];
        cell.textField.keyboardType = UIKeyboardTypePhonePad;
        [cell setBottomLine:YES];
    } else if (indexPath.row == 1) {
        [cell.imageView setImage:[UIImage imageNamed:@"login_password"]];
        [cell.textField setPlaceholder:@"请输入密码"];
        cell.textField.secureTextEntry = YES;
        [cell setBottomLine:NO];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.0;
    }
    
    return 1.0;
}
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 9.0;
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}
@end
