//
//  AJPerformanceView.h
//  AJPerformanceDemo
//
//  Created by 胡世结 on 2019/7/15.
//  Copyright © 2019 AJ. All rights reserved.
//

/*
 【性能监测】自定义view
 */

#import <UIKit/UIKit.h>
#import "AJNetworkFlowModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AJPerformanceView : UIView

@property (nonatomic, copy) void (^timerBlock)(AJNetworkFlowModel *flowModel);
@property (nonatomic, copy) void (^settingChangeBlock)(void);

@end

NS_ASSUME_NONNULL_END
