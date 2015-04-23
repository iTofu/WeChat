//
//  WCActionView.h
//  WeChat
//
//  Created by 刘超 on 15/4/23.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WCActionView;

@protocol WCActionViewDelegate <NSObject>

@optional

- (void)actionViewDidClickOkBtn:(WCActionView *)actionView;
- (void)actionViewDidClickCancelBtn:(WCActionView *)actionView;

@end

@interface WCActionView : UIView

@property (nonatomic, weak) id<WCActionViewDelegate> delegate;

/** 注销登录警告框 */
- (void)showWarningToView:(UIView *)view delegate:(id<WCActionViewDelegate>)delegate;

@end
