//
//  RegisStepThreeViewController.m
//  OCOCoffee
//
//  Created by sam on 15/8/3.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import "Global.h"
#import "Common.h"
#import "UIColor+colorBuild.h"
#import <Masonry/Masonry.h>
#import <AFNetworking/AFNetworking.h>
#import <SKTagView/SKTag.h>
#import "TagItem.h"
#import <SKTagView/SKTagButton.h>
#import <SKTagView/SKTagView.h>
#import "RegisStepThreeViewController.h"
static const CGFloat kHeight = 48.6f;
static const CGFloat kTableLeftSide = 23.3f;
static const CGFloat kButtonHeight = 43;

@interface RegisStepThreeViewController ()<UITextFieldDelegate>

@property(nonatomic, strong) UITextField *textField;
@property(nonatomic,strong) SKTagView *tagView;
@property(nonatomic, assign) int selectTagCount;

@property(nonatomic, strong) NSMutableArray *tag_ids;
@property(nonatomic, strong) NSMutableArray *tags;

@end

@implementation RegisStepThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tag_ids = [NSMutableArray array];
    self.tags = [NSMutableArray array];
    [self initSubViews];
    [self initTags];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initSubViews {
    __weak typeof(self) weakSelf = self;

    UIImage *bg_image = [UIImage imageNamed:@"background"];
    UIImageView *bg_imageView = [[UIImageView alloc] initWithImage:bg_image];
    [bg_imageView setFrame:self.view.bounds];
    [self.view addSubview:bg_imageView];
    
    UIView *view = [UIView new];
    [self.view addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kTableLeftSide);
        make.right.mas_equalTo(-kTableLeftSide);
        make.top.mas_equalTo(PHONE_NAVIGATIONBAR_HEIGHT);
        make.height.mas_equalTo(PHONE_CONTENT_HEIGHT);
    }];
    
    self.textField = ({
        UITextField *textField = [UITextField new];
        textField.placeholder = @"  添加自定义标签（2-5个字符）";
        textField.backgroundColor = [UIColor whiteColor];
        textField.layer.cornerRadius = 3;
        textField.returnKeyType = UIReturnKeyDone;
        textField.layer.masksToBounds = YES;
        textField;
    });
    self.textField.delegate = self;
    [view addSubview:self.textField];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.mas_top);
        make.left.mas_equalTo(view);
        make.height.mas_equalTo(kHeight);
    }];
    
    UIImageView *plus= [UIImageView new];
    plus.userInteractionEnabled = YES;
    [plus setImage:[UIImage imageNamed:@"regis_plus"]];
    [view addSubview:plus];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUserPlus:)];
    [singleTap setNumberOfTouchesRequired:1];
    [singleTap setNumberOfTapsRequired:1];
    [plus addGestureRecognizer:singleTap];


    [plus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.textField.mas_top);
        make.height.and.width.equalTo(weakSelf.textField.mas_height);
        make.right.equalTo(weakSelf.textField.mas_right);
    }];
    
    
    UILabel *label = [UILabel new];
    label.text = @"给TA印象更深，您可以选择1-5个标签";
    label.textColor = [UIColor colorFromHexString:@"#aaaaaa"];
    label.font = [UIFont systemFontOfSize:14];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.textField.mas_left);
        make.height.mas_equalTo(kHeight);
        make.top.equalTo(weakSelf.textField.mas_bottom);
    }];
    
    self.selectTagCount = 0;
    self.tagView = ({
        SKTagView *view = [SKTagView new];
        view.padding    = UIEdgeInsetsMake(0, 0, 0, 0);
        view.insets    = 5;
        view.lineSpace = 10;
        __weak SKTagView *weakView = view;
                
        //Handle tag's click event
        view.didClickTagAtIndex = ^(NSUInteger index){
            //Remove tag
            SKTagButton *tagBtnView = [weakView.subviews objectAtIndex:index];
            
            //只能选中5个标签及标签选中、取消状态变化
            if (tagBtnView.tag == 1) {
                self.selectTagCount--;
                tagBtnView.backgroundColor = [UIColor whiteColor];
                [tagBtnView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                tagBtnView.tag = 0;
            } else {
                if (self.selectTagCount < 5) {
                    if (tagBtnView.tag == 0) {
                        self.selectTagCount++;
                        if (index >= [self.tagData count]) {
                            tagBtnView.backgroundColor = [UIColor colorFromHexString:@"#c9dd22"];
                            [self.tags addObject:tagBtnView.titleLabel.text];
                        } else {
                            TagItem *item = [self.tagData objectAtIndex:index];
                            [self.tag_ids addObject:item.tagId];
                            tagBtnView.backgroundColor = [UIColor colorFromHexString:item.bg_color];
                        }
                        [tagBtnView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        tagBtnView.tag = 1;
                    }
                } else {
                    [Common showErrorDialog:@"只能选择5个标签"];
                }
            }
        };
        view;
    });
    [view addSubview:self.tagView];
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_left);
        make.top.equalTo(label.mas_bottom);
        make.right.mas_equalTo(view.mas_right);
    }];
    
    //next button
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    nextBtn.backgroundColor = [UIColor colorFromHexString:@"#4a2320"];
    nextBtn.layer.cornerRadius = 3;
    nextBtn.layer.masksToBounds = YES;
    [nextBtn setTitle:@"完成"  forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(registerFinish) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.height.mas_equalTo(kButtonHeight);
        make.left.and.right.equalTo(weakSelf.textField);
        make.bottom.mas_equalTo(weakSelf.view.mas_bottom).offset(-100);
    }];
}

#pragma mark-add tags
- (void) initTags
{
    for (TagItem *tagItem in self.tagData) {
        SKTag *tag = [SKTag tagWithText:tagItem.name];
        tag.textColor = [UIColor blackColor];
        tag.bgColor = [UIColor whiteColor];
        tag.cornerRadius = 3;
        tag.fontSize = 13;
        tag.padding = UIEdgeInsetsMake(5, 5, 5, 5);
        [self.tagView addTag:tag];
    }
}

#pragma mark-add custom tag
- (void)tapUserPlus:(UITapGestureRecognizer*)tap
{
    NSString *title = _textField.text;
    if ([title length] != 0){
        SKTag *tag = [SKTag tagWithText:title];
        tag.textColor = [UIColor blackColor];
        tag.bgColor = [UIColor whiteColor];
        tag.cornerRadius = 3;
        tag.fontSize = 13;
        tag.padding = UIEdgeInsetsMake(5, 5, 5, 5);
        [self.tagView addTag:tag];
        _textField.text = @"";
    }
}

#pragma mark-textField
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    NSLog(@"textFieldShouldReturn %ld", textField.tag);
    return NO;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"textFieldDidBeginEditing %ld", textField.tag);
    
    [textField becomeFirstResponder];
}

-(void) textFieldDidEndEditing: (UITextField * ) textField {
    NSLog(@"textFieldDidEndEditing %ld", textField.tag);
    NSLog(@"controller %ld", textField.tag);
}

#pragma mark - register finish
-(void)registerFinish {
    NSString *apiUrl = API_DOMAIN@"api/user/register";
    NSNumber *sex = [NSNumber numberWithFloat:self.sexValue];
    NSNumber *job = [NSNumber numberWithFloat:self.jobValue];
    NSLog(@"%@", sex);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"phone":self.phone, @"password":self.password, @"nickname":self.nickname, @"sex":sex, @"job":job, @"birthday":self.birthday, @"tag_ids":self.tag_ids, @"tags":self.tags};

    [manager POST:apiUrl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:self.headimgpath] name:@"headimgurl" error:nil];
    } success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSLog(@"%@", responseObject);
        [self analyseResponse:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(void)analyseResponse:(NSDictionary *)jsonObject
{
    if ([jsonObject isKindOfClass:[NSDictionary class]]) {
        if ([jsonObject[@"success"] integerValue] == 1) {
            
            [self dismissViewControllerAnimated:YES completion:^{
                //set cookid data
                [Common shareUserCookie];
                //
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            
        } else {
            [Common showErrorDialog:jsonObject[@"msg"]];
        }
    } else {
        NSLog(@"response error");
    }
}
@end
