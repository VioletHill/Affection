//
//  TJMaterialImage.h
//  Affection
//
//  Created by 邱峰 on 4/28/15.
//  Copyright (c) 2015 TongjiUniversity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>

@interface TJMaterialImage : NSObject

@property (nonatomic, strong) NSNumber *width;

@property (nonatomic, strong) NSNumber *height;

@property (nonatomic, strong) BmobFile *image;

@end
