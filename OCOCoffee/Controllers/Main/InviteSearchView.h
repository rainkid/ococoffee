//
//  InviteSearchView.h
//  OCOCoffee
//
//  Created by panxiaobing on 15/9/6.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InviteSearchViewDelegate <NSObject>

-(void)getSelectedData:(NSString *)msg lat:(NSString *)lat log:(NSString *)log;

@end

@interface InviteSearchView : UIView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,assign) id<InviteSearchViewDelegate> delegate;
@property(nonatomic,strong) NSString *queryString;

-(void)requestSuggestionData;

@end
