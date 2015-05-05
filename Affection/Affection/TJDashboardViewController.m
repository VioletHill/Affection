//
//  TJDashboardViewController.m
//  Affection
//
//  Created by 邱峰 on 5/2/15.
//  Copyright (c) 2015 TongjiUniversity. All rights reserved.
//

#import "TJDashboardViewController.h"
#import <Routable.h>
#import "TJUserManager.h"
#import "TJDashboardViewCell.h"
#import "MBProgressHUD+AppProgressView.h"
#import <SVPullToRefresh.h>

@interface TJDashboardViewController()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UISegmentedControl *areaSegment;
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, strong) NSMutableDictionary *positionDictionary;

@property (nonatomic, assign) CGFloat column0;
@property (nonatomic, assign) CGFloat column1;

@end

@implementation TJDashboardViewController


- (void)viewDidLoad
{
    [[Routable sharedRouter] setNavigationController:self.navigationController];
    self.postButton.layer.zPosition = 1;
   // self.postButton.
    
    __weak typeof(self) weakSelf = self;
    [self.collectionView addPullToRefreshWithActionHandler:^() {
        [weakSelf refreshData];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.collectionView triggerPullToRefresh];
}

#pragma mark - Getter & Setter

- (NSMutableArray *)data
{
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}

- (NSMutableDictionary *)positionDictionary
{
    if (_positionDictionary == nil) {
        _positionDictionary = [NSMutableDictionary dictionary];
    }
    return _positionDictionary;
}

#pragma mark - refreshData

- (void)refreshData
{
    [[TJMaterialManager sharedMaterialManager] getMaterialComplete:^(NSArray *array, NSError *error) {
        [self.collectionView.pullToRefreshView stopAnimating];
        if (error) {
            [MBProgressHUD showErrorProgressInView:nil withText:@"加载失败"];
        }
        else {
            self.data = [array mutableCopy];
            for (int i = 0; i < 10; i++) {
                [self.data addObjectsFromArray:array];
            }
            [self.collectionView reloadData];
        }
    }];
}

#pragma mark - Action 
- (IBAction)addButtonPress:(id)sender
{
    if ([TJUser getCurrentUser] == nil) {
        [[Routable sharedRouter] open:@"login"];
    }
    else {
        [[Routable sharedRouter] open:@"post"];
    }

}

- (IBAction)postButtonPress:(UIButton *)sender
{
    if ([TJUser getCurrentUser] == nil) {
        [[Routable sharedRouter] open:@"login"];
    }
    else {
        [[Routable sharedRouter] open:@"post"];
    }
}

#pragma mark - UICollectionView Delegate & Datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TJDashboardViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TJDashboardViewCell class]) forIndexPath:indexPath];
    [cell setCellWithMaterial:self.data[indexPath.row]];
    
    if (self.positionDictionary[indexPath] == nil) {
        self.positionDictionary[indexPath] = [self getIndexPathPosition:indexPath];
    }
    
    NSValue *value = self.positionDictionary[indexPath];
    CGSize size = [self getIndexPathSize:indexPath];
    CGPoint position = [value CGPointValue];
    
    cell.frame = CGRectMake(position.x, position.y, size.width, size.height);
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getIndexPathSize:indexPath];
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

- (CGSize)getIndexPathSize:(NSIndexPath *)indexPath
{
    TJMaterial *material = self.data[indexPath.row];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width / 2 - 10;
    CGSize size = CGSizeMake(width, material.hoverImageWidth.floatValue / material.hoverImageHeight.floatValue * width + 50);
    return size;

}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets edgeInsets = {-100,5,5,5};
    return edgeInsets;
}

@end
