//
//  XMGTabBarController.m
//  百思不得姐
//
//  Created by weiguang on 16/5/23.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import "XMGTabBarController.h"
#import "XMGMeViewController.h"
#import "XMGNewViewController.h"
#import "XMGEssenceViewController.h"
#import "XMGFriendTrendsViewController.h"
#import "XMGTabBar.h"
#import "XMGNavigationViewController.h"


@implementation XMGTabBarController

+ (void)initialize{
    // 通过appearance统一设置所有UITabBarItem的文字属性
    // 后面带有UI_APPEARANCE_SELECTOR的方法, 都可以通过appearance对象来统一设置
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加子控制器
    [self setupChildVc:[[XMGEssenceViewController alloc] init] title:@"精华" image:@"tabBar_essence_icon" seletedImage:@"tabBar_essence_click_icon"];
    [self setupChildVc:[[XMGNewViewController alloc] init] title:@"新帖" image:@"tabBar_new_icon" seletedImage:@"tabBar_new_click_icon"];
    [self setupChildVc:[[XMGFriendTrendsViewController alloc] init] title:@"关注" image:@"tabBar_friendTrends_icon" seletedImage:@"tabBar_friendTrends_click_icon"];
    [self setupChildVc:[[XMGMeViewController alloc] init] title:@"我" image:@"tabBar_me_icon" seletedImage:@"tabBar_me_click_icon"];
    
    //更换tabBar,不能直接更改
    [self setValue:[[XMGTabBar alloc] init] forKeyPath:@"tabBar"];
}

/**
 * 初始化子控制器
 */
-(void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image seletedImage:(NSString *)seletedImage{
    //设置图片和文字
    vc.navigationItem.title = title;
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:seletedImage];
    
    XMGNavigationViewController *nav = [[XMGNavigationViewController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
}


@end
