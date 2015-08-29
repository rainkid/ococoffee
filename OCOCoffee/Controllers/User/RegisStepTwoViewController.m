//
//  RegisStepTwoViewController.m
//  ococoffee
//
//  Created by sam on 15/7/28.
//  Copyright (c) 2015年 sam. All rights reserved.
//


#import "Global.h"
#import "Common.h"
#import <Masonry/Masonry.h>
#import <AFNetworking/AFNetworking.h>
#import "UIColor+colorBuild.h"
#import "RegisTableViewCell.h"
#import "ActionSheetPicker.h"
#import "StringPickerViewItem.h"
#import "StringPickerView.h"
#import "DatePickerView.h"
#import "TagItem.h"
#import "RegisStepThreeViewController.h"
#import "RegisStepTwoViewController.h"


static const CGFloat kPhotoHeight = 82;

@interface RegisStepTwoViewController ()<UITableViewDataSource, UITableViewDelegate, DatePickerViewDelegate, StringPickerViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIActionSheetDelegate>

@property(nonatomic, strong) UITextField *nicknameTextField;
@property(nonatomic, strong) UITextField *birthdayTextField;
@property(nonatomic, strong) UITextField *jobTextField;
@property(nonatomic, strong) UISegmentedControl *sexSegmentedController;
@property(nonatomic, assign) long jobValue;
@property(nonatomic, assign) long sexValue;

@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) DatePickerView *datePicker;
@property(nonatomic,strong) StringPickerView *pickerView;

@property(nonatomic, strong) NSMutableArray *pickerViewData;
@property(nonatomic, strong) NSDictionary *sexData;
@property(nonatomic, strong) NSMutableArray *tagData;

@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UIImageView *cameraView;

@property(nonatomic, strong) UIButton *nextButton;
@property(nonatomic, strong) UIActionSheet *sheet;
@property(nonatomic, strong) NSString *filePath;
@end


@implementation RegisStepTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initSubViews];
    
    self.phone = @"13809886150";
    self.password = @"123456";
    
    self.pickerViewData = [NSMutableArray array];
    self.tagData = [NSMutableArray array];
    
    _datePicker = [[DatePickerView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, 200)];
    _datePicker.delegate = self;
    
    _pickerView = [[StringPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    _pickerView.delegate = self;

    
    [self loadDataFromServer];
}

#pragma mark-loadDataFromServer get user/attr
-(void)loadDataFromServer
{
    NSString *listApiUrl = API_DOMAIN@"api/user/attr";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:listApiUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        [self analyseAttrResponse:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(void)analyseAttrResponse:(NSDictionary *)jsonObject
{
    if ([jsonObject isKindOfClass:[NSDictionary class]]) {
        if ([jsonObject[@"success"] integerValue] == 1) {

            self.sexData =jsonObject[@"data"][@"sex"];
            NSArray *tagDicts = jsonObject[@"data"][@"tags"];
            for (NSDictionary *dict in tagDicts) {
                TagItem *item = [TagItem tagItemWithDictionary:dict];
                [self.tagData addObject:item];
            }
            
            //analyse job data
            NSDictionary *jobs = jsonObject[@"data"][@"job"];
            for (NSString *itemId in jobs) {
                StringPickerViewItem *item = [StringPickerViewItem new];
                item.itemId = [itemId floatValue];
                item.name = jobs[itemId];
                                
                [self.pickerViewData addObject:item];
                [self.pickerView loadData:self.pickerViewData];
            }
        } else {
            [Common showErrorDialog:jsonObject[@"msg"]];
        }
    } else {
        NSLog(@"response error");
    }
}

#pragma mark-initSubViews
- (void) initSubViews {
    __weak typeof(self) weakSelf = self;

    UIImage *bg_image = [UIImage imageNamed:@"background"];
    UIImageView *bg_imageView = [[UIImageView alloc] initWithImage:bg_image];
    [bg_imageView setFrame:self.view.bounds];
    [self.view addSubview: bg_imageView];
    
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
    
    //点击事件
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
    self.tableView = ({
        UITableView *tableView = [UITableView new];
        tableView.layer.cornerRadius = 3;
        tableView.layer.masksToBounds = YES;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.alpha = 0.7;
        tableView.scrollEnabled = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.showsHorizontalScrollIndicator = NO;
        tableView;
    });
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(kTableLeftSide);
        make.centerX.equalTo(weakSelf.view);
        make.height.mas_equalTo(kCellHeight * 4);
        make.top.mas_equalTo(label_2.mas_bottom).offset(26);
    }];
    
    //next button
    self.nextButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.backgroundColor = [UIColor colorFromHexString:@"#4a2320"];
        button.layer.cornerRadius = 3;
        button.layer.masksToBounds = YES;
        button.enabled = NO;
        [button setTitle:@"下一步"  forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(registerThreePage:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.view addSubview:self.nextButton];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.height.mas_equalTo(kButtonHeight);
        make.left.and.right.equalTo(_tableView);
        make.top.equalTo(_tableView.mas_bottom).offset(47.5);
    }];
}

#pragma mark-tag user image
- (void)tapUserImage:(UITapGestureRecognizer*)tap
{
    self.sheet  = [[UIActionSheet alloc]
                  initWithTitle:@"选择"
                  delegate:self
                  cancelButtonTitle:nil
                  destructiveButtonTitle:@"取消"
                  otherButtonTitles:@"拍照", @"从相册选择",nil];
    
    self.sheet.tag = 255;
    self.sheet.delegate = self;
    [self.sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%ld", buttonIndex);
    switch (buttonIndex)
    {
        case 0:
            break;
        case 1:
            [self takePhoto];
            break;
            
        case 2:
            [self openThePhotoAlbum];
            break;
    }
}

//开始拍照
-(void)takePhoto
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing = YES;
        picker.delegate = self;
        
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        [Common showErrorDialog:@"无法使用相机"];
    }
}

#pragma mark-optn photo album
- (void)openThePhotoAlbum
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.allowsEditing = YES;
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark-finish picking picture
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    _cameraView.hidden = YES;
    _imageView.image = image;
    
    //save image
    [self saveImage:image WithName:@"avatar.png"];
}

- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    
    self.filePath = fullPathToFile;
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
}

#pragma mark-nextBtn action
- (IBAction)registerThreePage:(id)sender {
    if ([self.filePath length] ==0) {
        [Common showErrorDialog:@"请上传图像"];
        return;
    }
    
    RegisStepThreeViewController *threePage = [[RegisStepThreeViewController alloc] init];
    
    threePage.nickname = self.nicknameTextField.text;
    threePage.phone = self.phone;
    threePage.password = self.password;
    threePage.sexValue = self.sexValue;
    threePage.jobValue = self.jobValue;
    threePage.birthday = self.birthdayTextField.text;
    threePage.tagData = self.tagData;
    threePage.headimgpath  = self.filePath;
    
    [self presentViewController:threePage animated:YES completion:nil];
}

#pragma mark-UITableViewDataSource UITableViewDelegate
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
        [cell.label setText:@"呢      称"];
        [cell.textField setPlaceholder:@"请输入2-12位中英文字符"];
        cell.textField.tag = TWO_NICKNAKE;
        self.nicknameTextField  =cell.textField;
        [cell showBottomLine:YES];
    } else if (indexPath.row == 1) {
        [cell.label setText:@"性      别"];
        cell.textField.hidden = YES;
        
        UISegmentedControl *sexSegmentedController = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"男",@"女",@"未知", nil]];
        sexSegmentedController.selectedSegmentIndex = 0;
        [sexSegmentedController addTarget:self action:nil forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = sexSegmentedController;
        self.sexSegmentedController = sexSegmentedController;
        [sexSegmentedController addTarget:self
                             action:@selector(sexDidChange:)
                   forControlEvents:UIControlEventValueChanged];
        
        [cell showBottomLine:YES];
    } else if (indexPath.row == 2) {
        [cell.label setText:@"出生日期"];
        [cell.textField setPlaceholder:@"请选择出生日期"];
        cell.textField.tag = TWO_BIRGHDAY;
        cell.textField.inputView = _datePicker;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.birthdayTextField = cell.textField;
        [cell showBottomLine:YES];
    } else if (indexPath.row == 3) {
        [cell.label setText:@"所在行业"];
        [cell.textField setPlaceholder:@"请选择所在行业"];
        cell.textField.tag = TWO_TRADE;
        cell.textField.inputView = _pickerView;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.jobTextField = cell.textField;
        [cell showBottomLine:NO];
    }
    [cell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}

-(void) checkFormValue
{
    NSString *nickname = self.nicknameTextField.text;
    NSString *birthday = self.birthdayTextField.text;
    NSLog(@"%@---%@", nickname, birthday);
    
    if ([nickname length] == 0 || [birthday length] ==0 || self.jobValue == 0) {
        self.nextButton.enabled = NO;
    } else {
        self.nextButton.enabled = YES;
        [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

#pragma mark-textFielDidChange
-(IBAction)textFieldDidChange:(id)sender {
    [self checkFormValue];
}

#pragma mark-UISegmentedControl didchange
-(IBAction)sexDidChange:(UISegmentedControl *)sender {
    NSInteger index = sender.selectedSegmentIndex;
    self.sexValue = index  + 1;
}



#pragma mark-DatePickerViewDelegate
-(void) datePickerDone:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    self.birthdayTextField.text = [formatter stringFromDate:date];
    [self.birthdayTextField resignFirstResponder];
    
    [self checkFormValue];
}

-(void)datePickerCancel
{
    [self.birthdayTextField resignFirstResponder];
}

#pragma mark-StringPickerViewDelegate
-(void) stringPickerDone:(long)index
{
    StringPickerViewItem *item = [_pickerViewData objectAtIndex:index];
    self.jobTextField.text = item.name;
    self.jobValue = item.itemId;
    
    [self.jobTextField resignFirstResponder];
    
    [self checkFormValue];
}

-(void)stringPickerCancel
{
    [self.jobTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
