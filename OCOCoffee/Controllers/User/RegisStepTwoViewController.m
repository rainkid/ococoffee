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


static const CGFloat kPhotoHeight = 82;

@interface RegisStepTwoViewController ()<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate, DatePickerViewDelegate, StringPickerViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic, assign) long cellIndex;
@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) DatePickerView *datePicker;
@property(nonatomic,strong) StringPickerView *pickerView;
@property(nonatomic, strong) NSArray *pickerViewData;
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UIImageView *cameraView;

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

    _pickerViewData=[[NSArray alloc] initWithObjects:
                     @"金融行业",
                    @"IT行业",
                    @"互联行业",
                    @"投资行业",
                    @"手机游戏开发",
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

    //photo
    UIView *cview = [UIView new];
    long kPhotoSlide = 8;
    long kCPhotoHeight =kPhotoHeight+kPhotoSlide;
    cview.layer.cornerRadius = kCPhotoHeight/2;
    cview.layer.masksToBounds = YES;
    cview.layer.borderWidth = 1.0f;
    cview.layer.borderColor = [UIColor whiteColor].CGColor;
    cview.alpha = 0.9;
    [self.view addSubview:cview];
    [cview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.height.and.width.mas_equalTo(kCPhotoHeight);
        make.top.mas_equalTo(PHONE_NAVIGATIONBAR_HEIGHT + 40);
    }];
    
    //phone inner
    _imageView = [UIImageView new];
    _imageView.image = [UIImage imageNamed:@"regis_no_img"];
    _imageView.layer.cornerRadius = (kPhotoHeight) /2;
    _imageView.layer.masksToBounds = YES;
    _imageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUserImage:)];
    [singleTap setNumberOfTouchesRequired:1];
    [singleTap setNumberOfTapsRequired:1];
    [_imageView addGestureRecognizer:singleTap];
    
    [self.view addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.mas_equalTo(cview.mas_top).offset(kPhotoSlide/2);
        make.height.and.width.mas_equalTo(kPhotoHeight);;
    }];
    
    //camera image view
    _cameraView = [UIImageView new];
    _cameraView.image = [UIImage imageNamed:@"regis_camera"];
    [self.view addSubview:_cameraView];
    [_cameraView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cview.mas_top).offset(60);
        make.centerX.mas_equalTo(cview).offset(30);
    }];
    
    //labels
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

   
    
    //table view
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
    
    //next button
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

#pragma mark 用户单击上传图像
- (void)tapUserImage:(UITapGestureRecognizer*)tap
{
    NSLog(@"click userImage...");
    [self openThePhotoAlbum];
}

#pragma mark 打开系统相册或照相机
- (void)openThePhotoAlbum
{
    //创建图片选取器对象
    UIImagePickerController * pickerViwController = [[UIImagePickerController alloc] init];
    /*
     图片来源
     UIImagePickerControllerSourceTypePhotoLibrary：表示显示所有的照片
     UIImagePickerControllerSourceTypeCamera：表示从摄像头选取照片
     UIImagePickerControllerSourceTypeSavedPhotosAlbum：表示仅仅从相册中选取照片。
     */
    pickerViwController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //允许用户编辑图片 (YES可以编辑，NO只能选择照片)
    pickerViwController.allowsEditing = YES;
    
    pickerViwController.delegate = self;
    [self presentViewController:pickerViwController animated:YES completion:nil];
}

#pragma mark 相册协议中方法，选中某张图片后调用方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //头像设置为选中的图片
    [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    _cameraView.hidden = YES;
    _imageView.image = image;
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
        [cell.label setText:@"呢      称"];
        [cell.textField setPlaceholder:@"请输入2-12位中英文字符"];
        cell.textField.tag = TWO_NICKNAKE;
        [cell showBottomLine:YES];
        [cell showCodeButton:NO];
    } else if (indexPath.row == 1) {
        [cell.label setText:@"性      别"];
        [cell.textField setPlaceholder:@"请选择性别"];
        cell.textField.tag = TWO_SEX;
        cell.textField.delegate = self;
        cell.textField.keyboardType = UIKeyboardTypeAlphabet;
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
