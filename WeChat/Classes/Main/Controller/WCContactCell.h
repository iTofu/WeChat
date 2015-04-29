//
//  WCContactCell.h
//  WeChat
//
//  Created by 刘超 on 15/4/29.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCContactCell : UITableViewCell

/** XMPP中的好友模型 */
@property (nonatomic, strong) XMPPUserCoreDataStorageObject *frd;

@end
