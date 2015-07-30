//
//  RegisStepTwoViewController.m
//  ococoffee
//
//  Created by sam on 15/7/28.
//  Copyright (c) 2015年 sam. All rights reserved.
//


#import "Golbal.h"
#import "UIColor+colorBuild.h"
#import "RegisTableViewCell.h"
#import "ActionSheetPicker.h"
#import "RegisStepTwoViewController.h"


@interface RegisStepTwoViewController ()<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *arrOfAge;

@property(nonatomic,strong) NSIndexPath *selectedIndexPath;

@end


@implementation RegisStepTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addSubViews];
    [self initPickerView];
}

- (void) initPickerView {
    _arrOfAge = [[NSArray alloc]initWithObjects:@"one",@"two", nil];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    self.pickerView = [[UIPickerView alloc]  initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, self.view.frame.size.height)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) addSubViews {
    UIImage *bg_image = [UIImage imageNamed:@"background.png"];
    UIImageView *bg_imageView = [[UIImageView alloc] initWithImage:bg_image];
    [bg_imageView setFrame:self.view.bounds];
    
    [self.view addSubview: bg_imageView];
    
    long logoWith = 109.1;
    long logoHeight = 109.1;
    long logoLeft = (SCREEN_WIDTH - logoWith) /2;
    
    UIView *cview = [[UIView alloc] initWithFrame:CGRectMake(logoLeft, PHONE_NAVIGATIONBAR_HEIGHT+38, logoWith, logoHeight)];
    cview.layer.cornerRadius = logoHeight/2;
    cview.layer.masksToBounds = YES;
    cview.layer.borderWidth = 3.0f;
    cview.layer.borderColor = [UIColor colorFromHexString:@"#f8f7f9"].CGColor;
    cview.alpha = 0.5;
    [self.view addSubview:cview];
    
    long imgWidth =logoWith-10;
    long imgHeight = logoHeight - 10;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(logoLeft+5, PHONE_NAVIGATIONBAR_HEIGHT+43,imgWidth, imgHeight)];
    imageView.image = [UIImage imageNamed:@"regis_no_img"];
    imageView.layer.cornerRadius = imgHeight/2;
    imageView.layer.masksToBounds = YES;
    cview.backgroundColor = [UIColor colorFromHexString:@"#c39258"];
    
    [self.view addSubview:imageView];
    
    UIImageView *cameraImageView = [[UIImageView alloc] initWithFrame:CGRectMake(logoLeft+80, PHONE_NAVIGATIONBAR_HEIGHT+43+75,  22.3, 19.3)];
    cameraImageView.image = [UIImage imageNamed:@"regis_camera"];
    [self.view addSubview:cameraImageView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(kTableLeftSide, PHONE_NAVIGATIONBAR_HEIGHT + 181.6, SCREEN_WIDTH - (kTableLeftSide*2), self.view.bounds.size.height - logoHeight)];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, 189.9)];
    
    _tableView.layer.cornerRadius = 3;
    _tableView.layer.masksToBounds = YES;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.alpha = 0.7;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [view addSubview:_tableView];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loginBtn.frame = CGRectMake(0, 235.8, view.frame.size
                                .width, 46.4);
    loginBtn.backgroundColor = [UIColor colorFromHexString:@"#4a2320"];
    loginBtn.layer.cornerRadius = 3;
    loginBtn.layer.masksToBounds = YES;
    [loginBtn setTitle:@"下一步"  forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [view addSubview:loginBtn];
    
    [self.view addSubview:view];
}

#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RegisTableViewCell *cell=[[RegisTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    if (indexPath.row == 0){
        [cell.label setText:@"呢    称"];
        [cell.textField setPlaceholder:@"请输入2-12位中英文字符"];
        cell.textField.delegate = self;
        cell.textField.tag = TWO_NICKNAKE;
        [cell showBottomLine:YES];
        [cell showCodeButton:NO];
    } else if (indexPath.row == 1) {
        [cell.label setText:@"性    别"];
        [cell.textField setPlaceholder:@"请选择性别"];
        cell.textField.tag = TWO_SEX;
        cell.textField.delegate = self;
        [cell showBottomLine:YES];
        [cell showCodeButton:NO];

    } else if (indexPath.row == 2) {
        [cell.label setText:@"出生日期"];
        [cell.textField setPlaceholder:@"请选择出生日期"];
        cell.textField.tag = TWO_BIRGHDAY;
        cell.textField.delegate = self;
        cell.textField.inputAccessoryView = self.pickerView;
        cell.textField.secureTextEntry = YES;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell showBottomLine:YES];
        [cell showCodeButton:NO];
    } else if (indexPath.row == 3) {
        [cell.label setText:@"所在行业"];
        [cell.textField setPlaceholder:@"请选择所在行业"];
        cell.textField.tag = TWO_TRADE;
        cell.textField.delegate = self;
        cell.textField.secureTextEntry = YES;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell showBottomLine:NO];
        [cell showCodeButton:NO];
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    _selectedIndexPath = indexPath;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

#pragma <#arguments#>
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_arrOfAge count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *titleRow;
    titleRow = [NSString stringWithFormat:@"%@", [_arrOfAge objectAtIndex:row]];
    return titleRow;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"%ld", row);
}

#pragma mark-textField
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"controller %ld", textField.tag);
    if (textField.tag == TWO_TRADE) {
        
    }
    return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    
        NSLog(@"controller %ld", textField.tag);
    if(![textField isFirstResponder]){
        [textField resignFirstResponder];
        [textField becomeFirstResponder];
        
    }
    
    NSLog(@"Begin Editing");
}

-(void) textFieldDidEndEditing: (UITextField * ) textField {
    NSLog(@"controller %ld", textField.tag);
    
    if([textField isFirstResponder]){
       // [textField ]
    }
    
}

@end
