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
#import "TJDashboardViewLayout.h"
#import "TJAppConst.h"
#import "TJClassifyViewController.h"
#import "TJMaterialDetailViewController.h"
#import <SVPullToRefresh.h>

@interface TJDashboardViewController()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *areaSegment;
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet TJDashboardViewLayout *collectionViewLayout;

@property (nonatomic, assign) TJMaterialArea area;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) BOOL hasMore;

@property (nonatomic, strong) NSMutableArray *data;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *classifyButton;
@end

@implementation TJDashboardViewController

@synthesize data = _data;

#pragma mark - Life Circle

- (void)viewDidLoad
{
    [[Routable sharedRouter] setNavigationController:self.navigationController];
    
    self.area = TJMaterialAreaBenbu;
    
    self.postButton.layer.zPosition = 1;
   // self.postButton.
    
    self.classifyName = @"全部";
    
    __weak typeof(self) weakSelf = self;
    [self.collectionView addPullToRefreshWithActionHandler:^() {
        [weakSelf refreshData];
    }];
    
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

- (void)setClassifyName:(NSString *)classifyName
{
    if (_classifyName != classifyName) {
        _classifyName = classifyName;
        [self.classifyButton setTitle:classifyName];
    }
}

#pragma mark - Load Data

- (void)refreshData
{
    self.page = 0;
    self.hasMore = YES;
    
    [[TJMaterialManager sharedMaterialManager] queryForMaterialWithType:self.area classify:self.classifyName limit:kDefaultLimit skip:self.page * kDefaultLimit complete:^(NSArray *array, NSError *error) {
        [self.collectionView.pullToRefreshView stopAnimating];
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
    
    [[TJMaterialManager sharedMaterialManager] queryForMaterialWithType:self.area classify:self.classifyName limit:kDefaultLimit skip:self.page * kDefaultLimit complete:^(NSArray *array, NSError *error) {
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

#pragma mark - Segment

- (IBAction)areaChange:(UISegmentedControl *)sender
{
    if (self.areaSegment.selectedSegmentIndex == 0) {
        self.area = TJMaterialAreaBenbu;
    }
    else {
        self.area = TJMaterialAreaJiading;
    }
    

    [self.collectionView scrollRectToVisible:CGRectZero animated:YES];
    [self.collectionView triggerPullToRefresh];
}

#pragma mark - Seg

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ClassifySelect"]) {
        UINavigationController *nav = segue.destinationViewController;
        TJClassifyViewController *classifyViewController = [nav.childViewControllers firstObject];
        classifyViewController.controller = self;
    }
}

@end
