//
//  TagViewController.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/9/16.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import "TagViewController.h"
#import <SKTagView/SKTag.h>
#import <SKTagView/SKTagView.h>
#import <SKTagView/SKTagButton.h>
#import <Masonry/Masonry.h>

#import "ViewStyles.h"
#import "UIColor+colorBuild.h"

static const CGFloat kHeight = 48.6f;
static const CGFloat kTableLeftSide = 23.3f;
static const CGFloat kButtonHeight = 43;

@interface TagViewController ()<UITextFieldDelegate>{
    
    UITextField *_textField;

}

@end

@implementation TagViewController

-(void)viewDidLoad {
    
    self.title = @"选择标签";
    [ViewStyles setNaviControllerStyle:self.navigationController];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(returnBack)
                                   ];
    self.navigationItem.leftBarButtonItem = leftButton;
    self.view.backgroundColor = [UIColor colorFromHexString:@"#f6f6f6"];
    
    [self initlizeView];
    
}

-(void)initlizeView {
    
//    UIImage *bg_image = [UIImage imageNamed:@"background"];
//    UIImageView *bg_imageView = [[UIImageView alloc] initWithImage:bg_image];
//    [bg_imageView setFrame:self.view.bounds];
//    [self.view addSubview:bg_imageView];
    
    UIView *view = [UIView new];
    [self.view addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(20);
        make.right.mas_equalTo(self.view.mas_right).offset(20);
        make.top.mas_equalTo(PHONE_NAVIGATIONBAR_HEIGHT+PHONE_STATUSBAR_HEIGHT+10);
        make.height.mas_equalTo(PHONE_CONTENT_HEIGHT);
    }];
    
    _textField = ({
        UITextField *textField = [UITextField new];
        textField.placeholder = @"  添加自定义标签（2-5个字符）";
        textField.backgroundColor = [UIColor whiteColor];
        textField.layer.cornerRadius = 3;
        textField.returnKeyType = UIReturnKeyDone;
        textField.layer.masksToBounds = YES;
        textField;
    });
    _textField.delegate = self;
    [view addSubview:_textField];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
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
        make.top.equalTo(_textField.mas_top);
        make.height.and.width.equalTo(_textField.mas_height);
        make.right.equalTo(_textField.mas_right);
    }];
    
    
    UILabel *label = [UILabel new];
    label.text = @"给TA印象更深，您可以选择1-5个标签";
    label.textColor = [UIColor colorFromHexString:@"#aaaaaa"];
    label.font = [UIFont systemFontOfSize:14];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_textField.mas_left);
        make.height.mas_equalTo(kHeight);
        make.top.equalTo(_textField.mas_bottom);
    }];

}
-(void)returnBack{
    [self.navigationController dismissViewControllerAnimated:YES completion:^(void){
        NSLog(@"completed");
    }];

}

@end
