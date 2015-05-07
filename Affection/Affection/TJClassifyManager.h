//
//  TJClassifyManager.h
//  Affection
//
//  Created by 邱峰 on 4/28/15.
//  Copyright (c) 2015 TongjiUniversity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TJClassify.h"

@class TJMaterial;

@interface TJClassifyManager : NSObject

+ (instancetype)sharedClassifyManager;

- (NSArray *)getLocalClassify;

- (void)getAllClassifies:(void (^)(NSArray *, NSError *))complete;

- (void)queryForClassify:(NSString *)classifyName complete:(void (^)(TJClassify *, NSError *) )complete;

@end
