//
//  MessageViewController.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/7/25.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import "MessageViewController.h"
#import <CFNetwork/CFNetwork.h>

@interface MessageViewController (){
    
    UIView *_mainView;
}

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    
    _mainView = [[UIView alloc] initWithFrame:self.view.frame];
    _mainView.backgroundColor  = [UIColor whiteColor];
    [self.view addSubview:_mainView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
