//
//  CityViewController.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/7/26.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import "CityViewController.h"
#import "SearchViewController.h"

@interface CityViewController ()

@end

@implementation CityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
    
    self.view.backgroundColor = [UIColor clearColor];
//    UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:self];
//    naviController.view.frame = self.view.frame;
//    
//    [self.view addSubview:naviController.view];
    
    UITableView *_citytableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _citytableView.backgroundColor = [UIColor whiteColor];
    _citytableView.delegate = self;
    _citytableView.dataSource = self;
    
    [self.view addSubview:_citytableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma delegate methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_cityList count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *indentifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    cell.textLabel.text = _cityList[indexPath.row][@"city"];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *city = _cityList[indexPath.row][@"city"];
    NSLog(@"%@-%@",_provinceName,city);
    if([self.delegate respondsToSelector:@selector(showDiscinct:withCity:)]){
         [self.delegate showDiscinct:_provinceName withCity:city];
    }
   
    
    [self dismissViewControllerAnimated:YES completion:^(void){}];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
