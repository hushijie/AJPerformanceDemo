//
//  AJPerformanceMonitoring.m
//  AJPerformanceDemo
//
//  Created by 胡世结 on 2019/7/15.
//  Copyright © 2019 AJ. All rights reserved.
//

#import "AJPerformanceMonitoring.h"
#import "AJPerformanceView.h"
#import "AJFloatingBall.h"
#import "AJPerformanceViewController.h"
#import "AJFloatingBallManager.h"

@implementation AJPerformanceMonitoring

+ (void)showMonitorView {
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat pWH = 100;
    CGFloat pY = height - pWH - 100;
    CGRect pFrame = CGRectMake(100, pY, pWH, pWH);
    AJPerformanceView *performanceView = [[AJPerformanceView alloc] initWithFrame:pFrame];
    performanceView.layer.cornerRadius = pFrame.size.width / 2;
    performanceView.layer.masksToBounds = YES;
    
    AJFloatingBall *floating = [[AJFloatingBall alloc] initWithFrame:pFrame];
    floating.edgePolicy = AJFloatingBallEdgePolicyLeftRight;
    floating.autoCloseEdge = YES;
    [floating setContent:performanceView contentType:AJFloatingBallContentTypeCustomView];
    [floating show];
    floating.clickHandler = ^(AJFloatingBall * _Nonnull floatingBall) {
        [self dealClickHanderWithPerformanceView:performanceView];
    };
}

+ (void)dealClickHanderWithPerformanceView:(AJPerformanceView *)performanceView {
    if ([AJFloatingBallManager shareManager].isShowSettingView) {
        return;
    }
    [AJFloatingBallManager shareManager].isShowSettingView = YES;
    
    UIViewController *topVC = [self getCurrentViewController];
    AJPerformanceViewController *pVc = [[AJPerformanceViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:pVc];
    [topVC presentViewController:nav animated:YES completion:nil];
    pVc.clickCloseBlock = ^{
        [AJFloatingBallManager shareManager].isShowSettingView = NO;
    };
    
    performanceView.timerBlock = pVc.timerBlock;
    pVc.settingChangeBlock = performanceView.settingChangeBlock;
}

// 获取当前所在的视图
+ (UIViewController *)getCurrentViewController {
    UIViewController *topController = [UIApplication sharedApplication].delegate.window.rootViewController;
    while ([topController presentedViewController]) {
        topController = [topController presentedViewController];
    }
    if ([topController isKindOfClass:[UITabBarController class]]) {
        topController = [(UITabBarController *)topController selectedViewController];
    }
    while ([topController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)topController topViewController])
        topController = [(UINavigationController*)topController topViewController];
    
    return topController;
}

@end
