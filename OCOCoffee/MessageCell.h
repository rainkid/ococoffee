//
//  MessageCell.h
//  OCOCoffee
//
//  Created by panxiaobing on 15/7/29.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell

@property(strong,nonatomic) UIImageView *photo;
@property(strong,nonatomic) NSString *time;
@property(strong,nonatomic) NSString *title;
@property(strong,nonatomic) NSString *message;
@property(strong,nonatomic) NSString *name;
@property(strong,nonatomic) NSString *typeName;

@end
