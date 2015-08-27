//
//  RegisterStepOneViewController.m
//  ococoffee
//
//  Created by sam on 15/7/28.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "Global.h"
#import "Common.h"
#import <Masonry/Masonry.h>
#import <AFNetworking/AFNetworking.h>
#import "RegisTableViewCell.h"
#import "UIColor+colorBuild.h"
#import "RegisStepTwoViewController.h"
#import "RegisStepOneViewController.h"

@interface RegisStepOneViewController()<UITableViewDataSource, UITableViewDelegate, UINavigationBarDelegate>

@property(nonatomic, strong) UITextField *phoneTextField;
@property(nonatomic, strong) UITextField *codeTextField;
@property(nonatomic, strong) UITextField *passwordTextFeild;

@property(nonatomic, strong) UIButton *nextButton;
@property(nonatomic, strong) UIButton *smsButton;

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, assign) int timeSecond;
@property(nonatomic, strong) NSTimer *smsTimer;
@end

@implementation RegisStepOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSubViews];
}


- (void) addSubViews {
    
    __weak typeof(self) weakSelf = self;

    UIImage *bg_image = [UIImage imageNamed:@"background"];
    UIImageView *bg_imageView = [[UIImageView alloc] initWithImage:bg_image];
    [bg_imageView setFrame:self.view.bounds];
    [self.view addSubview: bg_imageView];
    
    //logo
    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"login_logo.png"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(PHONE_NAVIGATIONBAR_HEIGHT + 40);
        make.centerX.equalTo(self.view);
    }];

    //tableview
    self.tableView = ({
        UITableView *tableView = [UITableView new];
        tableView.layer.cornerRadius = 3;
        tableView.layer.masksToBounds = YES;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.alpha = 0.7;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.showsHorizontalScrollIndicator = NO;
        tableView;
    });
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageView.mas_bottom).offset(41);
        make.centerX.equalTo(weakSelf.view);
        make.height.mas_equalTo(kCellHeight * 3);
        make.left.equalTo(self.view).offset(kTableLeftSide);
    }];
    
    //nextBtn
    self.nextButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.backgroundColor = [UIColor colorFromHexString:@"#4a2320"];
        button.layer.cornerRadius = 3;
        button.layer.masksToBounds = YES;
        button.enabled = NO;
        [button setTitle:@"下一步"  forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(registerTwoPage:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.view addSubview:self.nextButton];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.height.mas_equalTo(kButtonHeight);
        make.left.and.right.equalTo(_tableView);
        make.top.equalTo(_tableView.mas_bottom).offset(47.5);
    }];
    
}

// login_post
- (IBAction)loginPost:(id)sender {
    NSString *phone = self.phoneTextField.text;
    NSString *code = self.codeTextField.text;
    NSString *password = self.passwordTextFeild.text;
    
    NSString *listApiUrl = API_DOMAIN@"api/user/register_step1";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"phone":phone, @"password":password, @"code":code};
    
    [manager POST:listApiUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"%@", responseObject);
        [self analyseResponse:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(void)analyseResponse:(NSDictionary *)jsonObject
{
    if ([jsonObject isKindOfClass:[NSDictionary class]]) {
        if ([jsonObject[@"success"] integerValue] == 1) {
            
        } else {
            [Common showErrorDialog:jsonObject[@"msg"]];
        }
    } else {
        NSLog(@"response error");
    }
}

#pragma mark send sms code
- (IBAction)sendSmsCode:(id)sender {
    NSString *phone = self.phoneTextField.text;
    
    NSString *listApiUrl = API_DOMAIN@"api/user/sms_post";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"phone":phone};
    
    [manager POST:listApiUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"%@", responseObject);
        [self analyseCodeResponse:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


-(void)analyseCodeResponse:(NSDictionary *)jsonObject
{
    if ([jsonObject isKindOfClass:[NSDictionary class]]) {
        if ([jsonObject[@"success"] integerValue] == 1) {
            [self startTimer];
        } else {
            [Common showErrorDialog:jsonObject[@"msg"]];
        }
    } else {
        NSLog(@"response error");
    }
}

#pragma mark - sms send start timer
-(void)startTimer
{
    self.timeSecond = 60;
    self.smsTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
}

-(void)timeFireMethod
{
    self.timeSecond--;
    //
    self.smsButton.enabled = NO;
    [self.smsButton setTitle:[NSString stringWithFormat:@"%d s", self.timeSecond] forState:UIControlStateNormal];
    NSLog(@"----%d", self.timeSecond);
    if(self.timeSecond==0){
        [self.smsTimer invalidate];
        //
    }
}

#pragma mark textFielDidChange
-(IBAction)textFieldDidChange:(id)sender {
    NSString *phone = self.phoneTextField.text;
    NSString *code = self.codeTextField.text;
    NSString *password = self.passwordTextFeild.text;
    
    if ([phone length] != 11) {
        self.smsButton.enabled = NO;
    } else {
        NSLog(@"%ld", [phone length]);
        self.smsButton.enabled = YES;
        self.smsButton.layer.borderColor = [UIColor colorFromHexString:@"#4a2320"].CGColor;
        [self.smsButton setTitleColor:[UIColor colorFromHexString:@"#4a2320"] forState:UIControlStateNormal];
    }
    
    if ([password length] == 0 || [code length] ==0 || [phone length] == 0) {
        self.nextButton.enabled = NO;
    } else {
        self.nextButton.enabled = YES;
        [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

#pragma mark - nextButton action
- (IBAction)registerTwoPage:(id)sender {
    RegisStepTwoViewController *page = [[RegisStepTwoViewController alloc] init];
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

#pragma mark -TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RegisTableViewCell *cell=[[RegisTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0){
        [cell.label setText:@"用户名"];
        [cell.textField setPlaceholder:@"请输入手机号码"];
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        cell.textField.tag = ONE_USERNAME;
        self.phoneTextField = cell.textField;
        [cell showBottomLine:YES];

    } else if (indexPath.row == 1) {
        [cell.label setText:@"验证码"];
        [cell.textField setPlaceholder:@"请输入验证码"];
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        cell.textField.tag = ONE_CODE;
        self.codeTextField = cell.textField;
        
        UIButton *button =  [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(0, 0, kSmsButtonWidth, 32);
        [button setTitle:@"发送验证码" forState:UIControlStateNormal];
        [[button layer] setBorderWidth:1.0f];
        button.enabled = NO;
        [[button layer] setBorderColor:[UIColor grayColor].CGColor];
        button.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        [button addTarget:self action:@selector(sendSmsCode:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 3;
        button.layer.masksToBounds = YES;
        cell.accessoryView = button;
        self.smsButton = button;
        
        [cell.textField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-kSmsButtonWidth-20);
        }];

        [cell showBottomLine:YES];
    } else if (indexPath.row == 2) {
        [cell.label setText:@"密   码"];
        [cell.label sizeToFit];
        [cell.textField setPlaceholder:@"请设置6位或6位以上密码"];
        cell.textField.tag = ONE_PASSWORD;
        cell.textField.secureTextEntry = YES;
        self.passwordTextFeild = cell.textField;
        [cell showBottomLine:NO];
    }
    [cell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
