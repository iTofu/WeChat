//
//  WCMeViewController.m
//  WeChat
//
//  Created by 刘超 on 15/4/20.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import "WCMeViewController.h"
#import "AppDelegate.h"

@interface WCMeViewController () <UIActionSheetDelegate>

@end

@implementation WCMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)loginOut:(id)sender {
    
    if (IPAD && IOS8) { // 当为iPad并且是iOS8以上系统时使用UIAlertController控件
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"你确定要注销吗？"
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"确定"
                                                              style:UIAlertActionStyleDestructive
                                                            handler:^(UIAlertAction *action) {
                                                                [self loginOut];
                                                            }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action) {
                                                                 [alert dismissViewControllerAnimated:YES
                                                                                           completion:nil];
                                                             }];
        
        [alert addAction:firstAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];

    } else {
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"你确定要注销吗？"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:@"确定", @"取消", nil];
        sheet.destructiveButtonIndex = 0;
        [sheet showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
        [self loginOut];
    }
}

/** 确定退出 */
- (void)loginOut {
    
    [[WCUserInfo sharedWCUserInfo] setLogined:NO];
    [[WCUserInfo sharedWCUserInfo] saveUserInfoToSandbox];
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app xmppLogout];
}

@end
