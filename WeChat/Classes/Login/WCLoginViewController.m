//
//  WCLoginViewController.m
//  WeChat
//
//  Created by 刘超 on 15/4/17.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import "WCLoginViewController.h"
#import "WCOtherLoginViewController.h"
#import "WCRegisterViewController.h"
#import "WCNavigationController.h"
#import "AppDelegate.h"

@interface WCLoginViewController () <UITextFieldDelegate, UIActionSheetDelegate, WCRegisterViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIImageView *pwdBgView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIView *midBgView;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@end

@implementation WCLoginViewController

- (void)dealloc {
    
    if (SCREEN_4) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    
    WCLog(@"%s", __func__);
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.userLabel.text = [WCUserInfo sharedWCUserInfo].user;
    
    self.pwdBgView.image = [UIImage stretchedImageWithName:@"operationbox_text"];
    
    [self.loginBtn setBackgroundImage:[UIImage stretchedImageWithName:@"GreenBigBtn"]
                             forState:UIControlStateNormal];
    [self.loginBtn setBackgroundImage:[UIImage stretchedImageWithName:@"GreenBigBtnHighlight"]
                             forState:UIControlStateHighlighted];
    [self.loginBtn setBackgroundImage:[UIImage stretchedImageWithName:@"GreenBigBtnDisable"]
                             forState:UIControlStateDisabled];
    [self.registerBtn setBackgroundImage:[UIImage stretchedImageWithName:@"operationbox_text"]
                                forState:UIControlStateNormal];
    
    if (SCREEN_3_5) {
        
        self.topConstraint.constant = 60.0f;
    }
    
    if (SCREEN_4) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(kbFrmWillChanged:)
                                                     name:UIKeyboardWillChangeFrameNotification
                                                   object:self.pwdField];
    }
}

- (IBAction)fieldChanged {
    
    self.loginBtn.enabled = self.pwdField.text.length > 0;
}

- (void)kbFrmWillChanged:(NSNotification *)not {
    
    CGFloat windowH = [UIScreen mainScreen].bounds.size.height;
    CGRect kbEndFrm = [not.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat kbEndY = kbEndFrm.origin.y;
    
    [UIView animateWithDuration:[not.userInfo[UIKeyboardAnimationCurveUserInfoKey] floatValue]
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         if (kbEndY != windowH) {
                             self.midBgView.transform = CGAffineTransformMakeTranslation(0, -90.0f);
                         } else {
                             self.midBgView.transform = CGAffineTransformIdentity;
                         }
                         
                     } completion:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self userLogin];
    
    return YES;
}

/** 即将进行Modal跳转时调用此方法 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    [self.view endEditing:YES];
    
    if ([segue.identifier isEqualToString:@"Register"]) {
        WCNavigationController *nav = segue.destinationViewController;
        WCRegisterViewController *registerVc = (WCRegisterViewController *)nav.topViewController;
        registerVc.delegate = self;
    }
}

/** 注册成功后调用此方法 */
- (void)registerViewControllerDidRegisterSuccess:(WCRegisterViewController *)registerVc {
    
    self.userLabel.text = [WCUserInfo sharedWCUserInfo].registerUser;
    self.pwdField.text = nil;
}

/** Modal推出其他登录方式控制器 */
- (void)presentOtherLoginViewController {
    
    UIStoryboard *login = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    WCOtherLoginViewController *otherLogin = [login instantiateViewControllerWithIdentifier:@"otherLogin"];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:otherLogin]
                       animated:YES
                     completion:nil];
}

#pragma mark - UIActionSheetDelegate 方法

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
        [self presentOtherLoginViewController];
        
    } else if (buttonIndex == 1) {
        
        [self presentOtherLoginViewController];
    }
}

#pragma mark - 用户登录

- (IBAction)userLogin {

    [self.view endEditing:YES];
    
    WCUserInfo *userInfo = [WCUserInfo sharedWCUserInfo];
    userInfo.user = self.userLabel.text;
    userInfo.pwd = self.pwdField.text;
    
    [super login];
}

@end
