//
//  TJRegisterViewController.m
//  Affection
//
//  Created by 邱峰 on 5/3/15.
//  Copyright (c) 2015 TongjiUniversity. All rights reserved.
//

#import "TJRegisterViewController.h"
#import "TJUserManager.h"
#import "MBProgressHUD+AppProgressView.h"

@interface TJRegisterViewController()

@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation TJRegisterViewController




- (IBAction)registerButtonPress:(UIButton *)sender
{
    NSString *mobileNumber = self.mobileTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if (![TJUserManager isAvailableAccount:mobileNumber]) {
        [MBProgressHUD showErrorProgressInView:nil withText:@"手机号码错误"];
        [self.mobileTextField becomeFirstResponder];
        return;
    }
    
    if (![TJUserManager isAvailablePassword:password]) {
        [MBProgressHUD showErrorProgressInView:nil withText:[NSString stringWithFormat:@"密码最少%d位", [TJUserManager getMinPasswordLength]]];
        [self.passwordTextField becomeFirstResponder];
        return;
    }

    
    TJUser *newUser = [[TJUser alloc] init];
    
    newUser.mobileNumber = mobileNumber;
    newUser.userName = mobileNumber;
    newUser.password = password;
    
    MBProgressHUD *loadingProgress = [MBProgressHUD progressHUDNetworkLoadingInView:nil withText:@"注册中.."];
    [newUser signUpInBackgroundWithBlock:^(BOOL success, NSError *error) {
        [loadingProgress hide:YES];
        if (success) {
            [MBProgressHUD showSucessProgressInView:nil withText:@"注册成功"];
            
            MBProgressHUD *loading = [MBProgressHUD progressHUDNetworkLoadingInView:nil withText:@"登录中"];
            [[TJUserManager sharedUserManager] loginWithMobileNumber:mobileNumber password:password complete:^(TJUser *user, NSError *error) {
                [loading hide:YES];
                if (user) {
                    [MBProgressHUD showSucessProgressInView:nil withText:@"登录成功"];
                    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TJUserCenterViewController"];
                    [self.navigationController pushViewController:controller animated:YES];
                    
                }
                else {
                    [MBProgressHUD showErrorProgressInView:nil withText:@"登录失败"];
                }
            }];
        }
        else {
            [MBProgressHUD showErrorProgressInView:nil withText:@"注册失败"];
        }
    }];
}


@end
