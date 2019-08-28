//
//  AJFloatingBallManager.h
//  AJPerformanceDemo
//
//  Created by 胡世结 on 2019/7/15.
//  Copyright © 2019 AJ. All rights reserved.
//

/*
 悬浮球管理类
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AJFloatingBallManager : NSObject

@property (nonatomic, assign) BOOL canRuntime;
@property (nonatomic, weak) UIView *superView;
@property (nonatomic, assign) BOOL isShowSettingView;//是否展示【性能监测设置】vc（作用：避免重复展示）

+ (instancetype)shareManager;
// 将NSlog打印信息保存到Document目录下的文件中
- (void)redirectNSlogToDocumentFolder;

@end

NS_ASSUME_NONNULL_END
