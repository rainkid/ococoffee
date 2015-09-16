//
//  AppCache.m
//  OCOCoffee
//
//  Created by panxiaobing on 15/8/22.
//  Copyright (c) 2015年 gionee_panxb. All rights reserved.
//

#import "AppCache.h"
#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/SDImageCache.h>
#import "NSString+MD5.h"

@implementation AppCache


+(void)initialize {
    
    
}


+(void)dealloc{
    
}


+(NSData *)getImageWithUrlString:(NSString *)urlstring Type:(NSString *)type{
    
    NSData *data = [self getCachedImageWithUrlString:urlstring AndType:type];
    if(data == nil){
        
    }
    return nil;
}


//读缓存图片
+(NSData *)getCachedImageWithUrlString:(NSString *)urlstring AndType:(NSString *)type {
    
    NSString *path = [AppCache cachePathByType:type];  //缓存文件目录
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[urlstring MD5Hash]]];
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        return data;
    }
    
    return nil;
}

//图片写入本地缓存
+(BOOL) setCacheImageWithUrlString:(NSData *)data withURLString:(NSString*)urlstring  WithType:(NSString *)type {
    
    NSString *path = [AppCache cachePathByType:type];
    NSString *filename = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[urlstring MD5Hash]]];
    return  [data writeToFile:filename atomically:YES];
}

//清除某类型缓存数据
+(void)clearCachedDataWithType:(NSString *)type {
    
}

//清空所有缓存数据
+(void)clearAllCachedData {
    
    NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[AppCache cachePath] error:nil];
    for (NSString *path in array) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
}

//检测缓存数据是否已过期
+(BOOL)checkCacheIsExpried:(NSTimer *)time {
   
    return YES;
}

//得到要缓存数据的根目录
+(NSString *)cachePath {
    NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *dir  = [pathList objectAtIndex:0];
    NSString *cacheDir = [dir stringByAppendingPathComponent:@"imageCache"];
    if([AppCache createDir:cacheDir]){
        return cacheDir;
    }
    return nil;
    
}

//创建目录
+(BOOL)createDir:(NSString *)dir {
    BOOL isdir;
    BOOL direxists = [[NSFileManager defaultManager] fileExistsAtPath:dir isDirectory:&isdir];
    if(!(direxists && isdir)){
        return [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return YES;
}


//得到某类型缓存数据的目录
+(NSString *)cachePathByType:(NSString *)type{
    
    NSString *basePath = [AppCache cachePath];
    NSString *dir  = [basePath stringByAppendingPathComponent:type];
    if([AppCache createDir:dir]){
        return dir;
    }
    return nil;
}

@end
