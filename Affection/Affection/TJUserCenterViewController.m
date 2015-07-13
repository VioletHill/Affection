//
//  TJUserCenterViewController.m
//  Affection
//
//  Created by 邱峰 on 5/8/15.
//  Copyright (c) 2015 TongjiUniversity. All rights reserved.
//

#import "TJUserCenterViewController.h"
#import "TJUserManager.h"
#import <UIImageView+UIActivityIndicatorForSDWebImage.h>
#import "TJUserCenterBasicCell.h"
#import "TJMyPublishViewController.h"

@interface TJUserCenterViewController() <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (nonatomic, strong) NSArray *data;

@end

const int publishCellRow = 3;

@implementation TJUserCenterViewController

#pragma mark - Life Circle

- (void)viewDidLoad
{
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:self.user.avatar.url] placeholderImage:[UIImage imageNamed:@"defaultProvide"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}

- (void)dealloc
{
  NSLog(@"delloc");
}

#pragma mark - Getter & Setter

- (NSArray *)data
{
    if (_data == nil) {
        _data = @[@"用户名", @"性别", @"电话", @"Ta的发布"];
    }
    return _data;
}

#pragma mark - Get Value

- (NSString *)getValueForIndex:(NSInteger)index
{
    if (index == 0) {
        return self.user.name;
    }
    else if (index == 1) {
        if (self.user.gender == TJUserGenderMale) {
            return @"男";
        }
        else {
            return @"女";
        }
    }
    else if (index == 2) {
        return self.user.mobileNumber;
    }
    else {
        return @"";
    }
}

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentity;
    
    if (indexPath.row == publishCellRow) {
        cellIdentity = @"TJUserCenterPublishCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
        return cell;
    }
    else {
        cellIdentity = @"TJUserCenterBasicCell";
        TJUserCenterBasicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
        cell.keyLabel.text = self.data[indexPath.row];
        cell.valueLabel.text = [self getValueForIndex:indexPath.row];
        return cell;
    }
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == publishCellRow) {
        TJMyPublishViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([TJMyPublishViewController class])];
        controller.user = self.user;
        [self.navigationController pushViewController:controller animated:YES];

    }
}

@end
