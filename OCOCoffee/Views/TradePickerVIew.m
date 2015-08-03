//
//  TradePickerVIew.m
//  OCOCoffee
//
//  Created by sam on 15/7/30.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import "TradePickerVIew.h"

@interface TradePickerVIew()

@end

@implementation TradePickerVIew


#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.countryNames.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.countryNames[row];
}

@end
