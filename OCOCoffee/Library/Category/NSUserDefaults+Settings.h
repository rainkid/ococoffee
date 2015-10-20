//
//  NSUserDefaults+Settings.h
//  OCOCoffee
//
//  Created by panxiaobing on 15/9/29.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Settings)

+(BOOL)incomingAvatarSetting;
+(void)setIncomingAvatarSetting:(BOOL)value;

+(BOOL)outcomingAvatarSettings;
+(void)setOutcomingAvatarSetting:(BOOL)value;

+(BOOL)springinessSetting;

+(BOOL)emptySettingMessages;
+(void)emptyMessagesSetting:(BOOL)value;


@end
