//
//  ActivityTableViewCell.h
//  OCOCoffee
//
//  Created by sam on 15/8/17.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat kCellHeight = 440/2;

@interface ActivityTableViewCell : UITableViewCell

@property(nonatomic, strong) UIImageView *headerImageView;
@property(nonatomic, strong) UIImageView *statusImageView;
@property(nonatomic, strong) UILabel *nicknameLabel;
@property(nonatomic, strong) UILabel *sexAgeLabel;
@property(nonatomic, strong) UILabel *conLabel;
@property(nonatomic, strong) UILabel *addressLabel;
@property(nonatomic, strong) UILabel *dateLineLabel;
@property(nonatomic, strong) UILabel *descLabel;
@property(nonatomic, strong) UILabel *beforeLabel;
@property(nonatomic, strong) UIImageView *descImageView;

@end
