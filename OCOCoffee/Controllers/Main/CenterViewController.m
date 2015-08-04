//
//  CenterViewController.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/7/25.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import "CenterViewController.h"
#import "RegisStepThreeViewController.h"
#import "RegisStepTwoViewController.h"
#import "RegisStepOneViewController.h"
#import "LoginViewController.h"
#import <Masonry/Masonry.h>

@interface CenterViewController (){
    
    UIView *_mainView;
}

@end

@implementation CenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
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
    
//    [self.view addSubview:_mainView];
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
