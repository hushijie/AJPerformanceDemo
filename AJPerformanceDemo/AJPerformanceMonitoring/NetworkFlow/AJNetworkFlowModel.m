//
//  AJNetworkFlowModel.m
//  AJPerformanceDemo
//
//  Created by 胡世结 on 2019/7/15.
//  Copyright © 2019 AJ. All rights reserved.
//

#import "AJNetworkFlowModel.h"

@implementation AJNetworkFlowModel

+ (NSString *)convertBytes:(long)bytes {
    if (bytes < 1024) {
        return [NSString stringWithFormat:@"%.3fKB", (double)bytes / 1024];
    }
    return [NSString stringWithFormat:@"%.1fKB", (double)bytes / 1024];
}

@end
