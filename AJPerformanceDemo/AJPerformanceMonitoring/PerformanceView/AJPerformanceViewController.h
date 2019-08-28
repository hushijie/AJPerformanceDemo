//
//  AJPerformanceViewController.h
//  AJPerformanceDemo
//
//  Created by 胡世结 on 2019/7/15.
//  Copyright © 2019 AJ. All rights reserved.
//

/*
 性能监控设置vc
 */

#import <UIKit/UIKit.h>
#import "AJNetworkFlowModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AJPerformanceViewController : UITableViewController

@property (nonatomic, copy) void (^timerBlock)(AJNetworkFlowModel *flowModel);
@property (nonatomic, copy) void (^settingChangeBlock)(void);
@property (nonatomic, copy) void (^clickCloseBlock)(void);

@end

NS_ASSUME_NONNULL_END
