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
        if (complete) {
            complete((TJUser *)user, error);
        }
    }];
}


@end
