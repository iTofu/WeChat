//
//  WCOtherLoginViewController.m
//  WeChat
//
//  Created by 刘超 on 15/4/17.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import "WCOtherLoginViewController.h"
#import "AppDelegate.h"

@interface WCOtherLoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *userBgView;
@property (weak, nonatomic) IBOutlet UIImageView *pwdBgView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceConstraint;

@end

@implementation WCOtherLoginViewController

- (void)dealloc {
    
    WCLog(@"%s", __func__);
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.userBgView.image = [UIImage stretchedImageWithName:@"OtherLoginTop"];
    self.pwdBgView.image = [UIImage stretchedImageWithName:@"OtherLoginBtom"];
    
    [self.loginBtn setBackgroundImage:[UIImage stretchedImageWithName:@"GreenBigBtn"]
                             forState:UIControlStateNormal];
    [self.loginBtn setBackgroundImage:[UIImage stretchedImageWithName:@"GreenBigBtnHighlight"]
                             forState:UIControlStateHighlighted];
    [self.loginBtn setBackgroundImage:[UIImage stretchedImageWithName:@"GreenBigBtnDisable"]
                             forState:UIControlStateDisabled];
    
    if (!IPAD) {
        
        self.topConstraint.constant = 20.0f;
        self.leftConstraint.constant = 20.0f;
        self.rightConstraint.constant = 20.0f;
        self.distanceConstraint.constant = 10.0f;
    }
    
    [self.userField addTarget:self action:@selector(fieldChanged) forControlEvents:UIControlEventEditingChanged];
    [self.pwdField addTarget:self action:@selector(fieldChanged) forControlEvents:UIControlEventEditingChanged];
}

- (void)fieldChanged {
    
    self.loginBtn.enabled = self.pwdField.text.length > 0 && self.userField.text.length > 0;
}

- (IBAction)dismiss:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

#pragma mark - 用户登录

- (IBAction)userLogin {
    
    // 保存用户信息
    WCUserInfo *userInfo = [WCUserInfo sharedWCUserInfo];
    userInfo.user = self.userField.text;
    userInfo.pwd = self.pwdField.text;
    
    
    [super login];
}

#pragma mark - UITextField 代理方法

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.userField) {
        
        [self.pwdField setText:nil];
        [self.pwdField becomeFirstResponder];
        
    } else {
        
        [self userLogin];
    }
    
    return YES;
}

@end
