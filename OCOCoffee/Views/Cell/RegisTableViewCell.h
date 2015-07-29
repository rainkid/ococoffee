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

@interface RegisTableViewCell : UITableViewCell

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *button;


- (void)showBottomLine:(BOOL)showLine;
- (void)showCodeButton:(BOOL)showButton;

@end
