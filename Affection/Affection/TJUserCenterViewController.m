//
//  TJUserCenterViewController.m
//  Affection
//
//  Created by 邱峰 on 5/3/15.
//  Copyright (c) 2015 TongjiUniversity. All rights reserved.
//

#import "TJUserCenterViewController.h"
#import <UIActionSheet+BlocksKit.h>
#import <UIAlertView+BlocksKit.h>
#import "MBProgressHUD+AppProgressView.h"
#import "TJUser.h"
#import <BmobSDK/Bmob.h>


@interface TJUserCenterViewController()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) TJUser* user;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation TJUserCenterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.user = (TJUser *)[TJUser getCurrentUser];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        [self changeAvatar];
    }
    else if (indexPath.row == 1) {
        
    }
}

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
        
        [self.avatarImageView setImage:image];
        
        BmobFile *file = [[BmobFile alloc] initWithFileName:[self.user.mobileNumber stringByAppendingString:@"avatar.png"] withFileData:mediaData];
        
        [file saveInBackground:^(BOOL success, NSError *error) {
            [loading hide:YES];
            if (success) {
                self.user.avatar = file;
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



@end
