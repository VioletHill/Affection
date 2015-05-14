//
//  TJClassifyTableViewCell.m
//  Affection
//
//  Created by 邱峰 on 5/7/15.
//  Copyright (c) 2015 TongjiUniversity. All rights reserved.
//

#import "TJClassifyTableViewCell.h"
#import "TJClassify.h"

@interface TJClassifyTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *classifyLabel;

@end

@implementation TJClassifyTableViewCell

- (void)setCellWithClassify:(TJClassify *)classify
{
    self.classifyLabel.text = classify.classifyName;
}

@end
