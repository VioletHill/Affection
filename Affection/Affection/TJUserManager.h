//
//  TJUserManager.h
//  Affection
//
//  Created by 邱峰 on 4/28/15.
//  Copyright (c) 2015 TongjiUniversity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TJUser.h"

@interface TJUserManager : NSObject

+ (instancetype)sharedUserManager;

+ (BOOL)isAvailableAccount:(NSString *)account;

+ (BOOL)isAvailableName:(NSString *)name;

+ (int)getMinPasswordLength;

+ (BOOL)isAvailablePassword:(NSString *)password;

- (void)loginWithMobileNumber:(NSString *)mobileNumber password:(NSString *)password complete:(void (^)(TJUser *user, NSError *error))complete;

- (void)getUserWithUserObjectId:(NSString *)objectId complete:(void (^)(TJUser *user, NSError *error))complete;

@end
