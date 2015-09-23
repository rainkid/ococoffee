//
//  MessageCell.h
//  OCOCoffee
//
//  Created by panxiaobing on 15/7/29.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell

@property(strong,nonatomic) UIImageView     *headImageView;
@property(strong,nonatomic) UILabel         *nicknameLabel;
@property(strong,nonatomic) UILabel         *numLabel;
@property(strong,nonatomic) UILabel         *messageLabel;
@property(strong,nonatomic) UILabel         *timeLabel;

@end
