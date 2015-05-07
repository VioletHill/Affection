//
//  TJSelfCenterViewController.m
//  Affection
//
//  Created by 邱峰 on 5/7/15.
//  Copyright (c) 2015 TongjiUniversity. All rights reserved.
//

#import "TJSelfCenterViewController.h"
#import <Routable.h>

@interface TJSelfCenterViewController()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *data;

@end

@implementation TJSelfCenterViewController

- (void)viewDidLoad
{
    
}

#pragma mark - Getter & Setter

- (NSArray *)data
{
    if (_data == nil) {
        _data = @[@"个人中心", @"我发布的消息"];
    }
    return _data;
}


#pragma mark - TableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TJSelfCenterCell"];
    
    cell.textLabel.text = self.data[indexPath.row];
    
    return cell;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        [[Routable sharedRouter] open:@"myInfo"];
    }
    else if (indexPath.row == 1) {
        [[Routable sharedRouter] open:@"myPublish"];
    }
}

@end
