//
//  WCBaseLoginViewController.m
//  WeChat
//
//  Created by 刘超 on 15/4/20.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import "WCBaseLoginViewController.h"
#import "AppDelegate.h"

@interface WCBaseLoginViewController ()

@end

@implementation WCBaseLoginViewController

- (void)login {
    
    [self.view endEditing:YES];
    
    [LCProgressHUD showWaittingText:@"请稍候..."];
    
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    __weak typeof(self) selfVc = self;
    [app xmppLogin:^(XMPPResultType type) {
        
        [selfVc handleResultType:type];
    }];
}

/** 根据登录结果刷新UI */
- (void)handleResultType:(XMPPResultType)type {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [LCProgressHUD hide];
        
        switch (type) {
            case XMPPResultTypeLoginSuccess:
                WCLog(@"登录成功");
                [self enterMainPage];
                break;
            case XMPPResultTypeLoginFailure:
                WCLog(@"登录失败");
                [self showLoginFailure];
                break;
            case XMPPResultTypeNetError:
                WCLog(@"网络错误");
                [self showNetError];
                break;
                
            default:
                break;
        };
    });
}

/** 进入主界面 */
- (void)enterMainPage {
    
    [[WCUserInfo sharedWCUserInfo] setLogined:YES];
    [[WCUserInfo sharedWCUserInfo] saveUserInfoToSandbox];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.view.window.rootViewController = storyboard.instantiateInitialViewController;
}

/** 提示登录失败 */
- (void)showLoginFailure {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"账号或密码错误，请重新填写。"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"确定", nil];
    [alert show];
}

/** 提示网络错误 */
- (void)showNetError {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"连接失败，请检查你的网络设置。"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"确定", nil];
    [alert show];
}


@end
