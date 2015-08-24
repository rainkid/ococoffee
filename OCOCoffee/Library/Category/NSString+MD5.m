//
//  NSString+MD5.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/8/22.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString(NSString_MD5)

//字符串MD5加密
-(NSString *)MD5Hash
{
    const char *str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str,(uint32_t)strlen(str),result);
    NSMutableString *hash = [[NSMutableString alloc] init];
    for(int i = 0;i<16;i++) {
        [hash appendFormat:@"%02X",result[i]];
    }
    return [hash lowercaseString];
    
}

@end
