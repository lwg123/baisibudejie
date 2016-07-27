//
//  UIImage+XMGExtension.m
//  百思不得姐
//
//  Created by weiguang on 16/7/1.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import "UIImage+XMGExtension.h"

@implementation UIImage (XMGExtension)
- (UIImage *)circleImage{
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0); // NO代表透明
    
    //获得上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //添加一个圆
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctx, rect);
    
    //裁剪
    CGContextClip(ctx);
    
    //将图片画上去
    [self drawInRect:rect];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}
@end
