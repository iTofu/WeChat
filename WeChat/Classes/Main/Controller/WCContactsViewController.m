//
//  WCContactsViewController.m
//  WeChat
//
//  Created by 刘超 on 15/4/29.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import "WCContactsViewController.h"
#import "WCContactCell.h"

@interface WCContactsViewController () <NSFetchedResultsControllerDelegate> {
    NSFetchedResultsController *_resultsController;
}

@end

@implementation WCContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self loadFriends];
}

- (void)loadFriends {
    
    // 使用CoreData获取数据
    // 1. 上下文【关联到数据库XMPPRoster.sqlite】
    NSManagedObjectContext *context = [WCXMPPTool sharedWCXMPPTool].rosterStorage.mainThreadManagedObjectContext;
    
    // 2. FetchRequest【查哪张表】
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
    
    // 3. 设置过滤和排序
    // 过滤当前登录用户的好友
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@", [WCUserInfo sharedWCUserInfo].JID];
    request.predicate = predicate;
    
    // 排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    request.sortDescriptors = @[sort];
    
    // 4. 执行请求获取数据
    _resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                             managedObjectContext:context
                                                               sectionNameKeyPath:nil
                                                                        cacheName:nil];
    _resultsController.delegate = self;
    
    NSError *error = nil;
    [_resultsController performFetch:&error];
    if (error) {
        WCLog(@"%@", error);
    }
}

#pragma mark - NSFetchedResultsControllerDelegate 方法

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _resultsController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"ContactCell";
    WCContactCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.frd = _resultsController.fetchedObjects[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        XMPPUserCoreDataStorageObject *friend = _resultsController.fetchedObjects[indexPath.row];
        [[WCXMPPTool sharedWCXMPPTool].roster removeUser:friend.jid];
    }
}

@end
