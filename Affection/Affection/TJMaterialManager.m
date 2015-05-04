//
//  TJMaterialManager.m
//  Affection
//
//  Created by 邱峰 on 5/4/15.
//  Copyright (c) 2015 TongjiUniversity. All rights reserved.
//

#import "TJMaterialManager.h"

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

@end
