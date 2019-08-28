//
//  AJPerformanceView.m
//  AJPerformanceDemo
//
//  Created by 胡世结 on 2019/7/15.
//  Copyright © 2019 AJ. All rights reserved.
//

#import "AJPerformanceView.h"
#import "AJCpuUsage.h"
#import "AJAppMemory.h"
#import "AJFPSLabel.h"
#import "AJNetworkFlow.h"
#import "AJFloatingBall.h"
#import "AJWeakProxy.h"
#import "AJFileManagerTool.h"
#import "AJFloatingBallManager.h"

@interface AJPerformanceView ()

@property (nonatomic, weak) UILabel *cpuLab;
@property (nonatomic, weak) UILabel *memoryLab;
@property (nonatomic, weak) AJFPSLabel *fpsLab;
@property (nonatomic ,strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger samplingInterval;//取样时间间隔
@property (nonatomic, assign) NSInteger samplingCount;//记录距离上次取样的时间间隔
@property (nonatomic, copy) NSString *samplingFilePath;//取样文件路径

@end

@implementation AJPerformanceView

#pragma mark - Lazy Getter

- (NSString *)samplingFilePath {
    if (!_samplingFilePath) {
        // 每次启动后都保存一个新的日志文件中
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateStr = [formatter stringFromDate:[NSDate date]];
        _samplingFilePath = [[AJFileManagerTool samplingPath] stringByAppendingFormat:@"/%@.txt",dateStr];
    }
    return _samplingFilePath;
}

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化文件夹
        [AJFileManagerTool setupFile];
        //控制台日志写入沙盒文件中
        [[AJFloatingBallManager shareManager] redirectNSlogToDocumentFolder];
        
        self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.700];
        [self setupUI];
        
        __weak typeof(self) wkSelf = self;
        self.settingChangeBlock = ^{
            [wkSelf dealSettingChange];
        };
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        self.samplingInterval = [user integerForKey:@"AJPerformanceSamplingInterval"];
    }
    return self;
}

- (void)setupUI {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    CGFloat fpsStrX = width * 0.15;
    CGFloat fpsStrW = width - fpsStrX * 2;
    UILabel *fpsStrLab = [[UILabel alloc] initWithFrame:CGRectMake(fpsStrX, 0, fpsStrW, height)];
    fpsStrLab.textColor = [UIColor whiteColor];
    fpsStrLab.font = [UIFont systemFontOfSize:9];
    fpsStrLab.text = @"FPS";
    fpsStrLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:fpsStrLab];
    
    AJFPSLabel *fpsLab = [[AJFPSLabel alloc] initWithFrame:self.bounds];
    fpsLab.font = [UIFont systemFontOfSize:20];
    [self addSubview:fpsLab];
    self.fpsLab = fpsLab;
    
    CGFloat cpuH = height * 0.5;
    UILabel *cpuLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, cpuH)];
    cpuLab.textColor = [UIColor whiteColor];
    cpuLab.font = [UIFont systemFontOfSize:9];
    cpuLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:cpuLab];
    self.cpuLab = cpuLab;
    
    CGFloat memY = height - cpuH;
    UILabel *memoryLab = [[UILabel alloc] initWithFrame:CGRectMake(0, memY, width, cpuH)];
    memoryLab.textColor =cpuLab.textColor;
    memoryLab.font = cpuLab.font;
    memoryLab.textAlignment = cpuLab.textAlignment;
    [self addSubview:memoryLab];
    self.memoryLab = memoryLab;
    
    //每隔1s刷新UI
    _timer = [NSTimer timerWithTimeInterval:1.0
                                     target:[AJWeakProxy proxyWithTarget:self]
                                   selector:@selector(timerAction)
                                   userInfo:nil
                                    repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)timerAction {
    double cpu = [AJCpuUsage getCpuUsage];
    self.cpuLab.text = [NSString stringWithFormat:@"CPU: %.2f%%", cpu];
    
    double mem = [AJAppMemory getMemoryUsage];
    self.memoryLab.text = [NSString stringWithFormat:@"Mem: %.2f",mem];
    
    AJNetworkFlowModel *flowModel = nil;
    if (self.timerBlock) {
        flowModel = [AJNetworkFlow getNetworkFlowMonitorings];
        self.timerBlock(flowModel);
    }
    
    //记录取样数据
    if (!self.samplingInterval) {
        return;
    }
    self.samplingCount++;
    if (self.samplingCount >= self.samplingInterval) {
        self.samplingCount = 0;
        
        // 时间
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSS"]; //每次启动后都保存一个新的日志文件中
        NSString *dateStr = [formatter stringFromDate:[NSDate date]];
        
        // CPU
        NSString *cpuStr = self.cpuLab.text;
        
        // 内存
        NSString *memStr = [NSString stringWithFormat:@"内存: %.2fMB",mem];
        
        // FPS
        NSString *fpsStr = [NSString stringWithFormat:@"FPS：%@", self.fpsLab.text];
        
        // 电量
        [UIDevice currentDevice].batteryMonitoringEnabled = YES;
        double deviceLevel = [UIDevice currentDevice].batteryLevel;
        NSString *batteryStr = [NSString stringWithFormat:@"电量：%.2f", deviceLevel];
        
        // wifi流量
        if (!flowModel) {
            flowModel = [AJNetworkFlow getNetworkFlowMonitorings];
        }
        NSString *WiFitTotal =  [AJNetworkFlowModel convertBytes:flowModel.WiFiTotalTraffic];
        NSString *wifiStr = [NSString stringWithFormat:@"WiFi：%@",WiFitTotal];
        
        // 移动网络流量
        NSString *WWANTotal =  [AJNetworkFlowModel convertBytes:flowModel.WWANTotalTraffic];
        NSString *WWANStr = [NSString stringWithFormat:@"WWAN：%@",WWANTotal];
        
        // 拼接字符串
        NSArray *strArr = @[dateStr, cpuStr, fpsStr, memStr, batteryStr, wifiStr, WWANStr];
        NSMutableString *mutStr = [NSMutableString new];
        for (NSString *str in strArr) {
            [mutStr appendFormat:@"%@  ", str];
        }
        
        // 存储字符串
        NSString *samplingStr = [NSString stringWithFormat:@"%@\n", mutStr];
        [AJFileManagerTool writeSamplingSting:samplingStr filePath:self.samplingFilePath];
        NSLog(@"%@", samplingStr);
    }
}

- (void)dealSettingChange {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    self.samplingInterval = [user integerForKey:@"AJPerformanceSamplingInterval"];
}

@end
