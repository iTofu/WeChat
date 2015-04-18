//
//  UIButton+WF.m
//  WeiXin
//
//  Created by Yong Feng Guo on 14-11-18.
//  Copyright (c) 2014年 Fung. All rights reserved.
//

#import "UIButton+WF.h"
#import "UIImage+WF.h"

@implementation UIButton (WF)

-(void)setN_BG:(NSString *)nbg H_BG:(NSString *)hbg{
    [self setBackgroundImage:[UIImage imageNamed:nbg]
                    forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:hbg]
                    forState:UIControlStateHighlighted];
}

- (void)setResizeN_BG:(NSString *)nbg H_BG:(NSString *)hbg {
    [self setBackgroundImage:[UIImage stretchedImageWithName:nbg]
                    forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage stretchedImageWithName:hbg]
                    forState:UIControlStateHighlighted];
}

@end
