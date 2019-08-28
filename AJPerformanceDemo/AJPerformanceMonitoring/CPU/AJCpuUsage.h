//
//  AJCpuUsage.h
//  AJPerformanceDemo
//
//  Created by 胡世结 on 2019/7/12.
//  Copyright © 2019 AJ. All rights reserved.
//

/*
 获取CPU的占用率
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AJCpuUsage : NSObject

/// 获取当前应用在CPU中的占有率
+ (double)getCpuUsage;

@end

NS_ASSUME_NONNULL_END
