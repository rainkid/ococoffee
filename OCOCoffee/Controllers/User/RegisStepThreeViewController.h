//
//  RegisStepThreeViewController.h
//  OCOCoffee
//
//  Created by sam on 15/8/3.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisStepThreeViewController : UIViewController

@property(nonatomic, strong) NSString *phone;
@property(nonatomic, strong) NSString *password;
@property(nonatomic, strong) NSString *nickname;
@property(nonatomic, strong) NSString *birthday;

@property(nonatomic, assign) long sexValue;
@property(nonatomic, assign) long jobValue;

@property(nonatomic, copy) NSMutableArray *tagData;
@property(nonatomic, strong) NSString *headimgpath;

@end
