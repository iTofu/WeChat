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
    
    [self.loginBtn setBackgroundImage:[UIImage stretchedImageWithName:@"fts_green_btn"]
                             forState:UIControlStateNormal];
    [self.loginBtn setBackgroundImage:[UIImage stretchedImageWithName:@"fts_green_btn_HL"]
                             forState:UIControlStateHighlighted];
    
    if (!IPAD) {
        
        self.topConstraint.constant = 20.0f;
        self.leftConstraint.constant = 20.0f;
        self.rightConstraint.constant = 20.0f;
        self.distanceConstraint.constant = 10.0f;
    }
}

- (IBAction)dismiss:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

/** 用户登录 */
- (IBAction)userLogin {
    
    [self.view endEditing:YES];
    
    [LCProgressHUD showWaittingText:@"请稍候..."];
    
    
    NSString *user = self.userField.text;
    NSString *pwd = self.pwdField.text;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:user forKey:@"user"];
    [defaults setObject:pwd forKey:@"pwd"];
    [defaults synchronize];
    
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
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
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
