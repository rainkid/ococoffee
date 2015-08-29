//
//  StringPickerViewItem.h
//  OCOCoffee
//
//  Created by sam on 15/8/27.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StringPickerViewItem : UICollectionViewCell
@property(nonatomic, assign) int itemId;
@property(nonatomic, strong) NSString *name;
@end
