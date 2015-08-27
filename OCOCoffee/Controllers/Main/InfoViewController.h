//
//  InfoDetailViewController.h
//  OCOCoffee
//
//  Created by sam on 15/8/21.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IndexListItem;

@interface InfoViewController : UIViewController
@property(nonatomic,strong) IndexListItem *userInfo;
@property(nonatomic, assign) CGFloat userId;
@property(nonatomic, assign) double logitude;
@property(nonatomic, assign) double latitude;

@end
