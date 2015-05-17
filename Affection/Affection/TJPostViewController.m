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
#import "TJClassifyManager.h"

@interface TJPostViewController()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) TJUser *user;

@property (weak, nonatomic) IBOutlet UIButton *postImageButton;
@property (weak, nonatomic) IBOutlet UITextView *materialDescriptionTextView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *areaSegment;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (nonatomic, strong) TJMaterialImage *imageFile;
@property (weak, nonatomic) IBOutlet UIButton *classifyButton;

@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (nonatomic, strong) NSArray *classify;

@end

@implementation TJPostViewController

- (void)viewDidLoad
{
    self.user = [TJUser getCurrentUser];
}

#pragma mark - Getter & Setter

- (NSArray *)classify
{
    if (_classify == nil) {
        _classify = [[TJClassifyManager sharedClassifyManager] getLocalClassify];
    }
    return _classify;
}

#pragma mark - Post

- (void)clearMaterial
{
    self.materialDescriptionTextView.text = @"";
    self.titleTextField.text = @"";
    self.priceTextField.text = @"";
    self.imageFile = nil;
    [self.postImageButton setImage:[UIImage imageNamed:@"post_icon_camare"] forState:UIControlStateNormal];
}

- (IBAction)postButtonPress:(UIButton *)sender
{
    TJMaterial *material = [[TJMaterial alloc] init];
    material.materialDescription = [self.materialDescriptionTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    material.price = @([self.priceTextField.text floatValue]);
    material.title = [self.titleTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    material.status = TJMaterialPengding;
    
    
    if ([material.materialDescription isEqualToString:@""]) {
        [MBProgressHUD showErrorProgressInView:nil withText:@"描述不能为空"];
        return;
    }
    
    if ([material.title isEqualToString:@""]) {
        [MBProgressHUD showErrorProgressInView:nil withText:@"标题不能为空"];
        return;
    }
    
    if (self.areaSegment.selectedSegmentIndex == 0) {
        material.area = TJMaterialAreaBenbu;
    }
    else {
        material.area = TJMaterialAreaJiading;
    }
 
    material.poster = self.user;
    material.status = TJMaterialPengding;
    
    if (self.imageFile) {
        material.hoverImage = self.imageFile.image;
        material.hoverImageWidth = self.imageFile.width;
        material.hoverImageHeight = self.imageFile.height;
    }
    else {
        material.hoverImageWidth = @(0);
        material.hoverImageHeight = @(0);
    }
    
    
    MBProgressHUD *loading = [MBProgressHUD progressHUDNetworkLoadingInView:nil withText:@"发布中"];
    [[TJClassifyManager sharedClassifyManager] queryForClassify:self.classifyButton.titleLabel.text complete:^(TJClassify *classify, NSError *error) {
        if (error == nil) {
            material.classify = classify;
            [[TJMaterialManager sharedMaterialManager] postMaterial:material complete:^(BOOL success, NSError *error) {
                [loading hide:YES];
                if (error) {
                    [MBProgressHUD showErrorProgressInView:nil withText:@"发送失败,请稍后再试"];
                }
                else {
                    [MBProgressHUD showSucessProgressInView:nil withText:@"发布成功"];
                    [self clearMaterial];
                }
            }];
        }
        else {
            [loading hide:YES];
            [MBProgressHUD showErrorProgressInView:nil withText:@"发送失败,请稍后再试"];
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
        picker.allowsEditing = NO;
        
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
        
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        NSData *mediaData = UIImagePNGRepresentation(image);
        
        BmobFile *file = [[BmobFile alloc] initWithFileName:[self.user.mobileNumber stringByAppendingString:@"materialHover.png"] withFileData:mediaData];
        
        [file saveInBackground:^(BOOL success, NSError *error) {
            if (success) {
                self.imageFile  = [[TJMaterialImage alloc] init];
                self.imageFile.width = @(image.size.width);
                self.imageFile.height = @(image.size.height);
                self.imageFile.image = file;
                
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
                [loading hide:YES];
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

- (IBAction)showPicker:(UIButton *)sender
{
    self.coverView.hidden = NO;
    self.pickerView.hidden = NO;
}

- (IBAction)dismissPicker:(id)sender
{
    NSInteger select = [self.pickerView selectedRowInComponent:0];
    [self.classifyButton setTitle:self.classify[select] forState:UIControlStateNormal];
    self.coverView.hidden = YES;
    self.pickerView.hidden = YES;
}


#pragma mark - Picker View Delegate & DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.classify.count;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:self.classify[row] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    return attString;
}

#pragma mark - touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
