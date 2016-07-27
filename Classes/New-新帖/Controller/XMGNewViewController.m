//
//  XMGNewViewController.m
//  百思不得姐
//
//  Created by weiguang on 16/5/23.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import "XMGNewViewController.h"

@interface XMGNewViewController ()

@end

@implementation XMGNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏标题
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    // 设置导航栏左边的按钮
//    UIButton *tagButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [tagButton setBackgroundImage:[UIImage imageNamed:@"MainTagSubIcon"] forState:UIControlStateNormal];
//    [tagButton setBackgroundImage:[UIImage imageNamed:@"MainTagSubIconClick"] forState:UIControlStateHighlighted];
//    tagButton.size = tagButton.currentBackgroundImage.size;
//    [tagButton addTarget:self action:@selector(tagClick) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:tagButton];
    
     self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" highImage:@"MainTagSubIconClick" target:self action:@selector(tagClick)];
    // 设置背景色
    self.view.backgroundColor = XMGGlobalBg;
}

- (void)tagClick
{
    XMGLogFunc;
}

@end
