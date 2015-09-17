//
//  StringPickerView.m
//  OCOCoffee
//
//  Created by sam on 15/8/1.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import "StringPickerViewItem.h"
#import "StringPickerView.h"

static const CGFloat PickerToolBarHeight = 44.f;


@interface StringPickerView()<UIPickerViewDataSource,UIPickerViewDelegate>

@property(nonatomic,strong) NSMutableArray *pickerViewData;
@property(nonatomic, strong) UIPickerView *pickerView;

@end

@implementation StringPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        _pickerView = [[UIPickerView alloc] initWithFrame: CGRectMake(0, PickerToolBarHeight, frame.size.width, frame.size.height - PickerToolBarHeight)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        [self addSubview: _pickerView];
        
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, frame.size.width, PickerToolBarHeight)];
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

#pragma -pickerView
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_pickerViewData count];
}
-(NSString *)pickerView:(UIPickerView *)pickerView
          titleForRow:(NSInteger)row
         forComponent:(NSInteger)component
{
    StringPickerViewItem *item = [_pickerViewData objectAtIndex:row];
    return item.name;
}


-(IBAction)doneClicked:(id)sender
{
    long index = [_pickerView selectedRowInComponent:0];
    [self.delegate stringPickerDone:index];
    
}
-(IBAction)cancelClicked:(id)sender
{
    [self.delegate stringPickerCancel];
}

-(void)loadData:(NSMutableArray *)data
{
    self.pickerViewData = data;
    [self.pickerView reloadAllComponents];
}


+(void)showPickerView:(StringPickerView *)pickerView withRect:(CGRect) rect onView:(UIView *)view {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    [view bringSubviewToFront:pickerView];
    view.alpha = 0.7;
    pickerView.frame = rect;
    pickerView.hidden= NO;
    //[pickerView.superview setUserInteractionEnabled:NO];
    //view.userInteractionEnabled  = NO;
    pickerView.userInteractionEnabled =YES;
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

+(void)hiddenPickerView:(StringPickerView *)pickerView withRect:(CGRect)rect onView:(UIView *)view {
    [UIView animateWithDuration:0.5 delay:0.01 options:UIViewAnimationOptionCurveEaseOut animations:^{
        pickerView.frame = rect;
        view.alpha = 1.0;
        view.userInteractionEnabled = YES;
    }completion:^(BOOL isfinished ){
        pickerView.hidden = YES;
    }];
}
@end
