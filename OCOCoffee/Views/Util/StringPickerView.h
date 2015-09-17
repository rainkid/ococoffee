//
//  StringPickerView.h
//  OCOCoffee
//
//  Created by sam on 15/8/1.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StringPickerViewDelegate <NSObject>

-(void) stringPickerDone:(long)index;
-(void) stringPickerCancel;

@end

@interface StringPickerView : UIView

@property(nonatomic,strong)id<StringPickerViewDelegate>delegate;

-(void)loadData:(NSMutableArray *)data;

-(void)selectedRow:(NSInteger)row andComponent:(NSInteger)component;

+(void)showPickerView:(StringPickerView *)pickerView withRect:(CGRect) rect onView:(UIView *)view;
+(void)hiddenPickerView:(StringPickerView *)pickerView withRect:(CGRect)rect onView:(UIView *)view;
@end

