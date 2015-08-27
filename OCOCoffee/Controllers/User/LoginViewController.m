//
//  LoginViewController.m
//  ococoffee
//
//  Created by sam on 15/7/27.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "Global.h"
#import "Common.h"
#import <Masonry/Masonry.h>
#import "LoginViewController.h"
#import "LoginTableViewCell.h"
#import "RegisStepOneViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "UIColor+colorBuild.h"

static const CGFloat kButtonHeight = 43;

@interface LoginViewController()<UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UITextField *usernameTextField;
@property(nonatomic, strong) UITextField *passwordTextField;
@property(nonatomic, strong) UIButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self intializeView];
    self.navigationController.delegate = self;
}

- (void) intializeView {
    UIImage *bg_image = [UIImage imageNamed:@"background"];
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
    self.tableView = ({
        UITableView *tableView = [UITableView new];
        tableView.layer.cornerRadius = 3;
        tableView.layer.masksToBounds = YES;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.alpha = 0.7;
        tableView.scrollEnabled = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.showsHorizontalScrollIndicator = NO;
        tableView;
    });
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageView.mas_bottom).offset(41);
        make.centerX.equalTo(weakSelf.view);
        make.height.mas_equalTo(kCellHeight * 2);
        make.left.equalTo(self.view).offset(kTableLeftSide);
    }];
    
    //login button
    self.loginButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.backgroundColor = [UIColor colorFromHexString:@"#4a2320"];
        button.layer.cornerRadius = 3;
        button.layer.masksToBounds = YES;
        button.enabled = NO;
        [button setTitle:@"登录"  forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(loginPost:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.view addSubview:self.loginButton];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
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
        make.top.equalTo(weakSelf.loginButton.mas_bottom).offset(95);
    }];
}

// login_post
- (IBAction)loginPost:(id)sender {
    NSString *phone = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;

    NSString *listApiUrl = API_DOMAIN@"api/user/login_post";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"phone":phone, @"password":password};
    
    [manager POST:listApiUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"%@", responseObject);
        [self analyseLoginResponse:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(IBAction)textFieldDidChange:(id)sender {
    NSString *phone = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    NSLog(@"login check");
    if ([password length] == 0 || [phone length] == 0) {
        self.loginButton.enabled = NO;
    } else {
        self.loginButton.enabled = YES;
        [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

-(void)analyseLoginResponse:(NSDictionary *)jsonObject
{
    if ([jsonObject isKindOfClass:[NSDictionary class]]) {
        if ([jsonObject[@"success"] integerValue] == 1) {
            
            [self dismissViewControllerAnimated:YES completion:^{
                //set cookid data
                [Common shareUserCookie];
                //
                if (self.delegate) {
                    NSLog(@"delegate login success");
                    [self.delegate UserLoginSuccess];
                }

            }];

        } else {
            [Common showErrorDialog:jsonObject[@"msg"]];
        }
    } else {
        NSLog(@"response error");
    }
}


// register
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
        self.usernameTextField = cell.textField;
        [cell setBottomLine:YES];
    } else if (indexPath.row == 1) {
        [cell.imageView setImage:[UIImage imageNamed:@"login_password"]];
        [cell.textField setPlaceholder:@"请输入密码"];
        cell.textField.secureTextEntry = YES;
        self.passwordTextField = cell.textField;
        [cell setBottomLine:NO];
    }
    [cell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
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
