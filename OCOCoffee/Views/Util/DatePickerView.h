//
//  DatePickerView.h
//  OCOCoffee
//
//  Created by sam on 15/7/31.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatePickerViewDelegate <NSObject>

-(void) datePickerDone:(NSDate *)date;
-(void) datePickerCancel;

@end

@interface DatePickerView : UIView

@property (nonatomic, assign, readwrite) UIDatePicker *picker;
@property(nonatomic,strong)id<DatePickerViewDelegate>delegate;

- (void) setMode: (UIDatePickerMode) mode;

+(void)showDatePicker:(DatePickerView *)pickerView rect:(CGRect)rect onView:(UIView *)view;
+(void)hiddenDatePicker:(DatePickerView *)pickerView rect:(CGRect)rect onView:(UIView *)view;

@end
