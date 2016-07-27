//
//  XMGTopWindow.m
//  百思不得姐
//
//  Created by weiguang on 16/6/28.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import "XMGTopWindow.h"

@implementation XMGTopWindow
static UIWindow *window_;
static UIView *view_;
+ (void)initialize{
    window_ = [[UIWindow alloc] init];
    window_.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
    window_.windowLevel = UIWindowLevelAlert;
    [window_ addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(windowClick)]];
    window_.backgroundColor = [UIColor clearColor];
}

+ (void)show{
    
    window_.hidden = NO;
}

+ (void)hide
{
    window_.hidden = YES;
}

//监听窗口点击
+ (void)windowClick{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [self searchScrollViewInView:keyWindow];
}

+ (void)searchScrollViewInView:(UIView *)superview{
    
    for (UIScrollView *subview in superview.subviews) {
        
        //如果是ScrollView，滚回最顶部
        if ([subview isKindOfClass:[UIScrollView class]] && subview.isShowingOnKeyWindow) {
            CGPoint offset = subview.contentOffset;
            offset.y = - subview.contentInset.top;
            [subview setContentOffset:offset animated:YES];
        }
        // 继续查找子控件
        [self searchScrollViewInView:subview];
    }
}

@end
