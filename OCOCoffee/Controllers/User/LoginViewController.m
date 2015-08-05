//
//  LoginViewController.m
//  ococoffee
//
//  Created by sam on 15/7/27.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "Golbal.h"
#import <Masonry/Masonry.h>
#import "LoginViewController.h"
#import "LoginTableViewCell.h"
#import "RegisStepOneViewController.h"
#import "UIColor+colorBuild.h"

static const CGFloat kButtonHeight = 43;

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
    
    __weak typeof(self) weakSelf = self;

    
    //logo
    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"login_logo.png"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(PHONE_NAVIGATIONBAR_HEIGHT + 40);
        make.centerX.equalTo(self.view);
    }];
    
    
    //table view
    _tableView = [UITableView new];
    _tableView.layer.cornerRadius = 3;
    _tableView.layer.masksToBounds = YES;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.alpha = 0.7;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageView.mas_bottom).offset(41);
        make.centerX.equalTo(weakSelf.view);
        make.height.mas_equalTo(kCellHeight * 2);
        make.left.equalTo(self.view).offset(kTableLeftSide);
    }];
    
    //login button
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loginBtn.backgroundColor = [UIColor colorFromHexString:@"#4a2320"];
    loginBtn.layer.cornerRadius = 3;
    loginBtn.layer.masksToBounds = YES;
    [loginBtn setTitle:@"登录"  forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.height.mas_equalTo(kButtonHeight);
        make.left.and.right.equalTo(_tableView);
        make.top.equalTo(_tableView.mas_bottom).offset(47.5);
    }];
    
    //regis button
    UIButton *regisBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    regisBtn.backgroundColor = [UIColor whiteColor];
    regisBtn.layer.cornerRadius = 3;
    regisBtn.layer.masksToBounds = YES;
    regisBtn.alpha = 0.7;
    [regisBtn setTitle:@"注册"  forState:UIControlStateNormal];
    [regisBtn setTitleColor:[UIColor colorFromHexString:@"#4a2320"] forState:UIControlStateNormal];
    [regisBtn addTarget:self action:@selector(registerOnePage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:regisBtn];
    [regisBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.height.mas_equalTo(kButtonHeight);
        make.left.and.right.equalTo(_tableView);
        make.top.equalTo(loginBtn.mas_bottom).offset(95);
    }];
}

// 点击事件
- (IBAction)registerOnePage:(id)sender {
    RegisStepOneViewController *page = [[RegisStepOneViewController alloc] init];
    [self presentViewController:page animated:YES completion:^{
        NSLog(@"completion");
    }];
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
        [cell.imageView setImage:[UIImage imageNamed:@"login_phone"]];
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
