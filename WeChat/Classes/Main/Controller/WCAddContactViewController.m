//
//  WCAddContactViewController.m
//  WeChat
//
//  Created by 刘超 on 15/4/29.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import "WCAddContactViewController.h"

@interface WCAddContactViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation WCAddContactViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.textField becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加朋友";
    
    UIImageView *searchIcon = [[UIImageView alloc] init];
    searchIcon.image = [UIImage imageNamed:@"add_friend_searchicon"];
    searchIcon.contentMode = UIViewContentModeCenter;
    searchIcon.frame = CGRectMake(0, 0, 44.0f, 44.0f);
    self.textField.leftView = searchIcon;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    
    NSString *friendStr = self.textField.text;
    
    if (friendStr.length == 0) {
        
        [self showMessage:@"请输入朋友的账号。"];
        return YES;
    }
    if ([friendStr isEqualToString:[WCUserInfo sharedWCUserInfo].user]) {
        
        [self showMessage:@"你一直在自己身边:)"];
        return YES;
    }
    
    XMPPJID *friendJID = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@", friendStr, HOST_NAME]];
    
    if ([[WCXMPPTool sharedWCXMPPTool].rosterStorage userExistsWithJID:friendJID
                                                            xmppStream:[WCXMPPTool sharedWCXMPPTool].xmppStream]) {
        
        [self showMessage:@"已经添加过这个朋友。"];
        return YES;
    }
    
    [[WCXMPPTool sharedWCXMPPTool].roster subscribePresenceToUser:friendJID];
    
    [LCProgressHUD showSuccessText:@"发送成功"];
    [self.navigationController popViewControllerAnimated:YES];
    
    return YES;
}

/** 显示提示信息 */
- (void)showMessage:(NSString *)message {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
