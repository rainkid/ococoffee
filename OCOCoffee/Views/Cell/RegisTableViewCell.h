//
//  RegisTableViewCell.h
//  ococoffee
//
//  Created by sam on 15/7/28.
//  Copyright (c) 2015年 sam. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "SeparatorView.h"

static const CGFloat kCellHeight = 47.0f;
static const CGFloat kTableLeftSide = 23.3;
static const CGFloat kButtonHeight = 43;



typedef NS_ENUM(NSInteger, REGIS_STEP_ONE){
    ONE_USERNAME = 0,
    ONE_CODE,
    ONE_PASSWORD
};

typedef NS_ENUM(NSInteger, REGIS_STEP_TWO){
    TWO_NICKNAKE = 0,
    TWO_SEX,
    TWO_BIRGHDAY,
    TWO_TRADE
};


@interface RegisTableViewCell : UITableViewCell

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *label;


- (void)showBottomLine:(BOOL)showLine;

@end
