//
//  SearchViewController.h
//  OCOCoffee
//
//  Created by panxiaobing on 15/7/25.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountryViewController.h"
#import "CityViewController.h"

@interface SearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UINavigationBarDelegate,ProvinceControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@end
