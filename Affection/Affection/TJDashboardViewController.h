//
//  TJDashboardViewController.h
//  Affection
//
//  Created by 邱峰 on 5/2/15.
//  Copyright (c) 2015 TongjiUniversity. All rights reserved.
//

#import "TJBaseViewController.h"

@interface TJDashboardViewController : TJBaseViewController

@property (nonatomic, strong) NSString *classifyName;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
