//
//  HGLiveManager.h
//  iosPushAV
//
//  Created by jyh on 2018/7/31.
//  Copyright © 2018年 huig. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HGLiveManager : NSObject
- (nullable instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (nullable instancetype)new UNAVAILABLE_ATTRIBUTE;
+ (instancetype _Nullable )share;
- (void)startRunning:(UIView *_Nullable)preView rtmpAddress:(NSString *_Nullable)rtmpAddress;
- (void)rotateCamera;
- (void)stopLive;
@end
