//
//  AJWeakProxy.h
//  AJPerformanceDemo
//
//  Created by 胡世结 on 2019/7/12.
//  Copyright © 2019 AJ. All rights reserved.
//

/**
 实现的原理： 使用 NSProxy 持有 NSTimer/CADisplayLink 的 target
 不再用 NSTimer/CADisplayLink 直接持有 self，就不会导致 timer/link 对 self 的循环强引用了
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AJWeakProxy : NSProxy

@property (nonatomic, weak, readonly) id target;//目标对象

+ (instancetype)proxyWithTarget:(id)target;

@end

NS_ASSUME_NONNULL_END
