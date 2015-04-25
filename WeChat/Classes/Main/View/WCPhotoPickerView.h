//
//  WCPhotoPickerView.h
//  WeChat
//
//  Created by 刘超 on 15/4/25.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WCPhotoPickerView;

@protocol WCPhotoPickerViewDelegate <NSObject>

@optional

- (void)photoPickerViewSourceTypeCamera:(WCPhotoPickerView *)pickerView;
- (void)photoPickerViewSourceTypePhotoLibrary:(WCPhotoPickerView *)pickerView;
- (void)photoPickerViewDidClickCancelBtn:(WCPhotoPickerView *)pickerView;

@end

@interface WCPhotoPickerView : UIView

@property (nonatomic, weak) id<WCPhotoPickerViewDelegate> delegate;

/** 图片来源选择器 */
- (void)showPickerViewToView:(UIView *)view delegate:(id<WCPhotoPickerViewDelegate>)delegate;

@end
