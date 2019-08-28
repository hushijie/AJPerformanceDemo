//
//  AJNetworkFlow.h
//  AJPerformanceDemo
//
//  Created by 胡世结 on 2019/7/15.
//  Copyright © 2019 AJ. All rights reserved.
//

/*
 网络流量监测
 */

#import <Foundation/Foundation.h>
#import "AJNetworkFlowModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AJNetworkFlow : NSObject

/**
 获取网络流量监测

 @return AJNetworkFlowModel
 */
+ (AJNetworkFlowModel *)getNetworkFlowMonitorings;

@end

NS_ASSUME_NONNULL_END
