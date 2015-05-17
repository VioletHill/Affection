//
//  TJMaterialManager.m
//  Affection
//
//  Created by 邱峰 on 5/4/15.
//  Copyright (c) 2015 TongjiUniversity. All rights reserved.
//

#import "TJMaterialManager.h"
#import <BmobSDK/Bmob.h>
#import "TJClassifyManager.h"

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
    [query whereKey:@"status" equalTo:@(0)];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"poster"];
    query.limit = 1000;
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

- (void)getMaterialWithUser:(TJUser *)user complete:(void (^)(NSArray *, NSError *))complete
{    
    BmobQuery *query = [BmobQuery queryWithClassName:@"Material"];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"poster" equalTo:user];
    [query includeKey:@"poster"];
    query.limit = 1000;
    
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

- (void)getMaterialWithType:(TJMaterialArea)area limit:(NSInteger)limit skip:(NSInteger)skip complete:(void (^)(NSArray *, NSError *))complete
{
    BmobQuery *query = [BmobQuery queryWithClassName:@"Material"];
    [query whereKey:@"status" equalTo:@(0)];
    [query orderByDescending:@"createdAt"];
    query.skip = skip;
    query.limit = limit;
    [query includeKey:@"poster"];
    [query whereKey:@"area" equalTo:@(area)];
    
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

- (void)queryForMaterialWithType:(TJMaterialArea)area classify:(NSString *)classifyName limit:(NSInteger)limit skip:(NSInteger)skip complete:(void (^)(NSArray *, NSError *))complete
{
    if ([classifyName isEqualToString:@"全部"]) {
        [self getMaterialWithType:area limit:limit skip:skip complete:complete];
    }
    else {
        BmobQuery *query = [BmobQuery queryWithClassName:@"Material"];
        [query whereKey:@"status" equalTo:@(0)];
        [query orderByDescending:@"createdAt"];
        [query includeKey:@"poster"];
        query.limit = limit;
        query.skip = skip;
        [query whereKey:@"area" equalTo:@(area)];

        [[TJClassifyManager sharedClassifyManager] queryForClassify:classifyName complete:^(TJClassify *classify, NSError *error) {
            if (error) {
                complete(nil, error);
            }
            else {
                [query whereKey:@"classify" equalTo:classify];
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
        }];
    }
}

- (void)searchForKey:(NSString *)key limit:(NSInteger)limit skip:(NSInteger)skip complete:(void (^)(NSArray *, NSError *))complete
{
    key = [key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([key isEqualToString:@""]) {
        return;
    }
    else {
        BmobQuery *query = [BmobQuery queryWithClassName:@"Material"];
        [query whereKey:@"status" equalTo:@(0)];
        [query orderByDescending:@"createdAt"];
        [query whereKey:@"title" matchesWithRegex:[NSString stringWithFormat:@".*%@.*",key]];
        [query includeKey:@"poster"];
        query.skip = skip;
        query.limit = limit;
        /**
         *  TO DO: add Tag search here
         */
        
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
}

@end
