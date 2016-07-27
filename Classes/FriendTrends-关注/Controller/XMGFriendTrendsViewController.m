//
//  XMGFriendTrendsViewController.m
//  百思不得姐
//
//  Created by weiguang on 16/5/23.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import "XMGFriendTrendsViewController.h"
#import "XMGRecommendViewController.h"
#import "XMGLoginViewController.h"

@interface XMGFriendTrendsViewController ()

@end

@implementation XMGFriendTrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的关注";
    // 设置导航栏左边的按钮
//    UIButton *friendsButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [friendsButton setBackgroundImage:[UIImage imageNamed:@"friendsRecommentIcon"] forState:UIControlStateNormal];
//    [friendsButton setBackgroundImage:[UIImage imageNamed:@"friendsRecommentIcon-click"] forState:UIControlStateHighlighted];
//    friendsButton.size = friendsButton.currentBackgroundImage.size;
//    [friendsButton addTarget:self action:@selector(friendsClick) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:friendsButton];
    
     self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"friendsRecommentIcon" highImage:@"friendsRecommentIcon-click" target:self action:@selector(friendsClick)];
    // 设置背景色
    self.view.backgroundColor = XMGGlobalBg;
    
}

- (void)friendsClick
{
    XMGRecommendViewController *vc = [[XMGRecommendViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)loginButton:(id)sender {
    XMGLoginViewController *VC = [[XMGLoginViewController alloc] init];
    [self.navigationController presentViewController:VC animated:YES completion:nil];
}

@end
