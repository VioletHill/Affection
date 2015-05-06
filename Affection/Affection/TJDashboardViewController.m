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
#import <SVPullToRefresh.h>

@interface TJDashboardViewController()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *areaSegment;
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet TJDashboardViewLayout *collectionViewLayout;

@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation TJDashboardViewController

@synthesize data = _data;

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



@end
