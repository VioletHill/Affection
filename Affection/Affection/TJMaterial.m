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
@synthesize hoverImage = _hoverImage;
@synthesize hoverImageWidth = _hoverImageWidth;
@synthesize hoverImageHeight = _hoverImageHeight;
@synthesize poster = _poster;
@synthesize status = _status;

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
    _poster = poster;
    [self setObject:poster forKey:@"poster"];
}

- (TJUser *)poster
{
    return _poster;
}

- (void)setClassify:(TJClassify *)classify
{
    [self setObject:classify forKey:@"classify"];
//    BmobRelation *relation = [[BmobRelation alloc] init];
//    for (TJClassify *object in classify) {
//        if ([object isKindOfClass:[TJClassify class]]) {
//            [relation addObject:object];
//        }
//    }
//    [self addRelation:relation forKey:@"classify"];
}

- (TJClassify *)classify
{
    return [self objectForKey:@"classify"];
}

- (void)setHoverImage:(BmobFile *)hoverImage
{
    [self setObject:hoverImage forKey:@"hoverImage"];
}

- (BmobFile *)hoverImage
{
    return [self objectForKey:@"hoverImage"];
}

- (void)setHoverImageWidth:(NSNumber *)hoverImageWidth
{
    [self setObject:hoverImageWidth forKey:@"hoverImageWidth"];
}

- (NSNumber *)hoverImageWidth
{
    return [self objectForKey:@"hoverImageWidth"];
}

- (void)setHoverImageHeight:(NSNumber *)hoverImageHeight
{
    [self setObject:hoverImageHeight forKey:@"hoverImageHeight"];
}

- (NSNumber *)hoverImageHeight
{
    return [self objectForKey:@"hoverImageHeight"];
}

- (void)setStatus:(TJMaterialStatus)status
{
    [self setObject:@(status) forKey:@"status"];
}

- (TJMaterialStatus)status
{
    return [[self objectForKey:@"status"] integerValue];
}

+ (TJMaterial *)copyWithBomb:(BmobObject *)object
{
    TJMaterial *material = [[TJMaterial alloc] init];
    material.objectId = object.objectId;
    material.createdAt = object.createdAt;
    material.updatedAt = object.updatedAt;
    material.className = object.className;
    material.ACL = object.ACL;
    material.materialDescription = [object objectForKey:@"materialDescription"];
    material.price = [object objectForKey:@"price"];
    material.hoverImageWidth = [object objectForKey:@"hoverImageWidth"];
    material.hoverImageHeight = [object objectForKey:@"hoverImageHeight"];
    material.hoverImage = [object objectForKey:@"hoverImage"];
    material.poster = [TJUser copyWithUser:[object objectForKey:@"poster"]];
    material.status = [[object objectForKey:@"status"] integerValue];
    
    NSNumber *area = [object objectForKey:@"area"];
    
    if ([area isEqualToNumber:@(0)]) {
        material.area = TJMaterialAreaBenbu;
    }
    else {
        material.area = TJMaterialAreaJiading;
    }
    
    material.poster = [object objectForKey:@"poster"];
    
    return material;
}

@end
