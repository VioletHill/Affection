//
//  TJMaterialManager.h
//  Affection
//
//  Created by 邱峰 on 5/4/15.
//  Copyright (c) 2015 TongjiUniversity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TJMaterial.h"

@interface TJMaterialManager : NSObject

+ (instancetype)sharedMaterialManager;

- (void)postMaterial:(TJMaterial *)material complete:(void(^)(BOOL success, NSError *error))complete;

- (void)getMaterialComplete:(void (^)(NSArray *, NSError *))complete;

@end
