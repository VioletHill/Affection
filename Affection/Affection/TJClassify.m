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


+ (TJClassify *)copyWithBmobObject:(BmobObject *)object
{
    TJClassify *classify = [[TJClassify alloc] init];
    
    classify.createdAt = object.createdAt;
    classify.objectId = object.objectId;
    classify.updatedAt = object.updatedAt;
    classify.className = object.className;
    classify.ACL = object.ACL;
    
    classify.classifyName = [object objectForKey:@"classifyName"];
    
    return classify;
}


@end
