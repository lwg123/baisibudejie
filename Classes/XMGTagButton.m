//
//  XMGTagButton.m
//  百思不得姐
//
//  Created by weiguang on 16/7/12.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import "XMGTagButton.h"

@implementation XMGTagButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setImage:[UIImage imageNamed:@"chose_tag_close_icon"] forState:UIControlStateNormal];
        self.backgroundColor = XMGRGBColor(74, 139, 209);
        self.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return self;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    [super setTitle:title forState:state];
    [self sizeToFit];
    
    self.width += 3 * XMGTagMargin;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.titleLabel.x = XMGTagMargin;
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + XMGTagMargin;
}
@end
