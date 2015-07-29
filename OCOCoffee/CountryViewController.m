//
//  CountryViewController.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/7/26.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import "CountryViewController.h"
#import "CityViewController.h"

@interface CountryViewController (){
    
    CityViewController *_cityViewController;
}

@end

@implementation CountryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择地区";
    
    _dataList = [[NSMutableArray alloc] initWithCapacity:0];
    _dataList = [self getDataList];

    UITableView *table = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    table.delegate= self;
    table.dataSource = self;
    table.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = leftButton;
    [self.view addSubview:table];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSMutableArray *)getDataList {
    NSString *filePath  = [[NSBundle mainBundle] pathForResource:@"area_code" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    return dict[@"list"];
    
}

-(void)cancel {
    
    [self dismissViewControllerAnimated:YES completion:^(void){
        NSLog(@"Return Back");
    }];
}

#pragma delegate methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSInteger row = [indexPath row];
    NSDictionary *temp  = _dataList[row];
    cell.textLabel.text = temp[@"province"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger row = [indexPath row];
    NSDictionary *provinceData = _dataList[row];
    
    _cityViewController = [[CityViewController alloc] init];
    _cityViewController.cityList = provinceData[@"cities"];
    _cityViewController.provinceName = provinceData[@"province"];
    
    [self.delegate showProvinceInfo];
    
    //UINavigationController *cityNavigationController = [[UINavigationController alloc] initWithRootViewController:_cityViewController];
    [self.navigationController pushViewController:_cityViewController animated:YES];
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
