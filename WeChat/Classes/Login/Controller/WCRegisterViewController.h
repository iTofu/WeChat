//
//  WCRegisterViewController.h
//  WeChat
//
//  Created by 刘超 on 15/4/21.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WCRegisterViewController;

@protocol WCRegisterViewControllerDelegate <NSObject>

@optional

- (void)registerViewControllerDidRegisterSuccess:(WCRegisterViewController *)registerVc;

@end

@interface WCRegisterViewController : UIViewController

@property (nonatomic, weak) id<WCRegisterViewControllerDelegate> delegate;

@end
