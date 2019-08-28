//
//  AJFileManagerTool.m
//  AJPerformanceDemo
//
//  Created by 胡世结 on 2019/7/15.
//  Copyright © 2019 AJ. All rights reserved.
//

#import "AJFileManagerTool.h"

@implementation AJFileManagerTool

+ (void)setupFile {
    NSString *documentPath =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject;
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    // 创建 AJPerformance 文件夹
    NSString *performancePath = [documentPath stringByAppendingPathComponent:@"AJPerformance"];
    if (![fileMgr fileExistsAtPath:performancePath]) {
        [fileMgr createDirectoryAtPath:performancePath
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:nil];
    }
    
    // 创建 Sampling 文件夹
    NSString *samplingPath = [performancePath stringByAppendingPathComponent:@"Sampling"];
    if (![fileMgr fileExistsAtPath:samplingPath]) {
        [fileMgr createDirectoryAtPath:samplingPath
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:nil];
    }
    
    // 创建 Console 文件夹
    NSString *consolePath = [performancePath stringByAppendingPathComponent:@"Console"];
    if (![fileMgr fileExistsAtPath:consolePath]) {
        [fileMgr createDirectoryAtPath:consolePath
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:nil];
    }
}

/// Sampling 文件夹
+ (NSString *)samplingPath {
    NSString *documentPath =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject;
    NSString *performancePath = [documentPath stringByAppendingPathComponent:@"AJPerformance"];
    return [performancePath stringByAppendingPathComponent:@"Sampling"];
}

/// Console 文件夹
+ (NSString *)consolePath {
    NSString *documentPath =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject;
    NSString *performancePath = [documentPath stringByAppendingPathComponent:@"AJPerformance"];
    return [performancePath stringByAppendingPathComponent:@"Console"];
}

+ (void)writeSamplingSting:(NSString *)string filePath:(NSString *)filePath {
    if (!string || !filePath) {
        return;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:filePath]) {
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
    [fileHandle seekToEndOfFile];  //将节点跳到文件的末尾
    NSData *stringData  = [string dataUsingEncoding:NSUTF8StringEncoding];
    [fileHandle writeData:stringData]; //追加写入数据
    [fileHandle closeFile];
}

@end
