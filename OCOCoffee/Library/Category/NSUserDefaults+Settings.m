//
//  NSUserDefaults+Settings.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/9/29.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//


#import "NSUserDefaults+Settings.h"

static NSString * const kSettingSpringiness     = @"kSettingSpringiness";
static NSString * const kSettingIncomingAvatar  = @"kSettingIncomingAvatar";
static NSString * const kSettingOutcomingAvatar = @"kSettginOutcomingAvatar";
static NSString * const kSettingEmptyMessages   = @"kSettingEmptyMessages";


@implementation NSUserDefaults (Settings)

+(BOOL)incomingAvatarSetting {
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:kSettingIncomingAvatar];
}

+(BOOL)outcomingAvatarSettings {
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:kSettingOutcomingAvatar];
}


+(void)setIncomingAvatarSetting:(BOOL)value {
    
    return [[NSUserDefaults standardUserDefaults] setBool:value forKey:kSettingIncomingAvatar];
}

+(void)setOutcomingAvatarSetting:(BOOL)value {
    
    return [[NSUserDefaults standardUserDefaults] setBool:value forKey:kSettingOutcomingAvatar];
}

+(BOOL)springinessSetting {
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:kSettingSpringiness];
}

+(void)emptyMessagesSetting:(BOOL)value {
    
    return [[NSUserDefaults standardUserDefaults] setBool:value forKey:kSettingEmptyMessages];
}

+(BOOL)emptySettingMessages {
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:kSettingEmptyMessages];
}

@end
