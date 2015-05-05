//
//  TJMaterial.h
//  Affection
//
//  Created by 邱峰 on 4/28/15.
//  Copyright (c) 2015 TongjiUniversity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>

@class TJUser;
@class TJMaterialImage;

typedef NS_ENUM(NSInteger, TJMaterialArea) {        //二手物品所在地区
    TJMaterialAreaBenbu = 0,                          //0 代表本部
    TJMaterialAreaJiading = 1,                        //1 代表嘉定
};

typedef NS_ENUM(NSInteger, TJMaterialStatus) {      //二手物品状态 是否被卖
    TJMaterialDelete = 0,                             //该物品被删除 例如 发布者不想卖了
    TJMaterialSaled  = 1,                             //该物品已经被人买了
    TJMaterialPengding = 2,                           //该物品还没有人买
    TJMaterialRequest = 3,                            //请求某种东西
};

@interface TJMaterial : BmobObject

@property (nonatomic, strong) NSString *materialDescription;    //发布者对二手物品的评论

@property (nonatomic, strong) NSNumber *price;                  //二手物品的价格   10.40元 : price = 10.40;

/**
 *  由TJMaterialImage组成的Array
 */
@property (nonatomic, strong) NSArray *images;                  //二手物品的照片 最多支持4张

@property (nonatomic, assign) TJMaterialArea area;              //发布者选择的交易地区 本部或者嘉定

@property (nonatomic, strong) NSArray *tags;                    //用户对二手物品打的tag 可以用于搜索

/**
 *  由TJClassfiy组成的Array
 *  Please do not use getter for thie property, it will return nil
 *  Use queryForMaterial in TJClassifyManager instead
 */
@property (nonatomic, strong) NSArray *classify;                //物品分类 最多支持用户一级分类和二级分类

@property (nonatomic, strong) TJUser *poster;                   //发布者

@property (nonatomic, strong) NSNumber *hoverImageWidth;        //首页显示的图片的长和宽 这样可以按照比例放大缩小
@property (nonatomic, strong) NSNumber *hoverImageHeight;       //

@property (nonatomic, strong) BmobFile *hoverImage;      // 首页显示的图片 其实就是 images[0]

@property (nonatomic, assign) TJMaterialStatus status;          //d

+ (TJMaterial *)copyWithBomb:(BmobObject *)object;

@end
