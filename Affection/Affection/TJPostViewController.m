//
//  TJPostViewController.m
//  Affection
//
//  Created by 邱峰 on 5/4/15.
//  Copyright (c) 2015 TongjiUniversity. All rights reserved.
//

#import "TJPostViewController.h"
#import "TJUserManager.h"
#import <Routable.h>

@interface TJPostViewController()

@property (nonatomic, strong) TJUser *user;

@end

@implementation TJPostViewController

- (void)viewDidLoad
{
    self.user = [TJUser getCurrentUser];
    
    if (self.user == nil) {
        [self.navigationController popViewControllerAnimated:YES];
        [[Routable sharedRouter] open:@"login" animated:YES];
    }
}

@end
