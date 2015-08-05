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

@property(nonatomic,strong) NSArray *pickerViewData;
@property(nonatomic,strong)id<StringPickerViewDelegate>delegate;


@end
