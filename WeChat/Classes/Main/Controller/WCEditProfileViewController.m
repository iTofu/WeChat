//
//  WCEditProfileViewController.m
//  WeChat
//
//  Created by 刘超 on 15/4/25.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import "WCEditProfileViewController.h"
#import "XMPPvCardTemp.h"

@interface WCEditProfileViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation WCEditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 标题 内容
    self.title = self.cell.textLabel.text;
    self.textField.text = self.cell.detailTextLabel.text;
    
    // 保存按钮
    UIBarButtonItem *savevCardBtn = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(savevCard)];
    savevCardBtn.tintColor = WCGreen;
    self.navigationItem.rightBarButtonItem = savevCardBtn;
}

- (void)savevCard {
    
    self.cell.detailTextLabel.text = self.textField.text;
    
    if ([self.delegate respondsToSelector:@selector(editProfileViewControllerDidSaved:)]) {
        [self.delegate editProfileViewControllerDidSaved:self];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self savevCard];
    
    return YES;
}

@end
