//
//  TJMyPublishViewController.m
//  Affection
//
//  Created by 邱峰 on 5/7/15.
//  Copyright (c) 2015 TongjiUniversity. All rights reserved.
//

#import "TJMyPublishViewController.h"
#import "TJDashboardViewLayout.h"
#import "TJMaterialDetailViewController.h"
#import "TJDashboardViewCell.h"
#import "MBProgressHUD+AppProgressView.h"
#import "TJMaterialManager.h"
#import "TJUser.h"

@interface TJMyPublishViewController()

@property (nonatomic, strong) NSMutableArray *data;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet TJDashboardViewLayout *collectionViewLayout;

@end

@implementation TJMyPublishViewController

@synthesize data = _data;

- (void)viewDidLoad
{
    if (self.user.objectId == [TJUser getCurrentUser].objectId) {
        self.title = @"我的发布";
    }
    else {
        self.title = @"Ta的发布";
    }
    
    MBProgressHUD *loading = [MBProgressHUD progressHUDNetworkLoadingInView:nil withText:@"加载中.."];
    
    [[TJMaterialManager sharedMaterialManager]  getMaterialWithUser:self.user complete:^(NSArray *array, NSError *error) {
        [loading hide:YES];
        if (error) {
            [MBProgressHUD showErrorProgressInView:nil withText:@"加载失败"];
        }
        else {
            self.data = [array mutableCopy];
            [self.collectionView reloadData];
        }
    }];
}

#pragma mark - Getter & Setter

- (TJUser *)user
{
    if (_user == nil) {
        _user = [TJUser getCurrentUser];
    }
    return _user;
}

- (NSMutableArray *)data
{
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}

- (void)setData:(NSMutableArray *)data
{
    if (_data != data) {
        _data = data;
        self.collectionViewLayout.data = data;
    }
}

- (void)setCollectionView:(UICollectionView *)collectionView
{
    if (_collectionView != collectionView) {
        _collectionView = collectionView;
        [_collectionView registerNib:[UINib nibWithNibName:@"TJDashboardViewCell" bundle:nil] forCellWithReuseIdentifier:@"TJDashboardViewCell"];
    }
}


#pragma mark - UICollectionView Datasource

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
    TJDashboardViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TJDashboardViewCell class]) forIndexPath:indexPath];
    [cell setCellWithMaterial:self.data[indexPath.row]];

    return cell;
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    TJMaterialDetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([TJMaterialDetailViewController class])];
    detailViewController.material = self.data[indexPath.row];
    [self.navigationController pushViewController:detailViewController animated:YES];
}


@end
