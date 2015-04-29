//
//  WCContactCell.m
//  WeChat
//
//  Created by 刘超 on 15/4/29.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import "WCContactCell.h"

@interface WCContactCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation WCContactCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {}

- (void)setFrd:(XMPPUserCoreDataStorageObject *)frd {
    
    _frd = frd;
    
    if (frd.photo) {
        
        self.iconView.image = frd.photo;
    }
    self.nicknameLabel.text = frd.jidStr;
    /*
     sectionNum
     “0”- 在线
     “1”- 离开
     “2”- 离线
     */
    switch ([frd.sectionNum intValue]) {
        case 0:
            self.statusLabel.text = @"[在线]";
            break;
        case 1:
            self.statusLabel.text = @"[离开]";
            break;
        case 2:
            self.statusLabel.text = @"[离线]";
            break;
            
        default:
            break;
    }
}

@end
