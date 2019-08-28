//
//  AJNetworkFlowModel.h
//  AJPerformanceDemo
//
//  Created by 胡世结 on 2019/7/15.
//  Copyright © 2019 AJ. All rights reserved.
//

/*
 网络流量model
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AJNetworkFlowModel : NSObject

@property (nonatomic, assign) long WiFiSent;// WiFi发送流量
@property (nonatomic, assign) long WiFiReceived;// WiFi接收流量
@property (nonatomic, assign) long WiFiTotalTraffic;// 传输总流量

@property (nonatomic, assign) long WWANSent;// 移动网络发送流量
@property (nonatomic, assign) long WWANReceived;// 移动网络接收流量
@property (nonatomic, assign) long WWANTotalTraffic;/// WWAN传输总流量

/**
 将B（字节）转化为KB字符串
 
 @param bytes 字节
 @return KB字符串
 */
+ (NSString *)convertBytes:(long)bytes;

@end

NS_ASSUME_NONNULL_END
