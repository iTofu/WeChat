//
//  AppDelegate.h
//  WeChat
//
//  Created by 刘超 on 15/4/17.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    /** 登录成功 */
    XMPPResultTypeLoginSuccess,
    /** 登录失败 */
    XMPPResultTypeLoginFailure,
    /** 网络错误 */
    XMPPResultTypeNetError
}XMPPResultType;

/** XMPP的请求结果 */
typedef void (^XMPPResultBlock)(XMPPResultType type);

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/** 登录 */
- (void)xmppLogin:(XMPPResultBlock)reslutBlock;

/** 注销 */
- (void)xmppLogout;

@end

