//
//  XMGProgressView.m
//  百思不得姐
//
//  Created by weiguang on 16/6/12.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import "XMGProgressView.h"

@implementation XMGProgressView

- (void)awakeFromNib{
    self.roundedCorners = 2;
    self.progressLabel.textColor = [UIColor whiteColor];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated{
    [super setProgress:progress animated:animated];
    
    NSString *text = [NSString stringWithFormat:@"%.0f%%",progress*100];
    self.progressLabel.text = [text stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

@end
