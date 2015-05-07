//
//  TJUserCenterViewController.m
//  Affection
//
//  Created by 邱峰 on 5/3/15.
//  Copyright (c) 2015 TongjiUniversity. All rights reserved.
//

#import "TJMyInfoCenterViewController.h"
#import <UIActionSheet+BlocksKit.h>
#import <UIAlertView+BlocksKit.h>
#import "MBProgressHUD+AppProgressView.h"
#import "TJUserManager.h"
#import <UIActivityIndicator-for-SDWebImage/UIImageView+UIActivityIndicatorForSDWebImage.h>
#import <BmobSDK/Bmob.h>


@interface TJMyInfoCenterViewController()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) TJUser* user;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegment;

@end

@implementation TJMyInfoCenterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.user = [TJUser getCurrentUser];
    
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:self.user.avatar.url] placeholderImage:[UIImage imageNamed:@"defaultProvide"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    self.nameLabel.text = self.user.name;
    
    if (self.user.gender == TJUserGenderFemale) {
        self.genderSegment.selectedSegmentIndex = 1;
    }
    else {
        self.genderSegment.selectedSegmentIndex = 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        [self changeAvatar];
    }
    else if (indexPath.row == 1) {
        [self changeName];
    }
}

#pragma mark - Change Avatar

- (void)changeAvatar
{
    UIActionSheet *actionSheet = [UIActionSheet bk_actionSheetWithTitle:nil];
    [actionSheet bk_addButtonWithTitle:@"拍照" handler:^{
        [self showImagePicker:UIImagePickerControllerSourceTypeCamera];
    }];
    [actionSheet bk_addButtonWithTitle:@"从相册选择" handler:^{
        [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    [actionSheet bk_setCancelButtonWithTitle:@"取消" handler:nil];
    [actionSheet showInView:self.view];
}


- (void)showImagePicker:(UIImagePickerControllerSourceType)sourceType
{
    
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        picker.sourceType = sourceType;
        picker.delegate = self;
        picker.allowsEditing = YES;
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self presentViewController:picker animated:YES completion:nil];
        }];
    }
    else {
        NSString *message;
        if (sourceType == UIImagePickerControllerSourceTypeCamera) {
            message = @"获取相机失败";
        }
        else {
            message = @"获取照片失败";
        }
        [UIAlertView bk_showAlertViewWithTitle:nil message:message cancelButtonTitle:@"确定" otherButtonTitles:nil handler:nil];
    }
}

#pragma mark - ImagePicker Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^(void) {
        
        MBProgressHUD *loading = [MBProgressHUD determinateProgressHUDInView:nil withText:@"图片上传中"];
        
        UIImage *image = info[UIImagePickerControllerEditedImage];
        NSData *mediaData = UIImagePNGRepresentation(image);
        
        BmobFile *file = [[BmobFile alloc] initWithFileName:[self.user.mobileNumber stringByAppendingString:@"avatar.png"] withFileData:mediaData];
        
        [file saveInBackground:^(BOOL success, NSError *error) {
            [loading hide:YES];
            if (success) {
                self.user.avatar = file;
                [self.user updateInBackgroundWithResultBlock:^(BOOL success, NSError *error) {
                    if (success) {
                        [self.avatarImageView setImage:image];
                    }
                    else {
                        [MBProgressHUD showErrorProgressInView:nil withText:@"头像上传失败"];
                    }
                }];
            }
            else {
            }
            
        } withProgressBlock:^ (float progress) {
            loading.progress = progress * 99.0 / 100;
        }];
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Change Name

- (void)changeName
{
    UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"修改名字" message:@"真实姓名有助于二手物品买卖"];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView bk_setCancelButtonWithTitle:@"取消" handler:nil];
    [alertView bk_addButtonWithTitle:@"确定" handler:^(){
        
        NSString *name = [[alertView textFieldAtIndex:0].text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (![TJUserManager isAvailableName:name]) {
            [MBProgressHUD showErrorProgressInView:nil withText:@"名字不允许有空格"];
            return ;
        }
        
        self.user.name = name;
        self.nameLabel.text = self.user.name;
        [self.user updateInBackground];
    }];
    
    [alertView show];
}


#pragma mark - Segment Value Change


- (IBAction)didGenderSegmentValueChange:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0) {
        self.user.gender = TJUserGenderMale;
    }
    else {
        self.user.gender = TJUserGenderFemale;
    }
    [self.user updateInBackground];
}

@end
