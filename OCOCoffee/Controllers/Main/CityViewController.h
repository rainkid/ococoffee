//
//  CityViewController.h
//  OCOCoffee
//
//  Created by panxiaobing on 15/7/26.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CityViewControllerDelegate <NSObject>

-(void)showDiscinct:(NSString *)province withCity:(NSString *)city;

@end

@interface CityViewController : UIViewController<UITabBarControllerDelegate,UITableViewDataSource,UITableViewDelegate>


@property(strong,nonatomic) NSString *provinceName;
@property(strong ,nonatomic) NSArray *cityList;
@property(assign,nonatomic) id<CityViewControllerDelegate>delegate;

@end
