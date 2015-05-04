//
//  TJUser.m
//  Affection
//
//  Created by 邱峰 on 4/28/15.
//  Copyright (c) 2015 TongjiUniversity. All rights reserved.
//

#import "TJUser.h"

@interface TJUser()

@end



@implementation TJUser

@synthesize name = _name;
@synthesize userName = _userName;
@synthesize password = _password;
@synthesize gender = _gender;
@synthesize avatar = _avatar;
@synthesize mobileNumber = _mobileNumber;


- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)setMobileNumber:(NSString *)mobileNumber
{
    [self setObject:mobileNumber forKey:@"mobileNumber"];
}

- (NSString *)mobileNumber
{
    return [self objectForKey:@"mobileNumber"];
}

- (void)setName:(NSString *)name
{
    [self setObject:name forKey:@"name"];
}

- (NSString *)name
{
    return [self objectForKey:@"name"];
}

- (void)setUserName:(NSString *)userName
{
    [super setUserName:userName];
}

- (NSString *)userName
{
    return [super objectForKey:@"userName"];
}

- (void)setPassword:(NSString *)password
{
    [super setPassword:password];
}

- (NSString *)password
{
    return [super objectForKey:@"password"];
}

- (void)setGender:(TJUserGender)gender
{
    [self setObject:@(gender) forKey:@"gender"];
}

- (TJUserGender)gender
{
    if ([[self objectForKey:@"gender"] isEqualToNumber:@(0)]) {
        return TJUserGenderMale;
    }
    else {
        return TJUserGenderFemale;
    }
}

- (void)setAvatar:(BmobFile *)avatar
{
    [self setObject:avatar forKey:@"avatar"];
}

- (BmobFile *)avatar
{
    return [self objectForKey:@"avatar"];
}

#pragma mark - Copy With User

+ (TJUser *)copyWithUser:(BmobUser *)user
{
    TJUser *tUser = [[TJUser alloc] init];
    tUser.name = [user objectForKey:@"name"];
    tUser.mobileNumber = [user objectForKey:@"mobileNumber"];
    tUser.userName = [user objectForKey:@"userName"];
    tUser.password = [user objectForKey:@"password"];
    TJUserGender gender = TJUserGenderFemale;
    
    if ([[user objectForKey:@"gender"] isEqualToNumber:@(0)]) {
        gender = TJUserGenderMale;
    }
    else {
        gender = TJUserGenderFemale;
    }
    
    tUser.gender = gender;
    tUser.avatar = [user objectForKey:@"avatar"];
    
    return tUser;
}

+ (TJUser *)getCurrentUser
{
    BmobUser *user = [BmobUser getCurrentUser];
    
    
    return [self copyWithUser:user];
}


@end
