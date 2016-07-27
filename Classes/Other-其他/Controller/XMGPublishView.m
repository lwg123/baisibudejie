//
//  XMGPublishView.m
//  百思不得姐
//
//  Created by weiguang on 16/6/16.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import "XMGPublishView.h"
#import "XMGVerticalButton.h"
#import "XMGPostWordViewController.h"
#import "XMGNavigationViewController.h"

@interface XMGPublishView()
@property (nonatomic,strong)UIImageView *sloganView;
@property (nonatomic,strong)UIButton *myButton0;

@end

@implementation XMGPublishView


- (void)awakeFromNib{
    // 数据
    NSArray *images = @[@"publish-video", @"publish-picture", @"publish-text", @"publish-audio", @"publish-review", @"publish-offline"];
    NSArray *titles = @[@"发视频", @"发图片", @"发段子", @"发声音", @"审帖", @"离线下载"];
    
    CGFloat buttonW = 72;
    CGFloat buttonH = buttonW+40;
    int  maxCols = 3;
    CGFloat startY = (SCREEN_HEIGHT - 2 * buttonH) * 0.5;
    CGFloat startX = 20;
    CGFloat margin = (SCREEN_WIDTH - 2*startX - maxCols*buttonW)/(maxCols-1);
    for (int i=0; i<images.count; i++) {
        XMGVerticalButton *button = [[XMGVerticalButton alloc] init];
        button.tag = i;
        
        //设置内容
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        //计算X/Y
        int row = i / maxCols;
        int col = i % maxCols;
        CGFloat buttonX = startX + col * (margin + buttonW);
        CGFloat buttonEndY = startY + row * buttonH;
        //  CGFloat buttonBeginY = buttonEndY - SCREEN_HEIGHT;
        button.frame = CGRectMake(buttonX, buttonEndY, buttonW, buttonH);
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
//        if (i == 0) {
//            self.myButton0 = button;
//        }
        
        //动画
        CASpringAnimation *springAnimation = [CASpringAnimation animationWithKeyPath:@"position.y"];
        springAnimation.stiffness          = 100;
        springAnimation.mass               = 1;
        springAnimation.damping            = 15;
        springAnimation.initialVelocity    = 0;
        springAnimation.duration           = springAnimation.settlingDuration;
        
        springAnimation.fromValue    = @(0-button.layer.position.y);
        
        springAnimation.toValue      = @(button.layer.position.y);
        springAnimation.beginTime = CACurrentMediaTime() + (5-button.tag) *0.1;
        [button.layer addAnimation:springAnimation forKey:nil];
        button.layer.position = CGPointMake(button.layer.position.x, button.layer.position.y);
        
    }
    
    UIImageView *sloganView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_slogan"]];
    sloganView.y = SCREEN_HEIGHT * 0.2;
    sloganView.centerX = SCREEN_WIDTH * 0.5;
    [self addSubview:sloganView];
    self.sloganView = sloganView;
    
    CASpringAnimation *springAnimation = [CASpringAnimation animationWithKeyPath:@"position.y"];
    springAnimation.stiffness          = 100;
    springAnimation.mass               = 1;
    springAnimation.damping            = 15;
    springAnimation.initialVelocity    = 0;
    springAnimation.duration           = springAnimation.settlingDuration;
    
    springAnimation.fromValue    = @(0-sloganView.layer.position.y);
    
    springAnimation.toValue      = @(sloganView.layer.position.y);
    springAnimation.beginTime = CACurrentMediaTime() + images.count *0.1;
    [sloganView.layer addAnimation:springAnimation forKey:nil];
    sloganView.layer.position = CGPointMake(sloganView.layer.position.x, sloganView.layer.position.y);
    
}

- (void)buttonClick:(UIButton *)button{
    [self cancelAnimation:^{
        if (button.tag == 0) {
            XMGLog(@"发视频");
        } else if (button.tag == 1){
            
            XMGLog(@"发图片");
        } else if (button.tag == 2){
            XMGPostWordViewController *postWord = [[XMGPostWordViewController alloc] init];
            XMGNavigationViewController *nav = [[XMGNavigationViewController alloc] initWithRootViewController:postWord];
            
            // 这里不能使用self来弹出其他控制器, 因为self执行了dismiss操作
            UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
            [root presentViewController:nav animated:YES completion:nil];
            
        } else if (button.tag == 3){
            XMGLog(@"发声音");
        } else if (button.tag == 4){
            XMGLog(@"审帖");
        } else if (button.tag == 5){
            XMGLog(@"离线下载");
        }
    }];
}

- (IBAction)cancelButtonClick {
    [self cancelAnimation:nil];
}

- (void)doAnimation{
    
    //UIButton *myButton0 = (UIButton *)[self.view viewWithTag:0];
    UIButton *myButton1 = (UIButton *)[self viewWithTag:1];
    UIButton *myButton2 = (UIButton *)[self viewWithTag:2];
    UIButton *myButton3 = (UIButton *)[self viewWithTag:3];
    UIButton *myButton4 = (UIButton *)[self viewWithTag:4];
    UIButton *myButton5 = (UIButton *)[self viewWithTag:5];
    
    [self addAnimation:self.myButton0];
    [self addAnimation:myButton1];
    [self addAnimation:myButton2];
    [self addAnimation:myButton3];
    [self addAnimation:myButton4];
    [self addAnimation:myButton5];
    [self addAnimation:self.sloganView];
    self.userInteractionEnabled = YES;
}

- (void)addAnimation:(UIView *)view{
    
    CASpringAnimation *springAnimation = [CASpringAnimation animationWithKeyPath:@"position.y"];
    springAnimation.stiffness          = 100;
    springAnimation.mass               = 1;
    springAnimation.damping            = 15;
    springAnimation.initialVelocity    = 0;
    springAnimation.duration           = springAnimation.settlingDuration;
   
    springAnimation.fromValue    = @(0-view.layer.position.y);
    
    springAnimation.toValue      = @(view.layer.position.y);
    springAnimation.beginTime = CACurrentMediaTime() + (5-view.tag) *0.1;
    [view.layer addAnimation:springAnimation forKey:nil];
    view.layer.position = CGPointMake(view.layer.position.x, view.layer.position.y);
}

- (void)cancelAnimation:(void (^)())completionBlock{
    
    int beginIndex = 1;
    int viewCount =(int)self.subviews.count-1;
    for (int i =viewCount; i>=beginIndex; i--) {
        UIView *subView = self.subviews[i];
        
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position.y"];
        
        anim.toValue = @(SCREEN_HEIGHT + subView.layer.position.y);
        anim.beginTime = CACurrentMediaTime() + (viewCount - i) * 0.1;
        anim.removedOnCompletion = NO;
        anim.fillMode = kCAFillModeForwards;
        anim.timingFunction =
        [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
        
        [subView.layer addAnimation:anim forKey:nil];
    }
    
    double delayInSeconds = 0.7;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // 执行传进来的completionBlock参数
        //        if (completionBlock != nil) {
        //            completionBlock();
        //        }
         [self removeFromSuperview];
        !completionBlock ? : completionBlock();
    });
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self cancelAnimation:nil];
    
}



@end
