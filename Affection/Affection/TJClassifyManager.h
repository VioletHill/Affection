//
//  TJClassifyManager.h
//  Affection
//
//  Created by 邱峰 on 4/28/15.
//  Copyright (c) 2015 TongjiUniversity. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TJMaterial;

@interface TJClassifyManager : NSObject

+ (instancetype)sharedClassifyManager;

- (void)queryForMaterial:(TJMaterial *)material complete:(void (^)(NSArray *, NSError *))complete;

@end
