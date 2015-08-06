//
//  CenterViewController.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/7/25.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import "Golbal.h"
#import "UIColor+colorBuild.h"
#import "CenterViewController.h"
#import "RegisStepThreeViewController.h"
#import "RegisStepTwoViewController.h"
#import "RegisStepOneViewController.h"
#import "LoginViewController.h"
#import "CenterTableViewCell.h"
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
    
    UIImage *bg_image = [UIImage imageNamed:@"background.png"];
    UIImageView *bg_imageView = [[UIImageView alloc] initWithImage:bg_image];
    [bg_imageView setFrame:self.view.bounds];
    [self.view addSubview:bg_imageView];
    
    //photo
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
        make.top.mas_equalTo(PHONE_NAVIGATIONBAR_HEIGHT + 40);
    }];
    
    //phone inner
    _imageView = [UIImageView new];
    _imageView.image = [UIImage imageNamed:@"sample_logo"];
    _imageView.layer.cornerRadius = (kPhotoHeight) /2;
    _imageView.layer.masksToBounds = YES;    
    
    [self.view addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.mas_equalTo(photoView.mas_top).offset(kPhotoSlide/2);
        make.height.and.width.mas_equalTo(kPhotoHeight);;
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
//    botView.backgroundColor = [UIColor redColor];
    [self.view addSubview:botView];
    [botView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label_2.mas_bottom).offset(14/2);
        make.height.mas_equalTo(PHONE_CONTENT_HEIGHT);
        make.left.right.mas_equalTo(weakSelf.view);
    }];
    
    //bot view
    UIView *centerView = [UIView new];
    [self.view addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.width.mas_equalTo(weakSelf.view);
        make.top.mas_equalTo(label_2.mas_bottom).offset(14/2);
    }];
    
    int padding = 1;
    //notice view
    UIView *noticeView = [UIImageView new];
    noticeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:noticeView];
    [noticeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(centerView.mas_top);
        make.centerY.mas_equalTo(centerView);
        make.left.equalTo(centerView.mas_left);
        make.right.equalTo(noticeView.mas_left).with.offset(-padding);
        make.height.mas_equalTo(80.2);
        make.width.equalTo(noticeView);
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
        make.top.mas_equalTo(centerView.mas_top);
        make.centerY.mas_equalTo(centerView.mas_centerY);
        make.left.equalTo(noticeView.mas_right).with.offset(padding);
        make.right.equalTo(centerView.mas_right);
        make.height.mas_equalTo(80.2);
        make.width.equalTo(noticeView);
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
    
    
<<<<<<< HEAD
    
    //
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loginBtn.backgroundColor = [UIColor redColor];
    [loginBtn setTitle:@"登录页"  forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
=======
//    //
//    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    loginBtn.backgroundColor = [UIColor redColor];
//    [loginBtn setTitle:@"登录页"  forState:UIControlStateNormal];
//    [loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:loginBtn];
//    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(100);
//        make.centerX.equalTo(self.view);
//        make.height.mas_equalTo(40);
//    }];
//    
//   
//    //
//    UIButton *oneBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//     [oneBtn setTitle:@"注册页1"  forState:UIControlStateNormal];
//    oneBtn.backgroundColor = [UIColor greenColor];
//    [oneBtn addTarget:self action:@selector(regisOne:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:oneBtn];
//    [oneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(loginBtn.mas_bottom);
//        make.centerX.equalTo(self.view);
//        make.centerX.equalTo(self.view);
//
//        make.height.mas_equalTo(40);
//    }];
//    //
//    UIButton *twoBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [twoBtn setTitle:@"注册页2"  forState:UIControlStateNormal];
//    [twoBtn addTarget:self action:@selector(regisTwo:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:twoBtn];
//    [twoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(oneBtn.mas_bottom);
//        make.centerX.equalTo(self.view);
//
//        make.height.mas_equalTo(40);
//    }];
//    //
//    UIButton *threeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [threeBtn setTitle:@"注册页3"  forState:UIControlStateNormal];
//    [threeBtn addTarget:self action:@selector(regisThree:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:threeBtn];
//    [threeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(twoBtn.mas_bottom);
//        make.centerX.equalTo(self.view);
//
//        make.height.mas_equalTo(40);
//    }];
>>>>>>> 25d14744ee1dc2a505ea6bd19bcfbdcacb29f55f
    
   
    //
    UIButton *oneBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
     [oneBtn setTitle:@"注册页1"  forState:UIControlStateNormal];
    oneBtn.backgroundColor = [UIColor greenColor];
    [oneBtn addTarget:self action:@selector(regisOne:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:oneBtn];
    [oneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginBtn.mas_bottom);
        make.centerX.equalTo(self.view);
        make.centerX.equalTo(self.view);

        make.height.mas_equalTo(40);
    }];
    //
    UIButton *twoBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [twoBtn setTitle:@"注册页2"  forState:UIControlStateNormal];
    [twoBtn addTarget:self action:@selector(regisTwo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:twoBtn];
    [twoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oneBtn.mas_bottom);
        make.centerX.equalTo(self.view);

        make.height.mas_equalTo(40);
    }];
    //
    UIButton *threeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [threeBtn setTitle:@"注册页3"  forState:UIControlStateNormal];
    [threeBtn addTarget:self action:@selector(regisThree:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:threeBtn];
    [threeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(twoBtn.mas_bottom);
        make.centerX.equalTo(self.view);

        make.height.mas_equalTo(40);
    }];

    [self.view addSubview:_mainView];
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
            case 0:
            {
                [cell.limageView setImage:[UIImage imageNamed:@"center_01"]];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.label.text = @"我的活动";
            }
            break;
                
            case 1:
            {
                [cell.limageView setImage:[UIImage imageNamed:@"center_01"]];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.label.text = @"我的好友";

            }
            break;
        }
        
    }else if (section == 1){
        switch (row) {
            case 0:
            {
                [cell.limageView setImage:[UIImage imageNamed:@"center_01"]];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.label.text = @"设置";
            }
                break;
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
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return 1;
    } else {
        return 0;
    }
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


#pragma mark - nextBtn action
- (IBAction)regisThree:(id)sender {
    RegisStepThreeViewController *one = [[RegisStepThreeViewController alloc] init];
    [self presentViewController:one animated:YES completion:^{
        NSLog(@"a");
    }];
}

- (IBAction)regisOne:(id)sender {
    RegisStepOneViewController *one = [[RegisStepOneViewController alloc] init];
    [self presentViewController:one animated:YES completion:^{
        NSLog(@"a");
    }];
}


- (IBAction)login:(id)sender {
    LoginViewController *one = [[LoginViewController alloc] init];
    [self presentViewController:one animated:YES completion:^{
        NSLog(@"a");
    }];
}

- (IBAction)regisTwo:(id)sender {
    RegisStepTwoViewController *one = [[RegisStepTwoViewController alloc] init];
    [self presentViewController:one animated:YES completion:^{
        NSLog(@"a");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
