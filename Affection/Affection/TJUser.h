//
//  TJUser.h
//  Affection
//
//  Created by 邱峰 on 4/28/15.
//  Copyright (c) 2015 TongjiUniversity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>

typedef NS_ENUM(NSInteger, TJUserGender) {
    TJUserGenderMale = 0, //男性
    TJUserGenderFemale = 1, //女性
};

@interface TJUser : BmobUser

@property (nonatomic, strong) NSString *mobileNumber;     //电话

@property (nonatomic, strong) NSString *name;           //用户姓名 说不定就因为卖这么东西约上了。。。

@property (nonatomic, strong) NSString *userName;       //用户名。。。 上面那个是真实姓名  注册的时候给的是userName

@property (nonatomic, strong) NSString *password;       //password 不解释

@property (nonatomic, assign) TJUserGender gender;     //性别 为什么要有这一项 因为妹子的东西显然更好卖

@property (nonatomic, strong) BmobFile *avatar;         //头像

+ (TJUser *)copyWithUser:(BmobUser *)user;

+ (TJUser *)getCurrentUser;

@end
