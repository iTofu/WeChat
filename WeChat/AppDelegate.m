//
//  AppDelegate.m
//  WeChat
//
//  Created by 刘超 on 15/4/17.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import "AppDelegate.h"
#import "XMPPFramework.h"
#import "WCNavigationController.h"

/*
 *  在AppDelegate实现登录
 *
 *  1. 初始化XMPPStream
 *  2. 连接到服务器[传一个JID]
 *  3. 连接到服务成功后，再发送密码授权
 *  4. 授权成功后，发送`在线`消息
 */

@interface AppDelegate () <XMPPStreamDelegate> {
    XMPPStream *_xmppStream;
    XMPPResultBlock _resultBlock;
}

/** 初始化XMPPStream */
- (void)setupXMPPStream;
/** 连接到服务器[传一个JID] */
- (void)connectToHost;
/** 连接到服务成功后，再发送密码授权 */
- (void)sendPwdToHost;
/** 授权成功后，发送`在线`消息 */
- (void)sendOnlineToHost;

@end

@implementation AppDelegate

///** iPhone禁止旋转 iPad可以旋转 */
//- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
//    
//    if (!IPAD) {
//        return UIInterfaceOrientationMaskPortrait;
//    } else {
//        return UIInterfaceOrientationMaskAll;
//    }
//}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [WCNavigationController setupNavTheme];
    
    return YES;
}

#pragma mark - 登录流程
// 初始化XMPPStream
- (void)setupXMPPStream {
    
    _xmppStream = [[XMPPStream alloc] init];
    
    [_xmppStream addDelegate:self
               delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}

// 连接到服务器[传一个JID]
- (void)connectToHost {
    
    WCLog(@"开始连接服务器");
    
    if (!_xmppStream) {
        [self setupXMPPStream];
    }
    
    NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    
    XMPPJID *myJID = [XMPPJID jidWithUser:user domain:@"leo.local" resource:@"iPhone"];    // 用户JID
    _xmppStream.myJID = myJID;
    
    _xmppStream.hostName = @"leo.local";    // 域名
    _xmppStream.hostPort = 5222;            // 端口
    
    NSError *error = nil;
    [_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error];
    if (error) {
        WCLog(@"%@", error);
    }
}

// 连接到服务成功后，再发送密码授权
- (void)sendPwdToHost {
    
    WCLog(@"开始授权");
    
    NSString *pwd = [[NSUserDefaults standardUserDefaults] objectForKey:@"pwd"];
    
    NSError *error = nil;
    [_xmppStream authenticateWithPassword:pwd error:&error];
    if (error) {
        WCLog(@"%@", error);
    }
}

// 授权成功后，发送`在线`消息
- (void)sendOnlineToHost {
    
    WCLog(@"发送`在线`消息");
    
    XMPPPresence *online = [XMPPPresence presence];
    [_xmppStream sendElement:online];
}

#pragma mark - XMPPStreamDelegate 方法

- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    
    WCLog(@"连接服务器成功");
    
    [self sendPwdToHost];
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error {
    
    WCLog(@"与服务器断开连接--%@", error);
    
    if (_resultBlock && error) {
        _resultBlock(XMPPResultTypeNetError);
    }
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    
    WCLog(@"授权成功");
    
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeLoginSuccess);
    }
    
    [self sendOnlineToHost];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error {
    
    WCLog(@"授权失败--%@", error);
    
    [_xmppStream disconnect];
    
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeLoginFailure);
    }
}

- (void)xmppStream:(XMPPStream *)sender didFailToSendPresence:(XMPPPresence *)presence error:(NSError *)error {
    
    WCLog(@"发送`在线`消息失败");
}

#pragma mark - 登录 & 注销

- (void)xmppLogin:(XMPPResultBlock)reslutBlock {
    
    _resultBlock = reslutBlock;
    
    [_xmppStream disconnect];
    
    [self connectToHost];
}

- (void)xmppLogout {
    
    XMPPPresence *lineOut = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:lineOut];
    
    [_xmppStream disconnect];
}

@end