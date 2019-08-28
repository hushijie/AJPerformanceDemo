//
//  AJFPSLabel.m
//  AJPerformanceDemo
//
//  Created by 胡世结 on 2019/7/12.
//  Copyright © 2019 AJ. All rights reserved.
//

#import "AJFPSLabel.h"
#import "AJWeakProxy.h"

@interface AJFPSLabel () {
    CADisplayLink * _displayLink;
    NSTimeInterval _lastTimestamp;//最新的屏幕刷新时间戳（单位：秒）
    NSInteger _count;//屏幕刷新次数
}

@end

@implementation AJFPSLabel

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.textAlignment = NSTextAlignmentCenter;
        [self addDisplayLink];
    }
    return self;
}

-(void)dealloc {
    [self removeDisplayLink];
}


#pragma mark  - CADisplayLink

- (void)addDisplayLink {
    _displayLink = [CADisplayLink displayLinkWithTarget:[AJWeakProxy proxyWithTarget:self] selector:@selector(displayLinkAction:)];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)removeDisplayLink {
    [_displayLink invalidate];
    _displayLink = nil;
}

- (void)displayLinkAction:(CADisplayLink *)displayLink {
    if (_lastTimestamp == 0) {
        _lastTimestamp = displayLink.timestamp;
        return;
    }
    _count ++;
    NSTimeInterval delta = displayLink.timestamp - _lastTimestamp;//两次屏幕刷新的时间差(单位：秒)
    if (delta < 1) {
        return;
    }
    float fps = _count / delta;//计算当前的屏幕刷新频率（频率 = 次数 / 时间）
    _lastTimestamp = displayLink.timestamp;
    _count = 0;
    
    //更新UI
    self.text = [NSString stringWithFormat:@"%d",(int)roundf(fps)];
    float progress = fps / 60;
    self.textColor = [UIColor colorWithHue:(0.27*(progress-0.2)) saturation:1 brightness:1 alpha:1];
}


@end
