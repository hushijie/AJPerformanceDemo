//
//  AJFloatingBallManager.m
//  AJPerformanceDemo
//
//  Created by 胡世结 on 2019/7/15.
//  Copyright © 2019 AJ. All rights reserved.
//

#import "AJFloatingBallManager.h"
#import "AJFileManagerTool.h"

@interface AJFloatingBallManager ()

@property (nonatomic, copy) NSString *consolePath;//控制台路径

@end

@implementation AJFloatingBallManager

+ (instancetype)shareManager {
    static AJFloatingBallManager *ballMgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ballMgr = [[AJFloatingBallManager alloc] init];
    });
    
    return ballMgr;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.canRuntime = NO;
    }
    return self;
}

// 将NSlog打印信息保存到Document目录下的文件中
- (void)redirectNSlogToDocumentFolder {
    // 如果已经连接Xcode调试则不输出到文件
    if(isatty(STDOUT_FILENO)) {
        return;
    }
    
    // 在模拟器不保存到文件中
    UIDevice *device = [UIDevice currentDevice];
    if([[device model] hasSuffix:@"Simulator"]){
        return;
    }
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    BOOL isON = [user objectForKey:@"AJPerformanceConsoleSwitch"];
    if (isON) {
        // freopen 重定向输出输出流，将log输入到文件
        freopen([self.consolePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
        freopen([self.consolePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
    }
}

- (NSString *)consolePath {
    if (!_consolePath) {
        // 每次启动后都保存一个新的日志文件中
        NSString *path = [AJFileManagerTool consolePath];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateStr = [formatter stringFromDate:[NSDate date]];
        _consolePath = [path stringByAppendingFormat:@"/%@.txt",dateStr];
    }
    return _consolePath;
}

@end
