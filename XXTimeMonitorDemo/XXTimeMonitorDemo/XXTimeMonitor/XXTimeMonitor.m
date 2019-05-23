//
//  XXTimeMonitor.m
//
//  Created by xxg90s on 2019/5/23.
//

#import "XXTimeMonitor.h"
#import "pthread.h"
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, XXTimeMonitorStatus) {
    XXTimeMonitorStatusRunning,
    XXTimeMonitorStatusClose,
};

@interface XXTimeMonitor ()

@property (nonatomic, assign) CFAbsoluteTime startTime;
@property (nonatomic, assign) CFAbsoluteTime medianTime;
@property (nonatomic, assign) CFAbsoluteTime stopTime;
@property (nonatomic, strong) NSMutableArray<NSDictionary<NSString *, NSNumber *> *> *splitsList;
@property (nonatomic, assign) pthread_mutex_t lock;
@property (nonatomic, assign) XXTimeMonitorStatus status;

@property (nonatomic, assign) XXTimeMonitorDisplayType displayType;
@property (nonatomic, weak) id<XXTimeMonitorDelegate> delegate;

@end

@implementation XXTimeMonitor

#pragma mark - Class Method
+ (instancetype)sharedMonitor {
    static XXTimeMonitor *timeMonitor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timeMonitor = [[XXTimeMonitor alloc] init];
    });
    return timeMonitor;
}

static bool isReleaseEnable = false;

+ (void)startWithDisplayType:(XXTimeMonitorDisplayType)displayType
                    delegate:(id<XXTimeMonitorDelegate> _Nullable)delegate
               releaseEnable:(BOOL)releaseEnable {
    isReleaseEnable = releaseEnable;
    
#ifdef DEBUG
    [[XXTimeMonitor sharedMonitor] start];
    [XXTimeMonitor sharedMonitor].displayType = displayType;
    [XXTimeMonitor sharedMonitor].delegate = delegate;
#else
    if (isReleaseEnable) {
        [[XXTimeMonitor sharedMonitor] start];
        [XXTimeMonitor sharedMonitor].displayType = displayType;
        [XXTimeMonitor sharedMonitor].delegate = delegate;
    }
#endif
    
}

+ (void)splitTimeWithDescription:(NSString * _Nullable)description {
#ifdef DEBUG
    [[XXTimeMonitor sharedMonitor] splitTimeWithDescription:description];
#else
    if (isReleaseEnable) {
        [[XXTimeMonitor sharedMonitor] splitTimeWithDescription:description];
    }
#endif
}

+ (void)splitTimeWithType:(XXTimeMonitorType)monitorType description:(NSString * _Nullable)description {
#ifdef DEBUG
    [[XXTimeMonitor sharedMonitor] splitTimeWithType:monitorType description:description];
#else
    if (isReleaseEnable) {
        [[XXTimeMonitor sharedMonitor] splitTimeWithType:monitorType description:description];
    }
#endif
}

+ (void)stop {
#ifdef DEBUG
    [[XXTimeMonitor sharedMonitor] stop];
#else
    if (isReleaseEnable) {
        [[XXTimeMonitor sharedMonitor] stop];
    }
#endif
}

#pragma mark - LifeStyle
- (instancetype)init {
    if (self = [super init]) {
        _splitsList = [[NSMutableArray alloc] init];
        _displayType = XXTimeMonitorDisplayTypeLog;
        pthread_mutex_init(&_lock, NULL);
    }
    return self;
}

- (void)dealloc {
    pthread_mutex_destroy(&_lock);
}

#pragma mark - Private Method
- (void)start {
    self.status = XXTimeMonitorStatusRunning;
    self.startTime = CFAbsoluteTimeGetCurrent();
    self.medianTime = self.startTime;
}

- (void)splitTimeWithDescription:(NSString * _Nullable)description {
    [self splitTimeWithType:XXTimeMonitorTypeMedian description:description];
}

- (void)splitTimeWithType:(XXTimeMonitorType)monitorType description:(NSString * _Nullable)description {
    
    if (_status != XXTimeMonitorStatusRunning) {
        return;
    }
    
    CFAbsoluteTime medianTime = CFAbsoluteTimeGetCurrent();
    CFAbsoluteTime time = monitorType == XXTimeMonitorTypeMedian ? medianTime - self.medianTime : medianTime - self.startTime;
    NSInteger index = self.splitsList.count + 1;
    NSString *recordStr = [NSString stringWithFormat:@"#%zd %@", index, description.length ? description : @""];
    pthread_mutex_lock(&_lock);
    [self.splitsList addObject:@{recordStr : @(time)}];
    pthread_mutex_unlock(&_lock);
    
    self.medianTime = medianTime;
}

- (void)stop {
    if (_status != XXTimeMonitorStatusRunning) {
        return;
    }
    
    self.stopTime = CFAbsoluteTimeGetCurrent();
    
    NSMutableString *outputStr = [[NSMutableString alloc] init];
    pthread_mutex_lock(&_lock);
    [self.splitsList enumerateObjectsUsingBlock:^(NSDictionary<NSString *, NSNumber *> *obj, NSUInteger idx, BOOL *stop) {
        [outputStr appendFormat:@"%@: %.3f\n", obj.allKeys.firstObject, obj.allValues.firstObject.doubleValue];
    }];
    pthread_mutex_unlock(&_lock);
    
    if (_displayType == XXTimeMonitorDisplayTypeLog) {
        if (self.delegate) {
            [self.delegate diplayMonitorResult:outputStr];
        } else {
            NSLog(@"\n==================时间监控结果==================\n%@ =============================================", outputStr);
        }
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [[[UIAlertView alloc] initWithTitle:@"时间监控结果"
                                    message:outputStr
                                   delegate:nil
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil] show];
#pragma clang diagnostic pop
    }
    
    [[XXTimeMonitor sharedMonitor] reset];
}

- (void)reset {
    pthread_mutex_lock(&_lock);
    [self.splitsList removeAllObjects];
    pthread_mutex_unlock(&_lock);
    self.startTime = 0;
    self.stopTime = 0;
    self.medianTime = 0;
    self.status = XXTimeMonitorStatusClose;
}

@end
