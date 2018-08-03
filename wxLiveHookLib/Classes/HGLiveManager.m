//
//  HGLiveManager.m
//  iosPushAV
//
//  Created by jyh on 2018/7/31.
//  Copyright © 2018年 huig. All rights reserved.
//

#import "HGLiveManager.h"
#import "LFLiveKit/LFLiveKit.h"

@interface HGLiveManager()
@property (nonatomic, strong) LFLiveSession *liveSession;
@end

@implementation HGLiveManager

static HGLiveManager *_share;
+ (instancetype)share {
    if (!_share) {
        _share = [[self alloc] init];
    }
    return _share;
}
- (instancetype)init {
    if (self = [super init]) {
        LFLiveAudioConfiguration *audioConfig = [LFLiveAudioConfiguration defaultConfiguration];
        LFLiveVideoQuality videoQuality = LFLiveVideoQuality_Low1;
        LFLiveVideoConfiguration *aideoConfig = [LFLiveVideoConfiguration defaultConfigurationForQuality:videoQuality];
        self.liveSession = [[LFLiveSession alloc] initWithAudioConfiguration:audioConfig videoConfiguration:aideoConfig];
    }
    return self;
}

- (void)startRunning:(UIView *)preView rtmpAddress:(NSString *)rtmpAddress{
    
    NSLog(@"---------开启视频-----------");
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.liveSession.preView = preView;
        LFLiveStreamInfo *streamInfo = [LFLiveStreamInfo new];
        streamInfo.url = rtmpAddress;
        [self.liveSession startLive:streamInfo];
        self.liveSession.running = YES;
    });
}

- (void)rotateCamera {
    NSLog(@"换镜头");
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        AVCaptureDevicePosition position = self.liveSession.captureDevicePosition;
        self.liveSession.captureDevicePosition = position == AVCaptureDevicePositionBack?AVCaptureDevicePositionFront:AVCaptureDevicePositionBack;
     });
}

- (void)stopLive{
    NSLog(@"关闭视频");
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.liveSession.running = NO;
    });
}

@end
