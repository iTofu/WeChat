//
//  WCLoginViewController.m
//  WeChat
//
//  Created by 刘超 on 15/4/17.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import "WCLoginViewController.h"
#import "WCOtherLoginViewController.h"

@interface WCLoginViewController () <UITextFieldDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIImageView *pwdBgView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIView *midBgView;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@end

@implementation WCLoginViewController

- (void)dealloc {
    
    if (SCREEN_4) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.pwdBgView.image = [UIImage stretchedImageWithName:@"operationbox_text"];
    
    [self.loginBtn setBackgroundImage:[UIImage stretchedImageWithName:@"fts_green_btn"]
                             forState:UIControlStateNormal];
    [self.loginBtn setBackgroundImage:[UIImage stretchedImageWithName:@"fts_green_btn_HL"]
                             forState:UIControlStateHighlighted];
    [self.registerBtn setBackgroundImage:[UIImage stretchedImageWithName:@"operationbox_text"]
                                forState:UIControlStateNormal];
    
    if (SCREEN_3_5) {
        
        self.topConstraint.constant = 60.0f;
    }
    
    if (SCREEN_4) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(kbFrmWillChanged:)
                                                     name:UIKeyboardWillChangeFrameNotification
                                                   object:nil];
    }
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self userLogin];
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

- (IBAction)changeAccount {
    
    [self.view endEditing:YES];
    
    if (!IPAD) {
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:@"手机号", @"微信号/邮箱地址/QQ号", nil];
        sheet.actionSheetStyle = UIActionSheetStyleDefault;
        [sheet showInView:self.view];
        
    } else {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"手机号"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction *action) {
                                                                
                                                                [self presentOtherLoginViewController];
                                                                
                                                            }];
        UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"微信号/邮箱地址/QQ号"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action) {
                                                                 
                                                                 [self presentOtherLoginViewController];
                                                             }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                               style:UIAlertActionStyleDestructive
                                                             handler:^(UIAlertAction *action) {
                                                                 
                                                                 [alertController dismissViewControllerAnimated:YES completion:nil];
                                                             }];
        
        [alertController addAction:firstAction];
        [alertController addAction:secondAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
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
    
    [LCProgressHUD showWaittingText:@"请稍候..."];
    
    [NSTimer scheduledTimerWithTimeInterval:2.0f
                                     target:self
                                   selector:@selector(showInfo)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)showInfo {
    
    [LCProgressHUD hide];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请使用其他登录方式。"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"确定", nil];
    [alert show];
}

@end