//
//  InviteSearchViewController.h
//  OCOCoffee
//
//  Created by panxiaobing on 15/9/7.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InviteSearchControllerDelegate <NSObject>

-(void)getSelectedData:(NSString *)msg lat:(NSString *)lat log:(NSString *)log;

@end

@interface InviteSearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,assign) id<InviteSearchControllerDelegate> delegate;
@property(nonatomic,strong) NSString *queryString;

-(void)suggestionData;

@end
