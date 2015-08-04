//
//  RegisStepTwoViewController.m
//  ococoffee
//
//  Created by sam on 15/7/28.
//  Copyright (c) 2015年 sam. All rights reserved.
//


#import "Golbal.h"
#import <Masonry/Masonry.h>
#import "UIColor+colorBuild.h"
#import "RegisTableViewCell.h"
#import "ActionSheetPicker.h"
#import "StringPickerView.h"
#import "DatePickerView.h"
#import "RegisStepThreeViewController.h"
#import "RegisStepTwoViewController.h"


static const CGFloat kPhotoHeight = 109;

@interface RegisStepTwoViewController ()<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate, DatePickerViewDelegate, StringPickerViewDelegate>
@property(nonatomic, assign) long cellIndex;
@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) DatePickerView *datePicker;
@property(nonatomic,strong) StringPickerView *pickerView;
@property(nonatomic, strong) NSArray *pickerViewData;

@end


@implementation RegisStepTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addSubViews];
    [self initPickerView];
}

- (void) initPickerView {
    _datePicker = [[DatePickerView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 200)];
    _datePicker.delegate = self;
    
    _pickerView = [[StringPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    _pickerView.delegate = self;

    _pickerViewData=[[NSArray alloc] initWithObjects:@"哈哈",
                    @"two",
                    @"three",
                    @"four",
                    @"five",
                    nil];
    
    _pickerView.pickerViewData = _pickerViewData;
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
    
    
    __weak typeof(self) weakSelf = self;

    //
//    UIView *cview = [[UIView alloc] initWithFrame:CGRectMake(logoLeft, PHONE_NAVIGATIONBAR_HEIGHT+38, logoWith, logoHeight)];
    UIView *cview = [UIView new];
    cview.layer.cornerRadius = kPhotoHeight/2;
    cview.layer.masksToBounds = YES;
    cview.layer.borderWidth = 2.0f;
    cview.layer.borderColor = [UIColor whiteColor].CGColor;
    cview.alpha = 0.9;
    [self.view addSubview:cview];
    [cview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.height.and.width.mas_equalTo(kPhotoHeight);
        make.top.mas_equalTo(PHONE_NAVIGATIONBAR_HEIGHT + 40);
    }];
    

    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"regis_no_img"];
    imageView.layer.cornerRadius = (kPhotoHeight-4) /2;

    imageView.layer.masksToBounds = YES;
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.mas_equalTo(cview.mas_top).offset(2);
        make.height.and.width.mas_equalTo(kPhotoHeight - 4);;
    }];
    
    UILabel *label_1 = [UILabel new];
    label_1.text = @"请上传一张本人照片作为图像";
    label_1.font = [UIFont systemFontOfSize:14];
    label_1.textColor = [UIColor colorFromHexString:@"#939494"];
    [self.view addSubview:label_1];
    [label_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cview.mas_bottom).offset(8.3);
        make.centerX.equalTo(weakSelf.view);
    }];
    UILabel *label_2 = [UILabel new];
    label_2.text = @"图片大小不能大于5M";
    label_2.font = [UIFont systemFontOfSize:14];
    label_2.textColor = [UIColor colorFromHexString:@"#939494"];
    [self.view addSubview:label_2];
    [label_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label_1.mas_bottom).offset(2);
        make.centerX.equalTo(weakSelf.view);
    }];

    
    UIImageView *cameraImageView = [UIImageView new];//[[UIImageView alloc] initWithFrame:CGRectMake(logoLeft+80, PHONE_NAVIGATIONBAR_HEIGHT+43+75,  22.3, 19.3)];
    cameraImageView.image = [UIImage imageNamed:@"regis_camera"];
    [self.view addSubview:cameraImageView];
    [cameraImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cview.mas_top).offset(60);
        make.left.mas_equalTo(cview.mas_left).offset(82);
    }];
    
    
    _tableView = [UITableView new];
    _tableView.layer.cornerRadius = 3;
    _tableView.layer.masksToBounds = YES;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.alpha = 0.7;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kTableLeftSide);
        make.centerX.equalTo(weakSelf.view);
        make.height.mas_equalTo(kCellHeight * 4);
        make.top.mas_equalTo(label_2.mas_bottom).offset(26);
    }];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    nextBtn.backgroundColor = [UIColor colorFromHexString:@"#4a2320"];
    nextBtn.layer.cornerRadius = 3;
    nextBtn.layer.masksToBounds = YES;
    [nextBtn setTitle:@"下一步"  forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(registerThreePage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.height.mas_equalTo(kButtonHeight);
        make.left.and.right.equalTo(_tableView);
        make.top.equalTo(_tableView.mas_bottom).offset(47.5);
    }];
}

#pragma mark - nextBtn action
- (IBAction)registerThreePage:(id)sender {
    RegisStepThreeViewController *page = [[RegisStepThreeViewController alloc] init];
    [self presentViewController:page animated:YES completion:^{
        NSLog(@"regis page ");
    }];
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
    cell.textField.delegate = self;
    
    if (indexPath.row == 0){
        [cell.label setText:@"呢    称"];
        [cell.textField setPlaceholder:@"请输入2-12位中英文字符"];
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
        cell.textField.inputView = _datePicker;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell showBottomLine:YES];
        [cell showCodeButton:NO];
    } else if (indexPath.row == 3) {
        [cell.label setText:@"所在行业"];
        [cell.textField setPlaceholder:@"请选择所在行业"];
        cell.textField.tag = TWO_TRADE;
        cell.textField.inputView = _pickerView;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell showBottomLine:NO];
        [cell showCodeButton:NO];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
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
    self.cellIndex = textField.tag;
    [textField becomeFirstResponder];
    NSLog(@"cellIndex = %ld", self.cellIndex);
}

-(void) textFieldDidEndEditing: (UITextField * ) textField {
    NSLog(@"controller %ld", textField.tag);
}

#pragma DatePickerViewDelegate
-(void) datePickerDone:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:self.cellIndex inSection:0];
    RegisTableViewCell *cell = (RegisTableViewCell *)[_tableView cellForRowAtIndexPath:cellIndexPath];
    cell.textField.text = [formatter stringFromDate:date];
    [cell.textField resignFirstResponder];
    NSLog(@"%@", date);
}

-(void)datePickerCancel
{
    NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:self.cellIndex inSection:0];
    RegisTableViewCell *cell = (RegisTableViewCell *)[_tableView cellForRowAtIndexPath:cellIndexPath];
    [cell.textField resignFirstResponder];
}

#pragma StringPickerViewDelegate
-(void) stringPickerDone:(long)index
{
    NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:self.cellIndex inSection:0];
    RegisTableViewCell *cell = (RegisTableViewCell *)[_tableView cellForRowAtIndexPath:cellIndexPath];
    cell.textField.text = [_pickerViewData objectAtIndex:index];
    [cell.textField resignFirstResponder];
}

-(void)stringPickerCancel
{
    NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:self.cellIndex inSection:0];
    RegisTableViewCell *cell = (RegisTableViewCell *)[_tableView cellForRowAtIndexPath:cellIndexPath];
    [cell.textField resignFirstResponder];
}

@end
