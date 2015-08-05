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
        
        UIDatePicker *picker = [[UIDatePicker alloc] initWithFrame: CGRectMake(0, DatePickerToolBarHeight, frame.size.width, frame.size.height - DatePickerToolBarHeight)];
        picker.datePickerMode = UIDatePickerModeDate;
        picker.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        self.picker = picker;
        [self addSubview: picker];
        
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


@end
