//
//  WCActionView.m
//  WeChat
//
//  Created by 刘超 on 15/4/23.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import "WCActionView.h"

#define BtnH 44.0f

@interface WCActionView () {
    UIView *_bgView;
    UIView *_bottomView;
}

@end

@implementation WCActionView

- (void)showWarningToView:(UIView *)view delegate:(id<WCActionViewDelegate>)delegate {
    
    _delegate = delegate;
    
    if (_bgView) {
        [_bgView removeFromSuperview];
    }
    
    UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
    bgView.backgroundColor = WCBlack;
    bgView.alpha = 0.2;
    [self addSubview:bgView];
    _bgView = bgView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
    [_bgView addGestureRecognizer:tap];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = WCColor(214, 214, 222);
    CGFloat bottomW = view.bounds.size.width;
    CGFloat bottomH = 44 * 3 + 5.0f;
    CGFloat bottomY = self.bounds.size.height;
    bottomView.frame = CGRectMake(0, bottomY, bottomW, bottomH);
    [self addSubview:bottomView];
    _bottomView = bottomView;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"你确定要注销吗？";
    label.font = [UIFont systemFontOfSize:13.0f];
    label.textColor = WCDark;
    label.backgroundColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:label];
    label.frame = CGRectMake(0, 0, bottomW, BtnH);
    
    UIButton *okBtn = [[UIButton alloc] init];
    okBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    okBtn.backgroundColor = [UIColor whiteColor];
    [okBtn setTitle:@"注销登录" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [okBtn addTarget:self action:@selector(didClickOkBtn) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:okBtn];
    okBtn.frame = CGRectMake(0, BtnH, bottomW, BtnH);
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    cancelBtn.backgroundColor = [UIColor whiteColor];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:WCBlack forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(didClickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:cancelBtn];
    cancelBtn.frame = CGRectMake(0, BtnH * 2 + 5.0f, bottomW, BtnH);
    
    UIImageView *line = [[UIImageView alloc] init];
    line.image = [UIImage imageNamed:@"cellLine"];
    line.contentMode = UIViewContentModeCenter;
    line.frame = CGRectMake(0, BtnH, bottomW, 1.0f);
    [bottomView addSubview:line];
    
    
    [UIView animateWithDuration:0.4f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         _bgView.alpha = 0.4f;
                         _bgView.userInteractionEnabled = YES;
                         CGFloat bottomW = view.bounds.size.width;
                         CGFloat bottomH = 44 * 3 + 5.0f;
                         CGFloat bottomY = self.bounds.size.height - bottomH;
                         bottomView.frame = CGRectMake(0, bottomY, bottomW, bottomH);
                         
                     } completion:nil];
}

- (void)dismiss:(UITapGestureRecognizer *)tap {
    
    [self didClickCancelBtn];
}

- (void)didClickOkBtn{
    
    if ([self.delegate respondsToSelector:@selector(actionViewDidClickOkBtn:)]) {
        [self.delegate actionViewDidClickOkBtn:self];
    }
}

- (void)didClickCancelBtn {
    
    [UIView animateWithDuration:0.4f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         _bgView.alpha = 0;
                         _bgView.userInteractionEnabled = NO;
                         CGFloat bottomW = self.bounds.size.width;
                         CGFloat bottomH = 44 * 3 + 5.0f;
                         CGFloat bottomY = self.bounds.size.height;
                         _bottomView.frame = CGRectMake(0, bottomY, bottomW, bottomH);
                         
                     } completion:^(BOOL finished) {
                         
                         [self removeFromSuperview];
                         if ([self.delegate respondsToSelector:@selector(actionViewDidClickCancelBtn:)]) {
                             [self.delegate actionViewDidClickCancelBtn:self];
                         }
                     }];
}

- (void)dealloc {
    
    WCLog(@"%s", __func__);
}

@end
