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

@interface TJDashboardViewController()

@property (weak, nonatomic) IBOutlet UISegmentedControl *areaSegment;

@end

@implementation TJDashboardViewController


- (void)viewDidLoad
{
    [[Routable sharedRouter] setNavigationController:self.navigationController];
}

#pragma mark - Action 


- (IBAction)postButtonPress:(UIButton *)sender {
    if ([TJUser getCurrentUser] == nil) {
        [[Routable sharedRouter] open:@"login"];
    }
    else {
        [[Routable sharedRouter] open:@"post"];
    }
}

@end
