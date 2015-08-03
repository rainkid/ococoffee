//
//  TestViewController.m
//  OCOCoffee
//
//  Created by sam on 15/8/3.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import "TestViewController.h"
#import "RegisStepOneViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    nextBtn.frame = CGRectMake(0, 235.8, self.view.frame.size
                               .width, 46.4);
    nextBtn.backgroundColor = [UIColor redColor];
    nextBtn.layer.cornerRadius = 3;
    nextBtn.layer.masksToBounds = YES;
    [nextBtn setTitle:@"测试"  forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(regisOne:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    
    

    // Do any additional setup after loading the view.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
