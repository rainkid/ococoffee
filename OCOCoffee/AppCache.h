//
//  AppCache.h
//  OCOCoffee
//
//  Created by panxiaobing on 15/8/22.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppCache : NSObject



+(BOOL) setCacheImageWithUrlString:(NSData *)data withURLString:(NSString*)urlstring  WithType:(NSString *)type;  //写图片缓存

+(NSData *) getCachedImageWithUrlString:(NSString *)urlstring AndType:(NSString *)type;        //读缓存图片

+(void) clearCachedDataWithType:(NSString *)type;                       //清除指定类型缓存文件

+(void) clearAllCachedData;     //清除所有缓存文件

+(BOOL) checkCacheIsExpried:(NSTimer *)time; //检测缓存是否过期

@end
