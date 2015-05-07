//
//  TJClassifyViewController.m
//  Affection
//
//  Created by 邱峰 on 5/7/15.
//  Copyright (c) 2015 TongjiUniversity. All rights reserved.
//

#import "TJClassifyViewController.h"
#import "TJClassifyManager.h"
#import "TJClassifyTableViewCell.h"
#import "MBProgressHUD+AppProgressView.h"

@interface TJClassifyViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *data;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TJClassifyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    MBProgressHUD *loading = [MBProgressHUD progressHUDNetworkLoadingInView:nil withText:@"加载中.."];
    [[TJClassifyManager sharedClassifyManager] getAllClassifies:^(NSArray *array, NSError *error) {
        [loading hide:YES];
        if (error) {
            [MBProgressHUD showErrorProgressInView:nil withText:@"加载失败"];
        }
        else {
            self.data = array;
            [self.tableView reloadData];
        }
    }];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - get & set

- (NSArray *)data
{
    if (_data == nil) {
        _data = [NSArray array];
    }
    return _data;
}

#pragma mark - Action

- (IBAction)dismissButtonPress:(UIBarButtonItem *)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TJClassifyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TJClassifyTableViewCell class])];
    [cell setCellWithClassify:self.data[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TJClassify *classify = self.data[indexPath.row];
    self.controller.classifyName = classify.classifyName;
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
