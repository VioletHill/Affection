//
//  TJClassifyManager.m
//  Affection
//
//  Created by 邱峰 on 4/28/15.
//  Copyright (c) 2015 TongjiUniversity. All rights reserved.
//

#import "TJClassifyManager.h"
#import <BmobSDK/Bmob.h>
#import "TJMaterial.h"

@interface TJClassifyManager()

@end

@implementation TJClassifyManager

+ (instancetype)sharedClassifyManager
{
    static dispatch_once_t token;
    static id manager;
    dispatch_once(&token, ^() {
        manager = [[TJClassifyManager alloc] init];
    });
    return manager;
}

- (void)queryForMaterial:(TJMaterial *)material complete:(void (^)(NSArray *, NSError *))complete
{
    
    BmobQuery *query = [BmobQuery queryWithClassName:NSStringFromClass(material.class)];
    [query whereObjectKey:@"classify" relatedTo:material];
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        if (complete) {
            complete(results, error);
        }
    }];
    
}

@end
