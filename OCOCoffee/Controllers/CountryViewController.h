//
//  CountryViewController.h
//  OCOCoffee
//
//  Created by panxiaobing on 15/7/26.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProvinceControllerDelegate <NSObject>

-(void)showProvinceInfo ;

@end

@interface CountryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic) NSMutableArray *dataList;
@property(strong,nonatomic) NSArray *cityList;
@property(assign,nonatomic) id<ProvinceControllerDelegate>delegate;

-(NSMutableArray *)getDataList;

@end
