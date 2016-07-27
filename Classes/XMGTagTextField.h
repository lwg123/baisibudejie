//
//  XMGTagTextField.h
//  百思不得姐
//
//  Created by weiguang on 16/7/13.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMGTagTextField : UITextField
/** 按了删除键后的回调 */
@property (nonatomic,copy) void (^deleteBlock)();
@end
