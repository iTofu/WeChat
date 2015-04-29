//
//  WCUserInfo.m
//  WeChat
//
//  Created by 刘超 on 15/4/20.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import "WCUserInfo.h"

#define UserKey @"user"
#define PwdKey @"pwd"
#define LoginedKey @"logined"

@implementation WCUserInfo

singleton_implementation(WCUserInfo)

- (void)saveUserInfoToSandbox {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.user forKey:UserKey];
    [defaults setObject:self.pwd forKey:PwdKey];
    [defaults setBool:self.isLogined forKey:LoginedKey];
    [defaults synchronize];
}

- (void)loadUserInfoToSandbox {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.user = [defaults objectForKey:UserKey];
    self.pwd = [defaults objectForKey:PwdKey];
    self.logined = [defaults boolForKey:LoginedKey];
}

- (NSString *)JID {
    
    return [NSString stringWithFormat:@"%@@%@", self.user, HOST_NAME];
}

@end
