//
//  ViewController.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/7/23.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self viewInitlize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




//初始化视图
-(void)viewInitlize {

    UIView *_subView = [[UIView alloc] initWithFrame:self.view.frame];
    _subView.backgroundColor = [UIColor whiteColor];
    self.title = @"一杯咖啡";
    [self.view addSubview:_subView];
    
    
    
}

@end
