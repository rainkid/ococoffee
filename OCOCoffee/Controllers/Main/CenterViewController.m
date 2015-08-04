//
//  CenterViewController.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/7/25.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import "CenterViewController.h"
#import "RegisStepOneViewController.h"

@interface CenterViewController (){
    
    UIView *_mainView;
}

@end

@implementation CenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的";
    _mainView = [[UIView alloc] initWithFrame:self.view.frame];
    _mainView.backgroundColor = [UIColor whiteColor];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    nextBtn.frame = CGRectMake(0, 235.8, self.view.frame.size
                               .width, 46.4);
    nextBtn.backgroundColor = [UIColor redColor];
    nextBtn.layer.cornerRadius = 3;
    nextBtn.layer.masksToBounds = YES;
    [nextBtn setTitle:@"测试"  forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(regisOne:) forControlEvents:UIControlEventTouchUpInside];
    [_mainView addSubview:nextBtn];
    
    
    [self.view addSubview:_mainView];
}

#pragma mark - nextBtn action
- (IBAction)regisOne:(id)sender {
    RegisStepOneViewController *one = [[RegisStepOneViewController alloc] init];
    [self presentViewController:one animated:YES completion:^{
        NSLog(@"a");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
