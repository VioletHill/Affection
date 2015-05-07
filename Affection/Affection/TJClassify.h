//
//  TJClassify.h
//  Affection
//
//  Created by 邱峰 on 4/28/15.
//  Copyright (c) 2015 TongjiUniversity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>

@interface TJClassify : BmobObject

@property (nonatomic, strong) NSString *classifyName;   //分类名称

+ (TJClassify *)copyWithBmobObject:(BmobObject *)object;

@end
