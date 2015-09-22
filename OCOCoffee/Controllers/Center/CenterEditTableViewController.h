//
//  CenterEditTableViewController.h
//  OCOCoffee
//
//  Created by panxiaobing on 15/9/14.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "CenterHeaderCell.h"

@protocol CenterEditTableViewControllerDelegate <NSObject>

-(void)loadNewDataFromServer;

@end

@interface CenterEditTableViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,CenterHeaderCellDelegate>
@property(nonatomic,strong) NSMutableDictionary *userDict;

@property(nonatomic,strong) id<CenterEditTableViewControllerDelegate>delegate;

@end
