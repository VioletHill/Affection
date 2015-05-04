//
//  TJMaterial.m
//  Affection
//
//  Created by 邱峰 on 4/28/15.
//  Copyright (c) 2015 TongjiUniversity. All rights reserved.
//

#import "TJMaterial.h"
#import "TJUser.h"
#import "TJClassify.h"

@interface TJMaterial()

@end

@implementation TJMaterial

@synthesize materialDescription = _materialDescription;
@synthesize price = _price;
@synthesize images = _images;
@synthesize area = _area;
@synthesize tags = _tags;

@synthesize classify  = _classify;


- (instancetype)init
{
    if (self = [super initWithClassName:@"Material"]) {
        
    }
    return self;
}

- (NSString *)materialDescription
{
    return [self objectForKey:@"materialDescription"];
}

- (void)setMaterialDescription:(NSString *)materialDescription
{
    [self setObject:materialDescription forKey:@"materialDescription"];
}

- (NSNumber *)price
{
    return [self objectForKey:@"price"];
}


- (void)setPrice:(NSNumber *)price
{
    [self setObject:price forKey:@"price"];
}

- (void)setImages:(NSArray *)images
{
    [self addUniqueObjectsFromArray:images forKey:@"images"];
}

- (NSArray *)images
{
    return [self objectForKey:@"images"];
}

- (void)setArea:(TJMaterialArea)area
{
    [self setObject:@(area) forKey:@"area"];
}

- (TJMaterialArea)area
{
    if ([[self objectForKey:@"area"] isEqualToNumber:@(0)]) {
        return TJMaterialAreaBenbu;
    }
    else {
        return TJMaterialAreaJiading;
    }
}

- (NSArray *)tags
{
    return [self objectForKey:@"tags"];
}

- (void)setTags:(NSArray *)tags
{
    [self addUniqueObjectsFromArray:tags forKey:@"tags"];
}

- (void)setPoster:(TJUser *)poster
{
    [self setObject:poster forKey:@"poster"];
}

- (TJUser *)poster
{
    return [self objectForKey:@"poster"];
}

- (void)setClassify:(NSArray *)classify
{
    BmobRelation *relation = [[BmobRelation alloc] init];
    for (TJClassify *object in classify) {
        if ([object isKindOfClass:[TJClassify class]]) {
            [relation addObject:object];
        }
    }
    [self addRelation:relation forKey:@"classify"];
}

- (NSArray *)classify
{
    return nil;
}

@end
