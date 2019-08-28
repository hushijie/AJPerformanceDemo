//
//  AJAppMemory.m
//  AJPerformanceDemo
//
//  Created by 胡世结 on 2019/7/12.
//  Copyright © 2019 AJ. All rights reserved.
//

#import "AJAppMemory.h"
#import <mach/mach.h>
#import <mach/task_info.h>

@implementation AJAppMemory

/// 获取当前应用的内存占用情况，和Xcode数值相差较大（一般不使用）
+ (double)getResidentMemory {
    struct mach_task_basic_info info;
    mach_msg_type_number_t count = MACH_TASK_BASIC_INFO_COUNT;
    
    /*
     mach_task_self()：表示获取当前的 Mach task
     MACH_TASK_BASIC_INFO： Mach task 基本信息类型
     info：存放基本信息数据
     count：个数
     */
    kern_return_t kernelReturn = task_info(mach_task_self(),
                                           MACH_TASK_BASIC_INFO,
                                           (task_info_t)&info,
                                           &count);
    
    if (kernelReturn == KERN_SUCCESS) {
        // 获取使用的物理内存大小
        return info.resident_size / (1024 * 1024);
    } else {
        return -1.0;
    }
}

/// 获取当前应用的内存占用情况，和Xcode数值相近
+ (double)getMemoryUsage {
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    
    kern_return_t kernelReturn = task_info(mach_task_self(),
                                           TASK_VM_INFO,
                                           (task_info_t)&vmInfo,
                                           &count);
    
    if(kernelReturn == KERN_SUCCESS) {
        return (double)vmInfo.phys_footprint / (1024 * 1024);
    } else {
        return -1.0;
    }
}

@end
