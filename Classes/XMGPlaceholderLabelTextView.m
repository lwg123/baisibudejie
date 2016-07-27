//
//  XMGPlaceholderLabelTextView.m
//  百思不得姐
//
//  Created by weiguang on 16/7/11.
//  Copyright © 2016年 weiguang. All rights reserved.
//

/**
 * setNeedsDisplay方法 : 会在恰当的时刻自动调用drawRect:方法
 * setNeedsLayout方法 : 会在恰当的时刻调用layoutSubviews方法
 */

#import "XMGPlaceholderLabelTextView.h"

@interface XMGPlaceholderLabelTextView()
/** 占位文字label */
@property (nonatomic, strong) UILabel *placeholderLabel;
@end

@implementation XMGPlaceholderLabelTextView

- (UILabel *)placeholderLabel{
    if (_placeholderLabel == nil) {
        UILabel *lab = [[UILabel alloc] init];
        lab.numberOfLines = 0;
        lab.x = 4;
        lab.y = 7;
        [self addSubview:lab];
        self.placeholderLabel = lab;
    }
    return _placeholderLabel;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //垂直方向上有弹簧效果
        self.alwaysBounceVertical = YES;
        //默认字体
        self.font = [UIFont systemFontOfSize:15];
        
        //默认文字颜色
        self.placeholderColor = [UIColor grayColor];
        
        //监听文字改变
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//更新占位文字的尺寸
- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.placeholderLabel.width = self.width - 2 * self.placeholderLabel.x;
    [self.placeholderLabel sizeToFit];
}

//监听文字改变
- (void)textDidChange{
    //只要有文字label就隐藏
    self.placeholderLabel.hidden = self.hasText;
}

/**
 * 更新占位文字的尺寸
 */
- (void)updatePlaceholderLabelSize{
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH - 2 * _placeholderLabel.x, MAXFLOAT);
    self.placeholderLabel.size = [self.placeholder boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.font} context:nil].size;
    self.placeholderLabel.backgroundColor = [UIColor redColor];
}

#pragma mark - 重写setter
- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = [placeholder copy];
    
    self.placeholderLabel.text = placeholder;
    
    //[self updatePlaceholderLabelSize];
    [self setNeedsLayout];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
    self.placeholderLabel.textColor = placeholderColor;
}

- (void)setFont:(UIFont *)font{
    [super setFont:font];
    self.placeholderLabel.font = font;
   // [self updatePlaceholderLabelSize];
     [self setNeedsLayout];
}

- (void)setText:(NSString *)text{
    [super setText:text];
    [self textDidChange];
}

- (void)setAttributedText:(NSAttributedString *)attributedText{
    [super setAttributedText:attributedText];
   [self textDidChange];
}




@end
