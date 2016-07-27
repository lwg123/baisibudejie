//
//  XMGPublishViewController.m
//  百思不得姐
//
//  Created by weiguang on 16/6/14.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import "XMGPublishViewController.h"
#import "XMGVerticalButton.h"
#import "XMGPostWordViewController.h"
#import "XMGNavigationViewController.h"


@interface XMGPublishViewController ()
@property (nonatomic,strong)UIImageView *sloganView;
@property (nonatomic,strong)UIButton *myButton0;
@end

@implementation XMGPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.userInteractionEnabled = NO;
    UIImageView *sloganView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_slogan"]];
    sloganView.y = SCREEN_HEIGHT * 0.2;
    sloganView.centerX = SCREEN_WIDTH * 0.5;
    //sloganView.tag = 6;
    [self.view addSubview:sloganView];
    self.sloganView = sloganView;
    
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
        [self.view addSubview:button];
        
        if (i == 0) {
            self.myButton0 = button;
        }
        
    }
    
}

- (void)buttonClick:(UIButton *)button{
    [self cancelAnimation:^{
        if (button.tag == 2) {
            
        } 
    }];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self doAnimation];
}


- (IBAction)cancelButtonClick {
    [self cancelAnimation:^{
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
    
}

/**
 pop和Core Animation的区别
 1.Core Animation的动画只能添加到layer上
 2.pop的动画能添加到任何对象
 3.pop的底层并非基于Core Animation, 是基于CADisplayLink
 4.Core Animation的动画仅仅是表象, 并不会真正修改对象的frame\size等值
 5.pop的动画实时修改对象的属性, 真正地修改了对象的属性
 */

- (void)doAnimation{
    self.view.userInteractionEnabled = NO;
    //UIButton *myButton0 = (UIButton *)[self.view viewWithTag:0];
    UIButton *myButton1 = (UIButton *)[self.view viewWithTag:1];
    UIButton *myButton2 = (UIButton *)[self.view viewWithTag:2];
    UIButton *myButton3 = (UIButton *)[self.view viewWithTag:3];
    UIButton *myButton4 = (UIButton *)[self.view viewWithTag:4];
    UIButton *myButton5 = (UIButton *)[self.view viewWithTag:5];
    
    [self addAnimation:self.myButton0];
    [self addAnimation:myButton1];
    [self addAnimation:myButton2];
    [self addAnimation:myButton3];
    [self addAnimation:myButton4];
    [self addAnimation:myButton5];
    [self addAnimation:self.sloganView];
}

- (void)addAnimation:(UIView *)view{
    
    CASpringAnimation *springAnimation = [CASpringAnimation animationWithKeyPath:@"position.y"];
    springAnimation.stiffness          = 100;
    springAnimation.mass               = 1;
    springAnimation.damping            = 13;
    springAnimation.initialVelocity    = 0;
    springAnimation.duration           = springAnimation.settlingDuration;
    
    
    springAnimation.fromValue    = @(0-view.layer.position.y);
    
    springAnimation.toValue      = @(view.layer.position.y);
    springAnimation.beginTime = CACurrentMediaTime() + view.tag *0.1;
    [view.layer addAnimation:springAnimation forKey:nil];
    view.layer.position = CGPointMake(view.layer.position.x, view.layer.position.y);
}

- (void)cancelAnimation:(void (^)())completionBlock{
    
    int beginIndex = 2;
    for (int i = beginIndex; i<self.view.subviews.count; i++) {
        UIView *subView = self.view.subviews[i];
        
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position.y"];
      
        anim.toValue = @(SCREEN_HEIGHT + subView.layer.position.y);
        anim.beginTime = CACurrentMediaTime() + (i - beginIndex) * 0.1;
        anim.removedOnCompletion = NO;
        anim.fillMode = kCAFillModeForwards;
        anim.timingFunction =
        [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
        
        [subView.layer addAnimation:anim forKey:nil];
    }
 
    double delayInSeconds = 0.8;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
         // 执行传进来的completionBlock参数
//        if (completionBlock != nil) {
//            completionBlock();
//        }
        !completionBlock ? : completionBlock();
    });
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self cancelAnimation:^{
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
    
   // XMGLog(@"%zd",self.myButton0.tag);
}

@end
