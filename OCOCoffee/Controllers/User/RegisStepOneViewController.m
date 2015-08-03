//
//  RegisterStepOneViewController.m
//  ococoffee
//
//  Created by sam on 15/7/28.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "Golbal.h"
#import "RegisTableViewCell.h"
#import "UIColor+colorBuild.h"
#import "RegisStepTwoViewController.h"
#import "RegisStepOneViewController.h"

static const CGFloat kLogoHeight = 104.f;
static const CGFloat kLogoWidth = 80.3f;
static const CGFloat kTableHeight = 142.5f;

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
    
    long logoLeft = (SCREEN_WIDTH - kLogoWidth) /2;
    UIImage *image = [UIImage imageNamed:@"login_logo.png"];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(logoLeft, PHONE_STATUSBAR_HEIGHT+38, kLogoWidth, kLogoHeight)];
    imageView.image = image;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imageView];

    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(kTableLeftSide, PHONE_STATUSBAR_HEIGHT + 181.6, SCREEN_WIDTH - (kTableLeftSide*2), self.view.bounds.size.height - kLogoHeight)];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, kTableHeight)];
    _tableView.layer.cornerRadius = 3;
    _tableView.layer.masksToBounds = YES;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.alpha = 0.7;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [view addSubview:_tableView];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    nextBtn.frame = CGRectMake(0, 187.1, view.frame.size.width, 46.4);
    nextBtn.backgroundColor = [UIColor colorFromHexString:@"#4a2320"];
    nextBtn.layer.cornerRadius = 3;
    nextBtn.layer.masksToBounds = YES;
    [nextBtn setTitle:@"下一步"  forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(registerTwoPage:) forControlEvents:UIControlEventTouchUpInside];

    [view addSubview:nextBtn];
    
    [self.view addSubview:view];
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
