//
//  TJPostViewController.m
//  Affection
//
//  Created by 邱峰 on 5/4/15.
//  Copyright (c) 2015 TongjiUniversity. All rights reserved.
//

#import "TJPostViewController.h"
#import "TJUserManager.h"
#import "TJMaterialManager.h"
#import "MBProgressHUD+AppProgressView.h"
#import <Routable.h>
#import <UIActionSheet+BlocksKit.h>
#import <UIAlertView+BlocksKit.h>
#import "TJMaterialImage.h"

@interface TJPostViewController()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) TJUser *user;

@property (weak, nonatomic) IBOutlet UIButton *postImageButton;
@property (weak, nonatomic) IBOutlet UITextView *materialDescriptionTextView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *areaSegment;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;

@property (nonatomic, strong) TJMaterialImage *imageFile;

@end

@implementation TJPostViewController

- (void)viewDidLoad
{
    self.user = [TJUser getCurrentUser];
}

#pragma mark - Post

- (IBAction)postButtonPress:(UIButton *)sender
{
    TJMaterial *material = [[TJMaterial alloc] init];
    material.materialDescription = @"testDesc";
    material.price = @(10.5);
    material.tags = @[@"a",@"b"];
    material.area = TJMaterialAreaBenbu;
    material.poster = self.user;
    material.status = TJMaterialPengding;
    
    material.hoverImage = self.imageFile;
    
    MBProgressHUD *loading = [MBProgressHUD progressHUDNetworkLoadingInView:nil withText:@"发布中"];
    [[TJMaterialManager sharedMaterialManager] postMaterial:material complete:^(BOOL success, NSError *error) {
        [loading hide:YES];
        
        if (error) {
            [MBProgressHUD showErrorProgressInView:nil withText:@"发送失败,请稍后再试"];
        }
        else {
            [MBProgressHUD showSucessProgressInView:nil withText:@"发布成功"];
        }
        
    }];
}

- (IBAction)selectPhoto:(UIButton *)sender
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
        
        BmobFile *file = [[BmobFile alloc] initWithFileName:[self.user.mobileNumber stringByAppendingString:@"materialHover.png"] withFileData:mediaData];
        
        [file saveInBackground:^(BOOL success, NSError *error) {
            if (success) {
                self.imageFile  = [[TJMaterialImage alloc] init];
                self.imageFile.width = @(image.size.width);
                self.imageFile.height = @(image.size.height);
                
                [self.imageFile saveInBackgroundWithResultBlock:^(BOOL success, NSError *error) {
                    [loading hide:YES];
                    if (error) {
                        [MBProgressHUD showErrorProgressInView:nil withText:@"图片上传失败"];
                    }
                    else {
                        [self.postImageButton setImage:image forState:UIControlStateNormal];
                    }
                }];
            }
            else {
                [MBProgressHUD showErrorProgressInView:nil withText:@"图片上传失败"];
            }
            
        } withProgressBlock:^ (float progress) {
            loading.progress = progress;
        }];
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
