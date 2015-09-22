//
//  SystemMsgViewCell.h
//  OCOCoffee
//
//  Created by panxiaobing on 15/9/21.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SystemMsgViewCell : UITableViewCell

@property(nonatomic,strong) UIView *cellView;
@property(nonatomic,strong) UIView *subCellView;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UIImageView *headImageView;
@property(nonatomic,strong) UILabel *messageLabel;

@end
