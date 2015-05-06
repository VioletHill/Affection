//
//  TJMaterialManager.m
//  Affection
//
//  Created by 邱峰 on 5/4/15.
//  Copyright (c) 2015 TongjiUniversity. All rights reserved.
//

#import "TJMaterialManager.h"
#import <BmobSDK/Bmob.h>

@implementation TJMaterialManager

+ (instancetype)sharedMaterialManager
{
    static dispatch_once_t token;
    static id manager;
    dispatch_once(&token, ^() {
        manager = [[[self class] alloc] init];
    });
    return manager;
}

- (void)postMaterial:(TJMaterial *)material complete:(void (^)(BOOL, NSError *))complete
{
    [material saveInBackgroundWithResultBlock:^(BOOL success, NSError *error) {
        if (complete) {
            complete(success, error);
        }
    }];
}

- (void)getMaterialComplete:(void (^)(NSArray *, NSError *))complete
{
    BmobQuery *query = [BmobQuery queryWithClassName:@"Material"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            complete(nil, error);
        }
        else {
            NSMutableArray *result = [NSMutableArray array];
            for (BmobObject *object in array) {
                [result addObject:[TJMaterial copyWithBomb:object]];
            }
            complete(result, nil);
        }
    }];
}

@end
