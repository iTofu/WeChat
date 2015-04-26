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
    
    // 保存按钮
    UIButton *saveBtn = [[UIButton alloc] init];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:WCGreen forState:UIControlStateNormal];
    [saveBtn setTitleColor:WCColor(60, 210, 30) forState:UIControlStateHighlighted];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    saveBtn.frame = CGRectMake(0, 0, 60.0f, 44.0f);
    saveBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    saveBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 24.0f, 0, 0);
    [saveBtn addTarget:self action:@selector(savevCard) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    
    // 标题 内容
    self.title = self.cell.textLabel.text;
    self.textField.text = self.cell.detailTextLabel.text;
}

- (void)savevCard {
    
    self.cell.detailTextLabel.text = self.textField.text;
    [self.cell layoutSubviews];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self savevCard];
    
    return YES;
}

@end
