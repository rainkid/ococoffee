//
//  RegisterStepOneViewController.m
//  ococoffee
//
//  Created by sam on 15/7/28.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "Golbal.h"
#import <Masonry/Masonry.h>
#import "RegisTableViewCell.h"
#import "UIColor+colorBuild.h"
#import "RegisStepTwoViewController.h"
#import "RegisStepOneViewController.h"

@interface RegisStepOneViewController()<UITableViewDataSource, UITableViewDelegate, UINavigationBarDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation RegisStepOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addSubViews];
}

- (void) addSubViews {
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

    //tableview
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
        make.height.mas_equalTo(kCellHeight * 3);
        make.left.equalTo(self.view).offset(kTableLeftSide);
    }];
    
    //nextBtn
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    nextBtn.backgroundColor = [UIColor colorFromHexString:@"#4a2320"];
    nextBtn.layer.cornerRadius = 3;
    nextBtn.layer.masksToBounds = YES;
    [nextBtn setTitle:@"下一步"  forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(registerTwoPage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.height.mas_equalTo(kButtonHeight);
        make.left.and.right.equalTo(_tableView);
        make.top.equalTo(_tableView.mas_bottom).offset(47.5);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - nextBtn action
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
        cell.textField.keyboardType = UIKeyboardTypePhonePad;
        cell.textField.tag = ONE_USERNAME;
        [cell showBottomLine:YES];
        [cell showCodeButton:NO];

    } else if (indexPath.row == 1) {
        [cell.label setText:@"验证码"];
        [cell.textField setPlaceholder:@"请输入验证码"];
        cell.textField.tag = ONE_CODE;
        [cell showBottomLine:YES];
        [cell showCodeButton:YES];

    } else if (indexPath.row == 2) {
        [cell.label setText:@"密    码"];
        [cell.textField setPlaceholder:@"请设置6位或6位以上密码"];
        cell.textField.tag = ONE_PASSWORD;
        cell.textField.secureTextEntry = YES;
        [cell showBottomLine:NO];
        [cell showCodeButton:NO];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld", indexPath.row);
}
@end
