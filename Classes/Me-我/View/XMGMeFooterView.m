//
//  XMGMeFooterView.m
//  百思不得姐
//
//  Created by weiguang on 16/7/4.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import "XMGMeFooterView.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "XMGSquare.h"
#import "XMGSqureButton.h"
#import "XMGWebViewController.h"

@implementation XMGMeFooterView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        //参数
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"a"] = @"square";
        params[@"c"] = @"topic";
        
        //发送请求
        [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
           // NSLog(@"%@",responseObject);
            NSArray *sqaures = [XMGSquare mj_objectArrayWithKeyValuesArray:responseObject[@"square_list"]];
            // 创建方块
            [self createSquares:sqaures];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
    return self;
}

//创建方块
- (void)createSquares:(NSArray *)sqaures{
    //一行最多列
    int maxcols = 4;
    
    // 宽度和高度
    CGFloat buttonW = SCREEN_WIDTH / maxcols;
    CGFloat buttonH = buttonW;
    
    for (int i = 0; i<sqaures.count; i++) {
        XMGSqureButton *button = [XMGSqureButton buttonWithType:UIButtonTypeCustom];
        // 监听点击
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.square = sqaures[i];
        [self addSubview:button];
        
        //计算frame
        NSUInteger row = i / maxcols;
        NSUInteger col = i % maxcols;
        
        button.x = col * buttonW;
        button.y = row * buttonH;
        button.width = buttonW;
        button.height = buttonH;
    
    }
    
    //总页数
     NSUInteger rows = (sqaures.count + maxcols - 1) / maxcols;
    // 计算footer的高度
    self.height = rows * buttonH;
    
    // 重绘
    [self setNeedsDisplay];
}

- (void)buttonClick:(XMGSqureButton *)button{
    
    if (![button.square.url hasPrefix:@"http"]) return;
    XMGWebViewController *webVC = [[XMGWebViewController alloc] init];
    webVC.url = button.square.url;
    webVC.title = button.square.name;
    
   //获取当前的导航控制器
    UITabBarController *tabBarVC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = (UINavigationController *)tabBarVC.selectedViewController;
    [nav pushViewController:webVC animated:YES];
}
@end
