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

@protocol InviteSuccessProtocol <NSObject>

@required
-(void) InviteSuccess;

@end

@interface InviteViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,DatePickerViewDelegate,UITextFieldDelegate,InviteSearchControllerDelegate>

@property(nonatomic, strong) id<InviteSuccessProtocol> delegate;

@property(nonatomic,strong) NSNumber *uid;

@end
