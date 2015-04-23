//
//  WCRegisterViewController.m
//  WeChat
//
//  Created by 刘超 on 15/4/21.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import "WCRegisterViewController.h"
#import "AppDelegate.h"

@interface WCRegisterViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *userBgView;
@property (weak, nonatomic) IBOutlet UIImageView *pwdBgView;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceConstraint;

@end

@implementation WCRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userBgView.image = [UIImage stretchedImageWithName:@"OtherLoginTop"];
    self.pwdBgView.image = [UIImage stretchedImageWithName:@"OtherLoginBtom"];
    
    [self.registerBtn setBackgroundImage:[UIImage stretchedImageWithName:@"GreenBigBtn"]
                             forState:UIControlStateNormal];
    [self.registerBtn setBackgroundImage:[UIImage stretchedImageWithName:@"GreenBigBtnHighlight"]
                             forState:UIControlStateHighlighted];
    [self.registerBtn setBackgroundImage:[UIImage stretchedImageWithName:@"GreenBigBtnDisable"]
                             forState:UIControlStateDisabled];
    
    if (!IPAD) {
        
        self.topConstraint.constant = 20.0f;
        self.leftConstraint.constant = 20.0f;
        self.rightConstraint.constant = 20.0f;
        self.distanceConstraint.constant = 10.0f;
    }
}

- (IBAction)fieldChanged {
    
    self.registerBtn.enabled = self.pwdField.text.length > 0 && self.userField.text.length > 0;
}

- (IBAction)dismiss:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

- (IBAction)userRegister {
    
    [self.view endEditing:YES];
    
    [LCProgressHUD showWaittingText:@"请稍候..."];
    
    
    WCUserInfo *userInfo = [WCUserInfo sharedWCUserInfo];
    userInfo.registerUser = self.userField.text;
    userInfo.registerPwd = self.pwdField.text;
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.registerOperation = YES;
    
    __weak typeof(self) selfVc = self;
    [app xmppLogin:^(XMPPResultType type) {
        
        [selfVc handleResultType:type];
    }];
}

- (void)handleResultType:(XMPPResultType)type {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [LCProgressHUD hide];
        
        switch (type) {
            case XMPPResultTypeRegisterSuccess:
                WCLog(@"注册成功");
                [self backToLastVC];
                break;
            case XMPPResultTypeRegisterFailure:
                WCLog(@"注册失败");
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

// 返回上一个控制器
- (void)backToLastVC {
    
    [self dismissViewControllerAnimated:YES completion:^{
        [LCProgressHUD showSuccessText:@"注册成功"];
    }];
    
    if ([self.delegate respondsToSelector:@selector(registerViewControllerDidRegisterSuccess:)]) {
        [self.delegate registerViewControllerDidRegisterSuccess:self];
    }
}

/** 提示注册失败 */
- (void)showLoginFailure {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"账号已存在，请重新填写。"
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

#pragma mark - UITextField 代理方法

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.userField) {
        
        [self.pwdField setText:nil];
        [self.pwdField becomeFirstResponder];
        
    } else {
        
        [self userRegister];
    }
    
    return YES;
}


@end
