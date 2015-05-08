//
//  TJMaterialDetailViewController.m
//  Affection
//
//  Created by 邱峰 on 5/7/15.
//  Copyright (c) 2015 TongjiUniversity. All rights reserved.
//

#import "TJMaterialDetailViewController.h"
#import "TJMaterial.h"
#import "TJUserManager.h"
#import <UIImageView+UIActivityIndicatorForSDWebImage.h>
#import <UIButton+WebCache.h>
#import "TJUserCenterViewController.h"

@interface TJMaterialDetailViewController()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *materialDescription;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstraint;

@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;

@property (weak, nonatomic) IBOutlet UIView *userInfoView;

@property (nonatomic, strong) TJUser *user;

@end

@implementation TJMaterialDetailViewController

- (void)viewDidLoad
{
    self.userInfoView.hidden = YES;
    
    self.materialDescription.text = self.material.materialDescription;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat hoverImageWidth = self.material.hoverImageWidth.floatValue;
    CGFloat hoverImageHeight = self.material.hoverImageHeight.floatValue;
    if (hoverImageWidth == 0) {
        hoverImageWidth = 200;
        hoverImageHeight = 200;
    }
    CGFloat height = hoverImageHeight / hoverImageWidth * width;
    
    self.imageHeightConstraint.constant = height;
    
    [self.imageView setImageWithURL:[NSURL URLWithString:self.material.hoverImage.url] placeholderImage:[UIImage imageNamed:@"imagePlaceholder"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    self.priceLabel.text = [NSString stringWithFormat:@"￥ %@", self.material.price];
    self.timeLabel.text = [self stringFromDate:self.material.createdAt];
    
    if ([self.material.poster isKindOfClass:[TJUser class]]) {
        self.user = self.material.poster;
        self.userInfoView.hidden = NO;
        [self.phoneButton setTitle:self.user.mobileNumber forState:UIControlStateNormal];
        [self.avatarButton sd_setImageWithURL:[NSURL URLWithString:self.user.avatar.url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"defaultProvide"]];
    }
    else {
        [[TJUserManager sharedUserManager] getUserWithUserObjectId:self.material.poster.objectId complete:^(TJUser *user, NSError *error) {
            if (user) {
                self.user = user;
                self.userInfoView.hidden = NO;
                [self.phoneButton setTitle:self.user.mobileNumber forState:UIControlStateNormal];
                [self.avatarButton sd_setImageWithURL:[NSURL URLWithString:self.user.avatar.url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"defaultProvide"]];
            }
        }];
    }
}

- (void)viewDidLayoutSubviews
{
    self.avatarButton.layer.cornerRadius = self.avatarButton.frame.size.width / 2;
}

- (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    return  [format stringFromDate:date];
}

#pragma mark - Action

- (IBAction)avatarButtonPress:(UIButton *)sender
{
    TJUserCenterViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TJUserCenterViewController"];
    controller.user = self.user;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)phoneButtonPress:(UIButton *)sender
{
    NSString *phoneNumber = self.phoneButton.titleLabel.text;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNumber]]];
}

- (IBAction)chatMessageButtonPress:(UIButton *)sender
{
    NSString *phoneNumber = self.phoneButton.titleLabel.text;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",phoneNumber]]];
}

@end
