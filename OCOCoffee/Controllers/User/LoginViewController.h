//
//  LoginViewController.h
//  ococoffee
//
//  Created by sam on 15/7/27.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginSuccessProtocol <NSObject>

@required
-(void)UserLoginSuccess;

@end

@interface LoginViewController : UIViewController

@property(nonatomic, strong) id<LoginSuccessProtocol> delegate;

@end
