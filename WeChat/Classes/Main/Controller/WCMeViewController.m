//
//  WCMeViewController.m
//  WeChat
//
//  Created by 刘超 on 15/4/20.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import "WCMeViewController.h"
#import "AppDelegate.h"
#import "LCActionSheet.h"
#import "XMPPvCardTemp.h"

@interface WCMeViewController () <UIAlertViewDelegate, LCActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;

@end

@implementation WCMeViewController

- (void)dealloc {
    
    WCLog(@"%s", __func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.iconView.layer.cornerRadius = 4.0f;
    self.iconView.clipsToBounds = YES;
    
    XMPPvCardTemp *myvCard = [WCXMPPTool sharedWCXMPPTool].vCard.myvCardTemp;
    if (myvCard.photo) {
        self.iconView.image = [UIImage imageWithData:myvCard.photo];
    }
    self.nicknameLabel.text = myvCard.nickname;
    WCUserInfo *userInfo = [WCUserInfo sharedWCUserInfo];
    self.userLabel.text = [NSString stringWithFormat:@"账号：%@", userInfo.user];
}

- (IBAction)loginOut:(id)sender {
    
    if (IPAD) { // 当为iPad并且是iOS8以上系统时使用UIAlertController控件
        
        if (IOS8) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"你确定要注销吗？"
                                                                           message:nil
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"确定"
                                                                  style:UIAlertActionStyleDestructive
                                                                handler:^(UIAlertAction *action) {
                                                                    [alert dismissViewControllerAnimated:NO
                                                                                              completion:nil];
                                                                    [self actionSheet:nil didClickedButtonAtIndex:0];
                                                                }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction *action) {
                                                                     [alert dismissViewControllerAnimated:YES
                                                                                               completion:nil];
                                                                 }];
            
            [alert addAction:cancelAction];
            [alert addAction:firstAction];
            [self presentViewController:alert animated:YES completion:nil];

        } else {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"你确定要注销吗？"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
            [alert show];
        }

    } else {
        
        LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:@"你确定要注销吗？"
                                                       buttonTitles:@[@"确定"]
                                                     redButtonIndex:0
                                                           delegate:self];
        [sheet show];
    }
}

#pragma mark - WCActionView 代理方法

- (void)actionSheet:(LCActionSheet *)actionSheet didClickedButtonAtIndex:(int)buttonIndex {
    
    if (buttonIndex == 0) {
        
        [[WCXMPPTool sharedWCXMPPTool] xmppLogout];
        
        // 回到LoginViewController
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        [UIApplication sharedApplication].keyWindow.rootViewController = storyboard.instantiateInitialViewController;
    }
}

#pragma mark - UIAlertView 代理方法

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:NO];
    if (buttonIndex == 1) {
        [self actionSheet:nil didClickedButtonAtIndex:0];
    }
}

@end
