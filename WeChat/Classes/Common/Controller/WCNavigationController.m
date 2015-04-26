//
//  WCNavigationController.m
//  WeChat
//
//  Created by 刘超 on 15/4/18.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import "WCNavigationController.h"

@interface WCNavigationController ()

@end

@implementation WCNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/** 设置导航栏主题 */
+ (void)setupNavTheme {
    
    // 导航栏背景
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBackgroundImage:[UIImage imageNamed:@"topbarbg_ios7"]
                                                  forBarMetrics:UIBarMetricsDefault];
//    navBar.translucent = NO;
    
    // 导航栏标题
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    dict[NSFontAttributeName] = [UIFont boldSystemFontOfSize:18.0f];
    [navBar setTitleTextAttributes:dict];
    // 导航栏按钮
    navBar.tintColor = [UIColor whiteColor];
    
    // 标签栏颜色
    UITabBar *tabBar = [UITabBar appearance];
    tabBar.tintColor = WCGreen;
    tabBar.barTintColor = WCColor(248, 248, 248);
    if (IOS8) {
        tabBar.translucent = NO;
    }
}

@end
