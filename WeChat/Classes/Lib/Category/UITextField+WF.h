//
//  UITextField+WF.h
//  WeiXin
//
//  Created by Yong Feng Guo on 14-11-21.
//  Copyright (c) 2014年 Fung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (WF)

/**
 添加文件输入框左边的View,添加图片
 */
-(void)addLeftViewWithImage:(NSString *)image;

/**
 * 判断是否为手机号码
 */
-(BOOL)isTelphoneNum;
@end
