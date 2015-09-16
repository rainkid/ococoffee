//
//  SearchViewController.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/7/25.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//
#define PICKERLEFTBUTTONTAG        1
#define PICKERRIGHTBUTTONTAG       2

#define kprovinceConponent          0
#define kcityConpenent              1

#define kfirstSection               0
#define ksecondSection              1

#import "SearchViewController.h"
#import "CountryViewController.h"
#import "ViewStyles.h"

@interface SearchViewController (){
    
    UINavigationController  *_searchNavicationController;
    SearchViewController    *_searchViewController;
    CountryViewController   *_countryViewController;
    UIPickerView *_pickerView;
    UITableView *_tableView;
    UIView *_subView;
    UIView *_view2;
    NSMutableArray *_provinceList;
    NSArray *_cityList;
    NSString *_province;
    NSString *_city;
    NSIndexPath *_selectedIndexPath;
    
}

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"筛选";
    
    [ViewStyles setNaviControllerStyle:self.navigationController];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    topView.backgroundColor =[UIColor lightGrayColor];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                   style:UIBarButtonItemStylePlain                                                                     target:self
                                                                      action:@selector(cancel)
                                   ];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(search)
                                    ];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    _subView = [[UIView alloc] initWithFrame:self.view.frame];
    _subView.backgroundColor = [UIColor lightGrayColor];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_subView addSubview:_tableView];
    [self.view addSubview:_subView];
    
    _view2 = [[UIView alloc] initWithFrame:CGRectMake(0,  self.view.frame.size.height, self.view.frame.size.width,260)];
    _view2.backgroundColor = [UIColor whiteColor];
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(8, 5, 50, 23)];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn setTag:PICKERLEFTBUTTONTAG];
    [leftBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(hidePickerView:) forControlEvents:UIControlEventTouchUpInside];
    [_view2 addSubview:leftBtn];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 58, 5, 50, 23)];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightBtn setTag:PICKERRIGHTBUTTONTAG];
    [rightBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(hidePickerView:) forControlEvents:UIControlEventTouchUpInside];
    [_view2 addSubview:rightBtn];
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 240)];
    _pickerView.delegate = self;
    _pickerView.dataSource  = self;
    _pickerView.tag = 10;
    [_view2 addSubview:_pickerView];
    [self.view addSubview:_view2];
    
    _provinceList = [self getProvinceDataList];
    
}

-(NSMutableArray *)getProvinceDataList {
    if(_provinceList == nil){
        _countryViewController = [[CountryViewController alloc] init];
        _provinceList = [[NSMutableArray alloc] initWithCapacity:0];
        _provinceList = [_countryViewController getDataList];
    }
    return _provinceList;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)cancel {
    NSLog(@"Cancel");
    [self.navigationController dismissViewControllerAnimated:YES completion:^(void){
        NSLog(@"返回成功");
    }];
}


-(void)search {
    NSLog(@"Search");
}

-(void)switchChanged:(NSInteger)value{
    
}


-(void)segmentedValueChanged:(UISegmentedControl *)segmentedControl{
    NSInteger index = segmentedControl.selectedSegmentIndex;
    NSString *message ;
    message = [[NSString alloc] initWithString:[NSString stringWithFormat:@"You have selected index %ld",(long)index]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK", nil
                          ];
    [alert show];
}

-(void)sexSegmentValueChange:(UISegmentedControl *)segmentedControl{
    NSInteger index = segmentedControl.selectedSegmentIndex;
    NSLog(@"%ld",(long)index);
}


#pragma tableview delegate methods

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *searchType1 = @[@"排序",@"性别",@"地区",@"视频认证"];
    NSArray *searchType2 = @[@"年龄",@"身高",@"满意部位"];
    
    static NSString *cellidentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellidentifier];
    }
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    if(section == kfirstSection){
        cell.textLabel.text = searchType1[row];
        cell.textLabel.textColor  = [UIColor lightGrayColor];
        switch (row) {
            case 0:{
                    UISegmentedControl *sortSegmentedController = [[UISegmentedControl alloc] initWithItems:@[@"最近活跃",@"离我最近"]];
                    sortSegmentedController.selectedSegmentIndex = 0;
                    [sortSegmentedController setFrame:CGRectMake(100, 10, 150, 30)];
                    [sortSegmentedController addTarget:self action:@selector(segmentedValueChanged:) forControlEvents:UIControlEventValueChanged];
                    cell.accessoryView = sortSegmentedController;
                }
                break;
                
            case 1:{
                UISegmentedControl *sexSegmentedController = [[UISegmentedControl alloc] initWithItems:@[@"全部",@"男",@"女"]];
                sexSegmentedController.selectedSegmentIndex = 0;
                sexSegmentedController.frame = CGRectMake(150, 0, 130, 30);
                sexSegmentedController.tintColor  = [UIColor redColor];
                [sexSegmentedController addTarget:self action:@selector(sexSegmentValueChange:) forControlEvents:UIControlEventValueChanged];
                cell.accessoryView = sexSegmentedController;
                
            }
                break;
            case 2:{
                cell.detailTextLabel.text = @"广东 深圳 ";
                cell.detailTextLabel.textAlignment = NSTextAlignmentCenter;
                cell.detailTextLabel.textColor = [UIColor lightGrayColor];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
            default:{
                UISwitch *videoSwitch  = [[UISwitch alloc] init];
                [videoSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
                cell.accessoryView = videoSwitch;
            }
                break;
        }
        
    }else if (section == ksecondSection){
        cell.textLabel.text = searchType2[[indexPath row]];
        cell.textLabel.textColor  = [UIColor lightGrayColor];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.detailTextLabel.text = @"不限";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSString *tagString = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%ld%ld",(long)section,(long)row]];
    NSInteger tagValue = [tagString intValue];
    cell.tag = tagValue;
    return cell;
}

#pragma tableview datasource method

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == kfirstSection){
        return 4;
    }
    return 3;
}


#pragma tableview delegate method

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title;
    if(section == ksecondSection){
        title = @"高级筛选";
    }
    return title;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0.0;
    if(section == kfirstSection){
        height = 6.0;
    }
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section  = [indexPath section];
    NSInteger index    = [indexPath row];
    _selectedIndexPath = indexPath;
    switch (section) {
        case kfirstSection: {
            if(index == 2){
                [self showPickerView];
            }else if(index == 3){}
        }
        break;
            
        default:{
            
        }
        break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma pickerView delegate mathods
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(component == kprovinceConponent){
        return [_provinceList count];
    }
    NSInteger num = 1;
    if([_cityList count] > 0){
        num = [_cityList count];
    }
    return num;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{

    if(component == kprovinceConponent){
         return _provinceList[row][@"province"];
    }else{
        return _cityList[row][@"city"]?_cityList[row][@"city"]:_provinceList[row][@"capital"];
    }
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(component == kprovinceConponent) {
        NSDictionary *dict = [_provinceList objectAtIndex:row];
        _cityList = dict[@"cities"];
        NSInteger selectedIndex = [_pickerView selectedRowInComponent:kcityConpenent];
        NSDictionary *selectedCity = [_cityList objectAtIndex:selectedIndex];
        _province = dict[@"province"];
        _city     = selectedCity[@"city"];
        [_pickerView selectRow:0 inComponent:kcityConpenent animated:YES];
        [_pickerView reloadComponent:kcityConpenent];
    }else{
        NSDictionary *cityInfo = _cityList[row];
        _city = cityInfo[@"city"];
        [_pickerView reloadComponent:kprovinceConponent];
    }
}

-(void)showPickerView {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
   // [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    [self.view bringSubviewToFront:_view2];
    [_pickerView selectedRowInComponent:0];
    _subView.alpha = 0.7;
    _view2.frame = CGRectMake(0, 430, self.view.frame.size.width, self.view.frame.size.height - 430);
    _subView.userInteractionEnabled  = NO;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinished)];
    [UIView commitAnimations];
}


-(void)hidePickerView:(UIButton *)button {
    NSInteger tagValue = button.tag;
    NSLog(@"%ld",(long)tagValue);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    _subView.alpha = 1.0;
    _subView.userInteractionEnabled = YES;
    _view2.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 260);
    if(tagValue == PICKERRIGHTBUTTONTAG){
        [UIView setAnimationDidStopSelector:@selector(getAreaData)];
    }
   
    [UIView commitAnimations];
    
}

-(void)getAreaData {
    UITableViewCell *selectedCell = [_tableView cellForRowAtIndexPath:_selectedIndexPath];
    selectedCell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",_province,_city];
}

-(void) animationFinished {
    NSLog(@"完成");
}

-(void)showProvinceInfo{
    NSLog(@"OK!");
}

@end
