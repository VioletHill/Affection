//
//  TJMaterialDetailViewController.m
//  Affection
//
//  Created by 邱峰 on 5/7/15.
//  Copyright (c) 2015 TongjiUniversity. All rights reserved.
//

#import "TJMaterialDetailViewController.h"
#import "TJMaterial.h"
#import <UIImageView+UIActivityIndicatorForSDWebImage.h>

@interface TJMaterialDetailViewController()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *materialDescription;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstraint;
@end

@implementation TJMaterialDetailViewController

- (void)viewDidLoad
{
    self.materialDescription.text = self.material.materialDescription;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat hoverImageWidth = self.material.hoverImageWidth.floatValue;
    CGFloat hoverImageHeight = self.material.hoverImageHeight.floatValue;
    if (hoverImageWidth == 0) {
        hoverImageWidth = 200;
        hoverImageHeight = 200;
    }
    CGFloat height = hoverImageHeight / hoverImageWidth * width + 70;
    
    self.imageHeightConstraint.constant = height;
    
    [self.imageView setImageWithURL:[NSURL URLWithString:self.material.hoverImage.url] placeholderImage:[UIImage imageNamed:@"imagePlaceholder"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}



@end
