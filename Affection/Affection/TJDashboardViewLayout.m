//
//  TJDashboardViewLayout.m
//  Affection
//
//  Created by 邱峰 on 5/5/15.
//  Copyright (c) 2015 TongjiUniversity. All rights reserved.
//

#import "TJDashboardViewLayout.h"
#import "TJMaterial.h"

@interface TJDashboardViewLayout()

@property (nonatomic, assign) CGFloat column0;
@property (nonatomic, assign) CGFloat column1;

@property (nonatomic, strong) NSMutableDictionary *positionDictionary;

@property (nonatomic, strong) NSMutableArray *attrs;

@end

@implementation TJDashboardViewLayout

- (NSMutableDictionary *)positionDictionary
{
    if (_positionDictionary == nil) {
        _positionDictionary = [NSMutableDictionary dictionary];
    }
    return _positionDictionary;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    self.column0 = 0;
    self.column1 = 0;
    self.positionDictionary = nil;
    self.attrs = nil;
    
    NSInteger count= self.data.count;
    if (count == 0) {
        return;
    }
    
    NSMutableArray* arrM=[NSMutableArray array];
    for (int i = 0; i < count; i++) {
        NSIndexPath* path=[NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes* attr=[self layoutAttributesForItemAtIndexPath:path];
        [arrM addObject:attr];
    }
    self.attrs = [arrM copy];
}

- (CGSize)collectionViewContentSize
{
    //return CGSizeMake(320, 1000);
    return CGSizeMake(320, MAX(self.column0, self.column1));
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrs;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.positionDictionary[indexPath] == nil) {
        self.positionDictionary[indexPath] = [self getIndexPathPosition:indexPath];
    }
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    NSValue *value = self.positionDictionary[indexPath];
    CGPoint point = [value CGPointValue];
    CGSize size = [self getIndexPathSize:indexPath];
    attributes.frame = CGRectMake(point.x, point.y, size.width, size.height);
    return attributes;
}

- (CGSize)getIndexPathSize:(NSIndexPath *)indexPath
{
    TJMaterial *material = self.data[indexPath.row];
    CGFloat width = [UIScreen mainScreen].bounds.size.width / 2 - 10;
    
    CGFloat hoverImageWidth = material.hoverImageWidth.floatValue;
    CGFloat hoverImageHeight = material.hoverImageHeight.floatValue;
    if (hoverImageWidth == 0) {
        hoverImageWidth = 200;
        hoverImageHeight = 200;
    }
    CGFloat height = hoverImageHeight / hoverImageWidth * width + 70;
    
    CGSize size = CGSizeMake(width, height);
    return size;
}

- (NSValue *)getIndexPathPosition:(NSIndexPath *)indexPath
{
    CGSize size = [self getIndexPathSize:indexPath];
    if (self.column0 <= self.column1) {
        CGFloat positionY = self.column0;
        self.column0 += size.height + 20;
        CGPoint point = CGPointMake(5, positionY);
        return [NSValue valueWithCGPoint:point];
    }
    else {
        CGFloat positionY = self.column1;
        self.column1 += size.height + 20;
        CGPoint point = CGPointMake(size.width + 15, positionY);
        return [NSValue valueWithCGPoint:point];
    }
}




@end
