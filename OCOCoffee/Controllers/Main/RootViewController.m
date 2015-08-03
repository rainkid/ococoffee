//
//  RootViewController.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/7/25.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import "RootViewController.h"
#import "ViewController.h"
#import "SearchViewController.h"

@interface RootViewController (){
    
    UINavigationController *_rootNavigationController;
    ViewController *_viewController;
}

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(_viewController == nil){
        _viewController = [[ViewController alloc] init];
    }
    
   /// _viewController = [[ViewController alloc] init];
    
    if(_rootNavigationController == nil){
        _rootNavigationController = [[UINavigationController alloc] initWithRootViewController:_viewController];
        _rootNavigationController.view.frame = self.view.frame;
        _rootNavigationController.view.backgroundColor = [UIColor clearColor];
    }
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"筛选"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(search)
                                      ];
    _viewController.navigationItem.leftBarButtonItem = leftBarButton;
    
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"设置"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(settings)
                                    ];
    _viewController.navigationItem.rightBarButtonItem = rightButton;
    
    [self.view addSubview:_rootNavigationController.view];
}

-(void)search {
    
    SearchViewController *searchViewController = [[SearchViewController alloc] init];
   UINavigationController *searchNavigationController = [[UINavigationController alloc] initWithRootViewController:searchViewController];

    [self presentViewController:searchNavigationController animated:YES completion:^(void){
        NSLog(@"sessued");
    }];
}

-(void)settings {
    
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
