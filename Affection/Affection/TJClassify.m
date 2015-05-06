//
//  TJClassify.m
//  Affection
//
//  Created by 邱峰 on 4/28/15.
//  Copyright (c) 2015 TongjiUniversity. All rights reserved.
//

#import "TJClassify.h"

@implementation TJClassify

@synthesize classifyName = _classifyName;

- (instancetype)init
{
    if (self = [super initWithClassName:@"classify"]) {
        
    }
    return self;
}

- (NSString *)classifyName
{
    return [self objectForKey:@"classifyName"];
}

- (void)setClassifyName:(NSString *)classifyName
{
    [self setObject:classifyName forKey:@"classifyName"];
}

@end
