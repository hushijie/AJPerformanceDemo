//
//  AJFileManagerTool.h
//  AJPerformanceDemo
//
//  Created by 胡世结 on 2019/7/15.
//  Copyright © 2019 AJ. All rights reserved.
//

/*
 文件管理工具类
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AJFileManagerTool : NSObject

/// 创建文件夹
+ (void)setupFile;

/// Sampling 文件夹
+ (NSString *)samplingPath;

/// Console 文件夹
+ (NSString *)consolePath;

/**
 将【取样数据】写入某路径的文件中

 @param string 取样数据内容
 @param filePath 文件路径
 */
+ (void)writeSamplingSting:(NSString *)string filePath:(NSString *)filePath;

@end

NS_ASSUME_NONNULL_END
