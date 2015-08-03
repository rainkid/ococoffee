//
//  RegisStepThreeViewController.m
//  OCOCoffee
//
//  Created by sam on 15/8/3.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import "Golbal.h"
#import "UIColor+colorBuild.h"
#import "SKTagView.h"
#import "RegisStepThreeViewController.h"

static const CGFloat kHeight = 48.6;
static const CGFloat kTableLeftSide = 23.3;

@interface RegisStepThreeViewController ()
@property(nonatomic,strong) SKTagView *tagView;
@end

@implementation RegisStepThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addSubViews];
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
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(kTableLeftSide, PHONE_NAVIGATIONBAR_HEIGHT+15.6, SCREEN_WIDTH - (kTableLeftSide*2), self.view.bounds.size.height)];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, kHeight)];
    textField.placeholder = @"  添加自定义标签（2-5个字符）";
    textField.backgroundColor = [UIColor whiteColor];
    textField.layer.cornerRadius = 3;
    textField.layer.masksToBounds = YES;
    [view addSubview:textField];

    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, kHeight, view.frame.size.width, kHeight)];
    label.text = @"给TA印象更深，您可以选择1-5个标签";
    label.textColor = [UIColor colorFromHexString:@"#aaaaaa"];
    [view addSubview:label];
    
    self.tagView = ({
        SKTagView *view = [SKTagView new];
        view.backgroundColor = UIColor.cyanColor;
        view.padding    = UIEdgeInsetsMake(10, 25, 10, 25);
        view.insets    = 5;
        view.lineSpace = 2;
        __weak SKTagView *weakView = view;
        //Handle tag's click event
        view.didClickTagAtIndex = ^(NSUInteger index){
            //Remove tag
            [weakView removeTagAtIndex:index];
        };
        view;
    });
    [view addSubview:self.tagView];
    
    //Add Tags
    [@[@"Python", @"Javascript", @"HTML", @"Go", @"Objective-C",@"C", @"PHP"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         SKTag *tag = [SKTag tagWithText:obj];
         tag.textColor = UIColor.whiteColor;
         tag.bgColor = UIColor.orangeColor;
         tag.cornerRadius = 3;
         tag.fontSize = 15;
         tag.padding = UIEdgeInsetsMake(13.5, 12.5, 13.5, 12.5);
         
         [self.tagView addTag:tag];
     }];
    
    [self.view addSubview:view];
    
}

@end
