//
//  InviteViewController.h
//  OCOCoffee
//
//  Created by panxiaobing on 15/8/29.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePickerView.h"
#import "InviteSearchView.h"
#import "InviteSearchViewController.h"


@interface InviteViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,DatePickerViewDelegate,UITextFieldDelegate,InviteSearchControllerDelegate>

@property(nonatomic,strong) NSNumber *uid;

@end