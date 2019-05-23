//
//  XXTimeMonitor.h
//  Cutter
//
//  Created by xxg90s on 2019/5/23.
//  Copyright © 2019 AnTuan Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, XXTimeMonitorType) {
    XXTimeMonitorTypeMedian,    //Median time
    XXTimeMonitorTypeContinuous,//Continuous time
};

typedef NS_ENUM(NSUInteger, XXTimeMonitorDisplayType) {
    XXTimeMonitorDisplayTypeLog,
    XXTimeMonitorDisplayTypeAlert,
};

//XXTimeMonitorDisplayTypeLog且希望通过自己的log系统记录
@protocol XXTimeMonitorDelegate <NSObject>

@required
- (void)diplayMonitorResult:(NSString *)result;

@end

@interface XXTimeMonitor : NSObject

/**
 start timeMonitor

 @param displayType the log display way
 @param delegate callback result
 @param releaseEnable true for release enable
 */
+ (void)startWithDisplayType:(XXTimeMonitorDisplayType)displayType
                    delegate:(id<XXTimeMonitorDelegate> _Nullable)delegate
               releaseEnable:(BOOL)releaseEnable;

+ (void)splitTimeWithDescription:(NSString * _Nullable)description;

+ (void)splitTimeWithType:(XXTimeMonitorType)monitorType description:(NSString * _Nullable)description;

+ (void)stop;

@end

NS_ASSUME_NONNULL_END
