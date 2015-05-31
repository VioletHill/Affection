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

@property (nonatomic, strong) NSArray *localClassify;

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

- (NSArray *)localClassify
{
    if (_localClassify == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Classify" ofType:@"plist"];
        _localClassify = [NSArray arrayWithContentsOfFile:path];
    }
    return _localClassify;
}

- (NSArray *)getLocalClassify
{
    return self.localClassify;
}

- (void)getAllClassifies:(void (^)(NSArray *, NSError *))complete
{
    
    BmobQuery *query = [BmobQuery queryWithClassName:@"classify"];
    query.limit = 1000;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            complete(nil, error);
        }
        else {
            NSMutableArray *result = [NSMutableArray array];
            for (BmobObject *object in array) {
                [result addObject:[TJClassify copyWithBmobObject:object]];
            }
            
            TJClassify *allClassify = [[TJClassify alloc] init];
            allClassify.classifyName = @"全部";
            [result insertObject:allClassify atIndex:0];
            
            complete(result, nil);
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
