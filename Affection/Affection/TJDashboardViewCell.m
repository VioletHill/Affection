//
//  TJDashboardViewCell.m
//  Affection
//
//  Created by 邱峰 on 5/5/15.
//  Copyright (c) 2015 TongjiUniversity. All rights reserved.
//

#import "TJDashboardViewCell.h"
#import <UIImageView+UIActivityIndicatorForSDWebImage.h>
#import "TJMaterialImage.h"

@interface TJDashboardViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *hoverImage;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *createAtLabel;

@end

@implementation TJDashboardViewCell

- (void)setCellWithMaterial:(TJMaterial *)material
{
    [self.hoverImage sd_setImageWithURL:[NSURL URLWithString:material.hoverImage.url]];
    self.descriptionLabel.text = material.materialDescription;
    self.priceLabel.text = [NSString stringWithFormat:@"%@", material.price];
}

@end
