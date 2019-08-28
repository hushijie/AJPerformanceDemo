//
//  AJAppMemory.h
//  AJPerformanceDemo
//
//  Created by 胡世结 on 2019/7/12.
//  Copyright © 2019 AJ. All rights reserved.
//

/*
 获取App占用内存的情况
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AJAppMemory : NSObject

/// 获取当前应用的内存占用情况，和Xcode数值相近
+ (double)getMemoryUsage;

@end

NS_ASSUME_NONNULL_END
