//
//  TJSearchViewController.m
//  Affection
//
//  Created by 邱峰 on 5/14/15.
//  Copyright (c) 2015 TongjiUniversity. All rights reserved.
//

#import "TJSearchViewController.h"
#import "TJMaterialManager.h"
#import "TJAppConst.h"
#import "TJDashboardViewLayout.h"
#import "TJDashboardViewCell.h"
#import "TJMaterialDetailViewController.h"
#import "MBProgressHUD+AppProgressView.h"

@interface TJSearchViewController()<UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet TJDashboardViewLayout *collectionViewLayout;

@property (nonatomic, assign) BOOL hasMore;

@property (nonatomic, strong) NSString *searchText;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation TJSearchViewController

@synthesize data = _data;

- (void)viewDidLoad
{
    self.navigationItem.titleView = self.searchBar;
}

#pragma mark - Getter & Setter

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

- (UISearchBar *)searchBar
{
    if (_searchBar == nil) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (void)setCollectionView:(UICollectionView *)collectionView
{
    if (_collectionView != collectionView) {
        _collectionView = collectionView;
        [_collectionView registerNib:[UINib nibWithNibName:@"TJDashboardViewCell" bundle:nil] forCellWithReuseIdentifier:@"TJDashboardViewCell"];
    }
}

#pragma mark - Load Data

- (void)refreshData
{
    self.page = 0;
    self.hasMore = YES;
    MBProgressHUD *progress = [MBProgressHUD progressHUDNetworkLoadingInView:self.view withText:@"搜索中.."];
    [[TJMaterialManager sharedMaterialManager] searchForKey:self.searchText limit:kDefaultLimit skip:self.page * kDefaultLimit complete:^(NSArray *array, NSError *error) {
        [progress hide:YES];
        if (error) {
            [MBProgressHUD showErrorProgressInView:nil withText:@"加载失败"];
        }
        else {
            self.page = self.page + 1;
            self.data = [array mutableCopy];
            [self.collectionView reloadData];
            
            if (array.count < kDefaultLimit) {
                self.hasMore = NO;
            }
        }
    }];
}

- (void)addMore
{
    if (!self.hasMore) {
        return;
    }
    
    [[TJMaterialManager sharedMaterialManager] searchForKey:self.searchText limit:kDefaultLimit skip:self.page * kDefaultLimit complete:^(NSArray *array, NSError *error) {
        if (error) {
        }
        else {
            self.page = self.page + 1;
            [self.collectionView performBatchUpdates:^() {
                NSMutableArray *arrayWithIndexPaths = [NSMutableArray array];
                for (NSInteger i = self.data.count; i < array.count + self.data.count; i ++) {
                    [arrayWithIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                }
                [self.data addObjectsFromArray:array];
                [self.collectionView insertItemsAtIndexPaths:arrayWithIndexPaths];
            } completion:nil];
            
            if (array.count < kDefaultLimit) {
                self.hasMore = NO;
            }
        }

    }];
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
    
    if (indexPath.row == self.data.count - 1) {
        [self addMore];
    }
    
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

#pragma mark - Search Bar Delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.page = 0;
    self.searchText = [self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    [self refreshData];
}


@end
