//
//  DatePickerView.m
//  OCOCoffee
//
//  Created by sam on 15/7/31.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import "DatePickerView.h"

static const CGFloat DatePickerToolBarHeight = 44.f;

@interface DatePickerView()


@end

@implementation DatePickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame: CGRectMake(0, DatePickerToolBarHeight, frame.size.width, frame.size.height - DatePickerToolBarHeight)];
        datePicker.datePickerMode = UIDatePickerModeDate;
        datePicker.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        self.picker = datePicker;
        [self addSubview: datePicker];
        
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, frame.size.width, DatePickerToolBarHeight)];
        toolbar.barStyle = UIBarStyleDefault;
        toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self     action:@selector(cancelClicked:)];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(doneClicked:)];
        UIBarButtonItem* flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        toolbar.items = [NSArray arrayWithObjects:cancelButton, flexibleSpace, doneButton, nil];
        [self addSubview: toolbar];

        
        self.autoresizesSubviews = YES;
    }
    return self;
}

- (void) setMode: (UIDatePickerMode) mode {
    self.picker.datePickerMode = mode;
}

-(IBAction)doneClicked:(id)sender
{
    NSDate *chosen = [_picker date];
    [self.delegate datePickerDone:chosen];
    
}

-(IBAction)cancelClicked:(id)sender
{
    [self.delegate datePickerCancel];
}
-(void)setDate:(NSDate *)date {

    [_picker setDate:date];
}


+(void)showDatePicker:(DatePickerView *)pickerView rect:(CGRect)rect onView:(UIView *)view {
    [UIView animateWithDuration:0.5 delay:0.05 options:UIViewAnimationOptionCurveEaseIn animations:^(){
        
        pickerView.frame = rect;
        pickerView.userInteractionEnabled =YES;
        pickerView.hidden = NO;
        [view bringSubviewToFront:pickerView];
        view.alpha = 0.7;
        
    }completion:^(BOOL isfinished){
    }];
}
+(void)hiddenDatePicker:(DatePickerView *)pickerView rect:(CGRect)rect onView:(UIView *)view {
    [UIView animateWithDuration:0.5 delay:0.05 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
        pickerView.frame = rect;
        view.userInteractionEnabled = YES;
        view.alpha = 1.0;
    }completion:^(BOOL isfinished){
        pickerView.hidden = YES;
    }];
}

@end
