//
//  XMGMeViewController.m
//  百思不得姐
//
//  Created by weiguang on 16/5/23.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import "XMGMeViewController.h"
#import "XMGSettingViewController.h"
#import "XMGMeCell.h"
#import "XMGMeFooterView.h"
#import "XMGWebViewController.h"

@implementation XMGMeViewController

static NSString *XMGMeId = @"me";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    [self setupTableView];
}

- (void)setupNav{
    self.navigationItem.title = @"我的";
    // 设置导航栏右边的按钮
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImage:@"mine-setting-icon" highImage:@"mine-setting-icon-click" target:self action:@selector(settingClick)];
    UIBarButtonItem *moonItem = [UIBarButtonItem itemWithImage:@"mine-moon-icon" highImage:@"mine-moon-icon-click" target:self action:@selector(moonClick)];
    self.navigationItem.rightBarButtonItems = @[settingItem,moonItem];
    
}

- (void)setupTableView{
    // 设置背景色
    self.tableView.backgroundColor = XMGGlobalBg;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[XMGMeCell class] forCellReuseIdentifier:XMGMeId];
    self.tableView.tableFooterView = [[XMGMeFooterView alloc] init];
    self.tableView.contentInset =  UIEdgeInsetsMake(10, 0, 0, 0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 10;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:XMGMeId];
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"登录/注册";
        cell.imageView.image = [UIImage imageNamed:@"setup-head-default"];
    } else{
        cell.textLabel.text = @"离线下载";
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)settingClick
{
    XMGSettingViewController *settingVC = [[XMGSettingViewController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void)moonClick
{
    XMGLogFunc;
}

@end
