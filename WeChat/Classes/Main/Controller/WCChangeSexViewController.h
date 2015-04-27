//
//  WCChangeSexViewController.h
//  WeChat
//
//  Created by 刘超 on 15/4/27.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import "WCTableViewController.h"

@class WCChangeSexViewController;

@protocol WCChangeSexViewControllerDelegate <NSObject>

@optional

- (void)changeSexViewController:(WCChangeSexViewController *)chanegeSexVc didSelectedAtIndex:(int)index;

@end

@interface WCChangeSexViewController : WCTableViewController

@property (nonatomic, strong) UITableViewCell *cell;

@property (nonatomic, weak) id<WCChangeSexViewControllerDelegate> delegate;

@end
