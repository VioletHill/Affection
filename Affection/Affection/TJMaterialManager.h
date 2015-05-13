//
//  TJMaterialManager.h
//  Affection
//
//  Created by 邱峰 on 5/4/15.
//  Copyright (c) 2015 TongjiUniversity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TJMaterial.h"

@class TJUser;

@interface TJMaterialManager : NSObject

+ (instancetype)sharedMaterialManager;

- (void)postMaterial:(TJMaterial *)material complete:(void(^)(BOOL success, NSError *error))complete;

- (void)getMaterialComplete:(void (^)(NSArray *, NSError *))complete;

- (void)getMaterialWithUser:(TJUser *)user complete:(void (^)(NSArray *, NSError *))complete;

- (void)getMaterialWithType:(TJMaterialArea)area limit:(NSInteger)limit skip:(NSInteger)skip complete:(void (^)(NSArray *, NSError *))complete;

- (void)queryForMaterialWithType:(TJMaterialArea)area classify:(NSString *)classifyName limit:(NSInteger)limit skip:(NSInteger)skip complete:(void (^)(NSArray *, NSError *))complete;

- (void)searchForMaterialWithType:(TJMaterialArea)area key:(NSString *)key limit:(NSInteger)limit skip:(NSInteger)skip complete:(void (^)(NSArray *, NSError *))complete;   //根据关键字搜索 key其实对应的是数据库中的tag

@end
