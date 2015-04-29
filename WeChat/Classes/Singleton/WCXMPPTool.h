//
//  WCXMPPTool.h
//  WeChat
//
//  Created by 刘超 on 15/4/23.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "XMPPFramework.h"

typedef enum {
    /** 登录成功 */
    XMPPResultTypeLoginSuccess,
    /** 登录失败 */
    XMPPResultTypeLoginFailure,
    /** 网络错误 */
    XMPPResultTypeNetError,
    /** 注册成功 */
    XMPPResultTypeRegisterSuccess,
    /** 注册失败 */
    XMPPResultTypeRegisterFailure
}XMPPResultType;

/** XMPP的请求结果 */
typedef void (^XMPPResultBlock)(XMPPResultType type);


@interface WCXMPPTool : NSObject

singleton_interface(WCXMPPTool)


@property (nonatomic, strong) XMPPStream *xmppStream;
/** 名片\个人资料 */
@property (nonatomic, strong) XMPPvCardTempModule *vCard;
/** 花名册\好友 */
@property (nonatomic, strong) XMPPRoster *roster;
/** 花名册\好友 存储 */
@property (nonatomic, strong) XMPPRosterCoreDataStorage *rosterStorage;


/** 是否是注册 `YES`注册 `NO`登录 */
@property (nonatomic, assign, getter=isRegisterOperation) BOOL registerOperation;


/** 注册 */
- (void)xmppRegister:(XMPPResultBlock)resultBlock;
/** 登录 */
- (void)xmppLogin:(XMPPResultBlock)resultBlock;
/** 注销 */
- (void)xmppLogout;

@end
