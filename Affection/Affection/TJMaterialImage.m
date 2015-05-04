//
//  TJMaterialImage.m
//  Affection
//
//  Created by 邱峰 on 4/28/15.
//  Copyright (c) 2015 TongjiUniversity. All rights reserved.
//

#import "TJMaterialImage.h"

@implementation TJMaterialImage

@synthesize height = _height;
@synthesize width = _width;
@synthesize image = _image;

- (instancetype)init
{
    if (self = [super initWithClassName:@"MaterialImage"]) {
        
    }
    return self;
}

- (void)setHeight:(NSNumber *)height
{
    [self setObject:height forKey:@"height"];
}

- (NSNumber *)height
{
    return [self objectForKey:@"height"];
}

- (void)setWidth:(NSNumber *)width
{
    [self setObject:width forKey:@"width"];
}

- (NSNumber *)width
{
    return [self objectForKey:@"width"];
}

- (void)setImage:(BmobFile *)image
{
    [self setObject:image forKey:@"image"];
}

- (BmobFile *)image
{
    return [self objectForKey:@"image"];
}

@end
