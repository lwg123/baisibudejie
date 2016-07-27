//
//  XMGPushGuideView.m
//  百思不得姐
//
//  Created by weiguang on 16/6/1.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import "XMGPushGuideView.h"

@implementation XMGPushGuideView

+ (void)show{
    //NSString *key = @"CFBundleShortVersionString";
    
//    //获得当前软件的版本号
//    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
//    //获得沙盒中存储的版本号
//    NSString *sanboxVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
//    if (![currentVersion isEqualToString:sanboxVersion]) {
//        UIWindow *window = [UIApplication sharedApplication].keyWindow;
//        
//        XMGPushGuideView *guideView = [XMGPushGuideView guideView];
//        guideView.frame = window.bounds;
//        [window addSubview:guideView];
//    }
    
    //后续判断可使用如下代码判断
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
    {
        //运行第一次程序运行的代码
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        XMGPushGuideView *guideView = [XMGPushGuideView viewFromXib];
        guideView.frame = window.bounds;
        [window addSubview:guideView];
    }
    
}


- (IBAction)close {
    [self removeFromSuperview];
}

@end
