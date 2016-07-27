//
//  XMGTagTextField.m
//  百思不得姐
//
//  Created by weiguang on 16/7/13.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import "XMGTagTextField.h"

@implementation XMGTagTextField

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.placeholder = @"多个标签用逗号或者换行隔开";
        // 设置了占位文字内容以后, 才能设置占位文字的颜色
        [self setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
        self.height = XMGTagH;
    }
    return self;
}

- (void)deleteBackward{
    !self.deleteBlock ? : self.deleteBlock();
    
    [super deleteBackward];
}

// 也能在这个方法中监听键盘的输入，比如输入“换行”
//- (void)insertText:(NSString *)text
//{
//    [super insertText:text];
//
//    XMGLog(@"%d", [text isEqualToString:@"\n"]);
//}


@end
