//
//  TJLoginViewController.m
//  Affection
//
//  Created by 邱峰 on 5/3/15.
//  Copyright (c) 2015 TongjiUniversity. All rights reserved.
//

#import "TJLoginViewController.h"
#import "TJUserManager.h"
#import "MBProgressHUD+AppProgressView.h"

@interface TJLoginViewController()

@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation TJLoginViewController


- (void)viewDidLoad
{
    
}


#pragma mark - Action

- (IBAction)loginButtonPress:(UIButton *)sender
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

@end
