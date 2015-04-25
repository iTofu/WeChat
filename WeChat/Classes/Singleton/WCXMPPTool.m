//
//  WCXMPPTool.m
//  WeChat
//
//  Created by 刘超 on 15/4/23.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import "WCXMPPTool.h"

/*
 *  在AppDelegate实现登录
 *
 *  1. 初始化XMPPStream
 *  2. 连接到服务器[传一个JID]
 *  3. 连接到服务成功后，再发送密码授权
 *  4. 授权成功后，发送`在线`消息
 */

@interface WCXMPPTool () <XMPPStreamDelegate> {
    XMPPStream *_xmppStream;
    XMPPResultBlock _resultBlock;
    XMPPvCardCoreDataStorage *_vCardStorage;
    XMPPvCardAvatarModule *_vCardAvatar;
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

@implementation WCXMPPTool

singleton_implementation(WCXMPPTool)


#pragma mark - 登录流程
#pragma mark 初始化XMPPStream
- (void)setupXMPPStream {
    
    _xmppStream = [[XMPPStream alloc] init];
    
    
    // 设置名片和头像
    _vCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    _vCard = [[XMPPvCardTempModule alloc] initWithvCardStorage:_vCardStorage];
    [_vCard activate:_xmppStream];
    
    _vCardAvatar = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:_vCard];
    [_vCardAvatar activate:_xmppStream];
    
    
    [_xmppStream addDelegate:self
               delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}

#pragma mark 连接到服务器[传一个JID]
- (void)connectToHost {
    
    WCLog(@"开始连接服务器");
    
    if (!_xmppStream) {
        [self setupXMPPStream];
    }
    
    NSString *user = nil;
    if (self.isRegisterOperation) {    // 注册账号
        user = [WCUserInfo sharedWCUserInfo].registerUser;
    } else {                                                    // 登录账号
        user = [WCUserInfo sharedWCUserInfo].user;
    }
    
    XMPPJID *myJID = [XMPPJID jidWithUser:user domain:@"115.28.243.22" resource:@"iPhone"];    // 用户JID
    _xmppStream.myJID = myJID;
    
    _xmppStream.hostName = @"115.28.243.22";    // 域名
    _xmppStream.hostPort = 5222;                // 端口
    
    NSError *error = nil;
    [_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error];
    if (error) {
        WCLog(@"%@", error);
    }
}

#pragma mark 连接到服务成功后，再发送密码注册
- (void)sendPwdToHostRegister {
    
    WCLog(@"开始注册");
    NSString *pwd = [WCUserInfo sharedWCUserInfo].registerPwd;
    
    NSError *error = nil;
    [_xmppStream registerWithPassword:pwd error:&error];
    if (error) {
        WCLog(@"%@", error);
    }
}

#pragma mark 连接到服务成功后，再发送密码授权
- (void)sendPwdToHost {
    
    WCLog(@"开始授权");
    NSString *pwd = [WCUserInfo sharedWCUserInfo].pwd;
    
    NSError *error = nil;
    [_xmppStream authenticateWithPassword:pwd error:&error];
    if (error) {
        WCLog(@"%@", error);
    }
}

#pragma mark 授权成功后，发送`在线`消息
- (void)sendOnlineToHost {
    
    WCLog(@"发送`在线`消息");
    
    XMPPPresence *presence = [XMPPPresence presence];
    [_xmppStream sendElement:presence];
    
    WCLog(@"%@", presence);
}

#pragma mark - XMPPStreamDelegate 方法
#pragma mark 连接服务器成功
- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    
    WCLog(@"连接服务器成功");
    
    if (self.isRegisterOperation) {    // 注册
        [self sendPwdToHostRegister];
    } else {
        [self sendPwdToHost];                                   // 登录
    }
    
}

#pragma mark 与服务器断开连接
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error {
    
    WCLog(@"与服务器断开连接--%@", error);
    
    if (_resultBlock && error) {
        _resultBlock(XMPPResultTypeNetError);
    }
}

#pragma mark 授权成功
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    
    WCLog(@"授权成功");
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeLoginSuccess);
    }
    
    // 发送`在线`消息
    [self sendOnlineToHost];
}

#pragma mark 授权失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error {
    
    [_xmppStream disconnect];
    
    WCLog(@"授权失败--%@", error);
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeLoginFailure);
    }
}

#pragma mark 注册成功
- (void)xmppStreamDidRegister:(XMPPStream *)sender {
    
    WCLog(@"注册成功");
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeRegisterSuccess);
    }
}

#pragma mark 注册失败
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error {
    
    WCLog(@"注册失败--%@", error);
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeRegisterFailure);
    }
}

#pragma mark 发送`在线`消息失败
- (void)xmppStream:(XMPPStream *)sender didFailToSendPresence:(XMPPPresence *)presence error:(NSError *)error {
    
    WCLog(@"发送`在线`消息失败");
}

#pragma mark - 注册 & 登录 & 注销
#pragma mark 注册
- (void)xmppRegister:(XMPPResultBlock)resultBlock {
    
    _resultBlock = resultBlock;
    
    [_xmppStream disconnect];
    
    [self connectToHost];
}

#pragma mark 登录
- (void)xmppLogin:(XMPPResultBlock)resultBlock {
    
    _resultBlock = resultBlock;
    
    [_xmppStream disconnect];
    
    [self connectToHost];
}

#pragma mark 注销
- (void)xmppLogout {
    
    XMPPPresence *lineOut = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:lineOut];
    
    [_xmppStream disconnect];
    
    [[WCUserInfo sharedWCUserInfo] setLogined:NO];
    [[WCUserInfo sharedWCUserInfo] saveUserInfoToSandbox];
}

@end
