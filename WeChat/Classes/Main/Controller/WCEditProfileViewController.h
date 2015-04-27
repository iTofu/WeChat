//
//  WCEditProfileViewController.h
//  WeChat
//
//  Created by 刘超 on 15/4/25.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WCEditProfileViewController;

@protocol WCEditProfileViewControllerDelegate <NSObject>

@optional

- (void)editProfileViewControllerDidSaved:(WCEditProfileViewController *)editProfileVc;

@end

@interface WCEditProfileViewController : WCTableViewController

@property (nonatomic, strong) UITableViewCell *cell;

@property (nonatomic, weak) id<WCEditProfileViewControllerDelegate> delegate;

@end
