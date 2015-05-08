//
//  TJUserManager.m
//  Affection
//
//  Created by 邱峰 on 4/28/15.
//  Copyright (c) 2015 TongjiUniversity. All rights reserved.
//

#import "TJUserManager.h"

@interface TJUserManager()

@end

@implementation TJUserManager


+ (instancetype)sharedUserManager
{
    static dispatch_once_t token;
    static id manager;
    dispatch_once(&token, ^() {
        manager = [[[self class] alloc] init];
    });
    return manager;
}


+ (BOOL)isAvailableAccount:(NSString *)account
{
    NSRange range = [account rangeOfString:@"^1[34578]\\d{9}$" options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        return YES;
    }
    else {
        return NO;
    }
}

+ (BOOL)isAvailableName:(NSString *)name
{
    if ([name rangeOfString:@" "].location != NSNotFound) {
        return NO;
    }
    else {
        return YES;
    }
}

+ (int)getMinPasswordLength
{
    return 6;
}

+ (BOOL)isAvailablePassword:(NSString *)password
{
    if (password.length < [self getMinPasswordLength]) {
        return NO;
    }
    else {
        return YES;
    }
}

- (void)loginWithMobileNumber:(NSString *)mobileNumber password:(NSString *)password complete:(void (^)(TJUser *, NSError *))complete
{
    [BmobUser loginWithUsernameInBackground:mobileNumber password:password block:^(BmobUser *user, NSError *error) {
        if (error) {
            complete(nil, error);
        }
        else {
            TJUser *tjUser = [TJUser copyWithUser:user];
            complete(tjUser, nil);
        }
    }];
}


- (void)getUserWithUserObjectId:(NSString *)objectId complete:(void (^)(TJUser *, NSError *))complete
{
    BmobQuery *query = [BmobUser query];
    [query whereKey:@"objectId" equalTo:objectId];
    query.limit = 1;
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array) {
            if (array.count != 0) {
                TJUser *tjUser = [TJUser copyWithUser:[array firstObject]];
                complete(tjUser, nil);
            }
            else {
                complete(nil, [[NSError alloc] init]);
            }
        }
        else {
            complete(nil, error);
        }
    }];
}

@end
