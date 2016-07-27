//
//  XMGTabBar.m
//  百思不得姐
//
//  Created by weiguang on 16/5/23.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import "XMGTabBar.h"
#import "XMGPublishViewController.h"
#import "XMGPublishView.h"
#import "XMGPostWordViewController.h"
#import "XMGNavigationViewController.h"


@interface XMGTabBar()
/** 发布按钮 */
@property (nonatomic, strong) UIButton *publishButton;

@end

@implementation XMGTabBar

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //设置tabbar的背景图片
        [self setBackgroundImage:[UIImage imageNamed:@"tabbar-light"]];
        //发布按钮
        UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        [publishButton addTarget:self action:@selector(publishClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:publishButton];
        self.publishButton = publishButton;
    }
    return self;
}

- (void)publishClick{
    //XMGPublishViewController和XMGPublishView两种方法均可
    
//    XMGPublishViewController *publish = [[XMGPublishViewController alloc] init];
//    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:publish animated:NO completion:nil];
    
    XMGPublishView *publish = [XMGPublishView viewFromXib];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    publish.frame = window.bounds;
    [window addSubview:publish];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 标记按钮是否已经添加过监听器
    static BOOL added = NO;
    
    CGFloat width = self.width;
    CGFloat height = self.height;
    
    //设置发布按钮的frame
    self.publishButton.width = self.publishButton.currentBackgroundImage.size.width;
    self.publishButton.height = self.publishButton.currentBackgroundImage.size.height;
    self.publishButton.center = CGPointMake(width * 0.5, height * 0.5);
    
    // 设置其他UITabBarButton的frame
    CGFloat buttonY = 0;
    CGFloat buttonW = self.frame.size.width / 5;
    CGFloat buttonH = self.frame.size.height;
    NSInteger index = 0;
    for (UIControl *button in self.subviews) {
        
        if (![button isKindOfClass:[UIControl class]] || button == self.publishButton) continue;
        //计算X的值
        CGFloat buttonX = buttonW * ((index >1)?(index+1):index);
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        index++;
        
        if(added == NO){
            //监听按钮点击
            [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    added = YES;
}

- (void)buttonClick{
    //发出一个通知
    [[NSNotificationCenter defaultCenter] postNotificationName:XMGTabBarDidSelectNotification object:nil userInfo:nil];
}

@end
