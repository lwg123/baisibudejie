//
//  XMGTextField.m
//  百思不得姐
//
//  Created by weiguang on 16/5/28.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import "XMGTextField.h"
#import <objc/runtime.h>

static NSString * const XMGPlacerholderColorKeyPath = @"_placeholderLabel.textColor";

@implementation XMGTextField

//- (void)drawPlaceholderInRect:(CGRect)rect{
//    [self.placeholder drawInRect:CGRectMake(0, 10, rect.size.width, 25)
//                  withAttributes:@{
//                                   NSForegroundColorAttributeName:[UIColor whiteColor],
//                                   NSFontAttributeName:self.font
//                                 }];
//}

/**
 运行时(Runtime):
 * 苹果官方一套C语言库
 * 能做很多底层操作(比如访问隐藏的一些成员变量\成员方法....)
 */

+ (void)initialize{
    //[self getIvars]; //通过可以看出隐藏的成员变量
}

+ (void)getProperties
{
    unsigned int count = 0;
    
    objc_property_t *properties = class_copyPropertyList([UITextField class], &count);
    
    for (int i = 0; i<count; i++) {
        // 取出属性
        objc_property_t property = properties[i];
        
        // 打印属性名字
        XMGLog(@"%s   <---->   %s", property_getName(property), property_getAttributes(property));
    }
    
    free(properties);
}

+(void)getIvars{
    unsigned int count = 0;
    //拷贝出所有成员变量列表
    Ivar *ivars = class_copyIvarList([UITextField class], &count);
    for (int i = 0; i<count; i++) {
        //取出成员变量
        Ivar ivar = ivars[i];
        //打印成员变量名字
        XMGLog(@"%s %s",ivar_getName(ivar),ivar_getTypeEncoding(ivar));
    }
    
    //释放
    free(ivars);
}

- (void)awakeFromNib{
//    UILabel *placeholderLabel = [self valueForKeyPath:@"_placeholderLabel"];
//    placeholderLabel.textColor = [UIColor redColor];
    
    //修改占位符颜色
    [self setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.tintColor = self.textColor;
    //不成为第一响应者
    [self resignFirstResponder];
}

/**
 * 当前文本框聚焦时就会调用
 */
- (BOOL)becomeFirstResponder{
    //修改占位文字颜色
    [self setValue:self.textColor forKeyPath:XMGPlacerholderColorKeyPath];
    return [super becomeFirstResponder];
}

/**
 * 当前文本框失去焦点时就会调用
 */
- (BOOL)resignFirstResponder
{
    // 修改占位文字颜色
    [self setValue:[UIColor grayColor] forKeyPath:XMGPlacerholderColorKeyPath];
    return [super resignFirstResponder];
}
@end
