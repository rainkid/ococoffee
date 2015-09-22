//
//  FriendListViewCell.h
//  OCOCoffee
//
//  Created by panxiaobing on 15/9/22.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendListViewCell : UITableViewCell

@property(nonatomic,strong) UIImageView *headImageView;
@property(nonatomic,strong) UILabel     *nameLabel;
@property(nonatomic,strong) UIImageView *sexImageView;
@property(nonatomic,strong) UILabel     *ageLabel;
@property(nonatomic,strong) UILabel     *constellationLabel;
@property(nonatomic,strong) UILabel     *messageLabel;

@end
