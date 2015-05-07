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
        manager = [[self alloc] init];
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

- (void)queryForClassify:(NSString *)classifyName complete:(void (^)(TJClassify *, NSError *) )complete
{
    BmobQuery *query = [BmobQuery queryWithClassName:@"classify"];
    [query whereKey:@"classifyName" equalTo:classifyName];
    query.limit = 1;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *result , NSError *error) {
        if (error) {
            if (complete) {
                complete(nil, error);
            }
        }
        else {
            TJClassify *classify = nil;
            if ([result firstObject]) {
                classify = [TJClassify copyWithBmobObject:[result firstObject]];
                if (complete) {
                    complete(classify, nil);
                }
            }
            else {
                TJClassify *classify = [[TJClassify alloc] init];
                classify.classifyName = classifyName;
                [classify saveInBackgroundWithResultBlock:^(BOOL success, NSError *error) {
                    if (success) {
                        complete(classify, nil);
                    }
                    else {
                        complete(nil, error);
                    }
                }];
                return;
            }
        }
    }];
}

@end
