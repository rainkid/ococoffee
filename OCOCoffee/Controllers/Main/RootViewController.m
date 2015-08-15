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
#import "IndexViewController.h"
#import "IndexView.h"
#import "IndexNavigationController.h"

@interface RootViewController (){
    
    UINavigationController *_rootNavigationController;
    ViewController *_viewController;
    
    IndexViewController *_indexViewController;

}

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(_indexViewController == nil){
        _indexViewController = [[IndexViewController alloc] init];
    }
    
    if(_rootNavigationController == nil){
        _rootNavigationController = [[UINavigationController alloc] initWithRootViewController:_indexViewController];
        _rootNavigationController.view.frame = self.view.frame;
        _rootNavigationController.view.backgroundColor = [UIColor whiteColor];
    }
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"筛选"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(search)
                                      ];
    _indexViewController.navigationItem.leftBarButtonItem = leftBarButton;
    
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"设置"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(settings)
                                    ];
    _indexViewController.navigationItem.rightBarButtonItem = rightButton;
    
    self.navigationController.navigationBar.barTintColor= [UIColor blueColor];
    
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
