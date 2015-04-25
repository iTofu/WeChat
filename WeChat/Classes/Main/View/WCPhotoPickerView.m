//
//  WCPhotoPickerView.m
//  WeChat
//
//  Created by 刘超 on 15/4/25.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import "WCPhotoPickerView.h"

#define BtnH 44.0f

@interface WCPhotoPickerView () {
    UIView *_bgView;
    UIView *_bottomView;
}

@end

@implementation WCPhotoPickerView

- (void)showPickerViewToView:(UIView *)view delegate:(id<WCPhotoPickerViewDelegate>)delegate {
    
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
    
    // 拍照
    UIButton *cameraBtn = [[UIButton alloc] init];
    cameraBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    cameraBtn.backgroundColor = [UIColor whiteColor];
    [cameraBtn setTitle:@"拍照" forState:UIControlStateNormal];
    [cameraBtn setTitleColor:WCBlack forState:UIControlStateNormal];
    [cameraBtn setTitleColor:WCColor(150, 150, 150) forState:UIControlStateHighlighted];
    [cameraBtn addTarget:self action:@selector(didClickCameraBtn) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:cameraBtn];
    cameraBtn.frame = CGRectMake(0, 0, bottomW, BtnH);
    
    // 从手机相册选择
    UIButton *photoLibraryBtn = [[UIButton alloc] init];
    photoLibraryBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    photoLibraryBtn.backgroundColor = [UIColor whiteColor];
    [photoLibraryBtn setTitle:@"从手机相册选择" forState:UIControlStateNormal];
    [photoLibraryBtn setTitleColor:WCBlack forState:UIControlStateNormal];
    [photoLibraryBtn setTitleColor:WCColor(150, 150, 150) forState:UIControlStateHighlighted];
    [photoLibraryBtn addTarget:self action:@selector(didClickPhotoLibraryBtn) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:photoLibraryBtn];
    photoLibraryBtn.frame = CGRectMake(0, BtnH, bottomW, BtnH);
    
    // 取消
    UIButton *cancelBtn = [[UIButton alloc] init];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    cancelBtn.backgroundColor = [UIColor whiteColor];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:WCBlack forState:UIControlStateNormal];
    [cancelBtn setTitleColor:WCColor(150, 150, 150) forState:UIControlStateHighlighted];
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

- (void)didClickCameraBtn {
    
    [self didClickCancelBtn];
    if ([self.delegate respondsToSelector:@selector(photoPickerViewSourceTypeCamera:)]) {
        [self.delegate photoPickerViewSourceTypeCamera:self];
    }
}

- (void)didClickPhotoLibraryBtn{
    
    [self didClickCancelBtn];
    if ([self.delegate respondsToSelector:@selector(photoPickerViewSourceTypePhotoLibrary:)]) {
        [self.delegate photoPickerViewSourceTypePhotoLibrary:self];
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
                         if ([self.delegate respondsToSelector:@selector(photoPickerViewDidClickCancelBtn:)]) {
                             [self.delegate photoPickerViewDidClickCancelBtn:self];
                         }
                     }];
}

- (void)dealloc {
    
    WCLog(@"%s", __func__);
}

@end
