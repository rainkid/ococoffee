//
//  RegisStepThreeViewController.m
//  OCOCoffee
//
//  Created by sam on 15/8/3.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import "Golbal.h"
#import "UIColor+colorBuild.h"
#import <Masonry/Masonry.h>
#import <SKTagView/SKTag.h>
#import <SKTagView/SKTagButton.h>
#import <SKTagView/SKTagView.h>
#import "RegisStepThreeViewController.h"
static const CGFloat kHeight = 48.6f;
static const CGFloat kTableLeftSide = 23.3f;

@interface RegisStepThreeViewController ()

@property(nonatomic, strong) UITextField *textField;
@property(nonatomic,strong) SKTagView *tagView;
@property(nonatomic, assign) int selectTagCount;

@end

@implementation RegisStepThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addSubViews];
    [self setupTagView];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addSubViews {
    UIImage *bg_image = [UIImage imageNamed:@"background.png"];
    UIImageView *bg_imageView = [[UIImageView alloc] initWithImage:bg_image];
    [bg_imageView setFrame:self.view.bounds];
    [self.view addSubview:bg_imageView];
    
//    __weak typeof(self) weakSelf = self;
    
    UIView *view = [UIView new];
    [self.view addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kTableLeftSide);
        make.right.mas_equalTo(-kTableLeftSide);
        make.top.mas_equalTo(PHONE_NAVIGATIONBAR_HEIGHT);
        make.height.mas_equalTo(PHONE_CONTENT_HEIGHT);
    }];
    
    UITextField *textField = [UITextField new];
    textField.placeholder = @"  添加自定义标签（2-5个字符）";
    textField.backgroundColor = [UIColor whiteColor];
    textField.layer.cornerRadius = 3;
    textField.layer.masksToBounds = YES;
    self.textField = textField;
    [view addSubview:textField];
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.mas_top);
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(kHeight);
    }];
    
    UIImageView *plus= [UIImageView new];
    plus.userInteractionEnabled = YES;
    [plus setImage:[UIImage imageNamed:@"regis_plus"]];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUserPlus:)];
    [singleTap setNumberOfTouchesRequired:1];
    [singleTap setNumberOfTapsRequired:1];
    [plus addGestureRecognizer:singleTap];
    [view addSubview:plus];
    
    [plus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textField.mas_top);
        make.height.and.width.equalTo(textField.mas_height);
        make.right.equalTo(textField.mas_right);
    }];
    
    
    UILabel *label = [UILabel new];
    label.text = @"给TA印象更深，您可以选择1-5个标签";
    label.textColor = [UIColor colorFromHexString:@"#aaaaaa"];
    label.font = [UIFont systemFontOfSize:14];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(textField.mas_left);
        make.height.mas_equalTo(kHeight);
        make.top.equalTo(textField.mas_bottom);
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
                        tagBtnView.backgroundColor = [UIColor colorFromHexString:@"#9cd7cd"];
                        [tagBtnView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        tagBtnView.tag = 1;
                    }
                } else {
                    NSLog(@"只能选择5个标签");
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
}

- (void)setupTagView
{
    //Add Tags
    [@[@"电烧友", @"电影控", @"吃货", @"旅游达人", @"喜欢冰琪淋",@"代码控", @"大叔", @"罗莉控"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         [self addTagWithObj:obj];
     }];
}

- (void) addTagWithObj:(id)obj
{
    SKTag *tag = [SKTag tagWithText:obj];
    tag.textColor = [UIColor blackColor];
    tag.bgColor = [UIColor whiteColor];
    tag.cornerRadius = 3;
    tag.fontSize = 13;
    tag.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    
    [self.tagView addTag:tag];
}

#pragma mark 用户单击上传图像
- (void)tapUserPlus:(UITapGestureRecognizer*)tap
{
    NSString *customTag = _textField.text;
    if ([customTag length] != 0){
        [self addTagWithObj:customTag];
        _textField.text = @"";
    }
}
@end
