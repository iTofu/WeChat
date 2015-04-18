//
//  UIButton+WF.h
//  WeiXin
//
//  Created by Yong Feng Guo on 14-11-18.
//  Copyright (c) 2014年 Fung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (WF)

/**
 * 设置普通状态与高亮状态的背景图片
 */
-(void)setN_BG:(NSString *)nbg H_BG:(NSString *)hbg;

/**
 * 设置普通状态与高亮状态的拉伸后的背景图片
 */
-(void)setResizeN_BG:(NSString *)nbg H_BG:(NSString *)hbg;

@end
