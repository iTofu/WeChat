//
//  WCProfileViewController.m
//  WeChat
//
//  Created by 刘超 on 15/4/24.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import "WCProfileViewController.h"
#import "XMPPvCardTemp.h"
#import "LCActionSheet.h"
#import "WCEditProfileViewController.h"
#import "WCChangeSexViewController.h"

@interface WCProfileViewController () <UIAlertViewDelegate, LCActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, WCEditProfileViewControllerDelegate, WCChangeSexViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;

@property (weak, nonatomic) IBOutlet UILabel *orgnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *orgunitLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;

@end

@implementation WCProfileViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人信息";
    
    [self loadvCard];
}

- (void)loadvCard {
    
    XMPPvCardTemp *myvCard = [WCXMPPTool sharedWCXMPPTool].vCard.myvCardTemp;
    
    self.iconView.layer.cornerRadius = 4.0f;
    self.iconView.clipsToBounds = YES;
    
    if (myvCard.photo) {
        self.iconView.image = [UIImage imageWithData:myvCard.photo];
    }
    self.nicknameLabel.text = myvCard.nickname;
    self.userLabel.text = [WCUserInfo sharedWCUserInfo].user;
    self.orgnameLabel.text = myvCard.orgName;
    if (myvCard.orgUnits.count) {
        self.orgunitLabel.text = [myvCard.orgUnits firstObject];
    }
    self.titleLabel.text = myvCard.title;
    self.phoneLabel.text = myvCard.note;
    self.emailLabel.text = myvCard.mailer;
    self.sexLabel.text = myvCard.sex;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    id desVc = segue.destinationViewController;
    
    if ([segue.identifier isEqualToString:@"ChangeSexSegue"]) {
        
        WCChangeSexViewController *changeSexVc = desVc;
        changeSexVc.cell = sender;
        changeSexVc.delegate = self;
        
    } else {
        
        if ([desVc isKindOfClass:[WCEditProfileViewController class]]) {
            
            WCEditProfileViewController *editVc = desVc;
            editVc.cell = sender;
            editVc.delegate = self;
        }
    }
}

#pragma mark - UITableView 代理方法

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.tag == 2) {        // 照片
        
        if (IPAD) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"拍照", @"从手机相册选择", nil];
            [alert show];
            
        } else {
            
            LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil
                                                           buttonTitles:@[@"拍照", @"从手机相册选择"]
                                                         redButtonIndex:-1
                                                               delegate:self];
            [sheet show];
        }
        
    } else if (cell.tag == 1) { // 修改
        
        [self performSegueWithIdentifier:@"EditProfileSegue" sender:cell];
        
    } else if (cell.tag == 3) { // 修改性别
        
        [self performSegueWithIdentifier:@"ChangeSexSegue" sender:cell];
    }
}

#pragma mark - WCPhotoPickerView 代理方法

- (void)actionSheet:(LCActionSheet *)actionSheet didClickedButtonAtIndex:(int)buttonIndex {
    
    if (buttonIndex == 0) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
        
    } else if (buttonIndex == 1) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerController & UINavigationController 代理方法

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    self.iconView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self editProfileViewControllerDidSaved:nil];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark - UIAlertView 代理方法

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {         // 拍照
        
        if (SIMULATOR) {            // 模拟器
            
            UIAlertView *tip = [[UIAlertView alloc] initWithTitle:@"您的设备不支持拍照。"
                                                          message:nil
                                                         delegate:self
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
            [tip show];
            
        } else {
            
            [self actionSheet:nil didClickedButtonAtIndex:0];
        }
        
    } else if (buttonIndex == 2) {  // 相册
        
        [self actionSheet:nil didClickedButtonAtIndex:1];
    }
}

#pragma mark - WCEditProfileViewController 代理方法

- (void)editProfileViewControllerDidSaved:(WCEditProfileViewController *)editProfileVc {
    
    XMPPvCardTemp *myvCard = [WCXMPPTool sharedWCXMPPTool].vCard.myvCardTemp;
    
    // 头像
    myvCard.photo = UIImagePNGRepresentation([UIImage compressImage:self.iconView.image]);
    
    // 名字
    myvCard.nickname = self.nicknameLabel.text;
    
    // 公司
    myvCard.orgName = self.orgnameLabel.text;
    
    // 部门
    if (self.orgunitLabel.text.length > 0) {
        myvCard.orgUnits = @[self.orgunitLabel.text];
    }
    
    // 职位
    myvCard.title = self.titleLabel.text;
    
    // 手机号
    myvCard.note = self.phoneLabel.text;
    
    // 邮箱地址
    myvCard.mailer = self.emailLabel.text;
    
    // 性别
    myvCard.sex = self.sexLabel.text;
    
    [[WCXMPPTool sharedWCXMPPTool].vCard updateMyvCardTemp:myvCard];
}

#pragma mark - WCChangeSexViewController 代理方法

- (void)changeSexViewController:(WCChangeSexViewController *)chanegeSexVc didSelectedAtIndex:(int)index {
    
    XMPPvCardTemp *myvCard = [WCXMPPTool sharedWCXMPPTool].vCard.myvCardTemp;
    
    if (index == 0) {
        
        myvCard.sex = @"男";
        
    } else if (index == 1) {
        
        myvCard.sex = @"女";
    }
    [[WCXMPPTool sharedWCXMPPTool].vCard updateMyvCardTemp:myvCard];
}

@end
