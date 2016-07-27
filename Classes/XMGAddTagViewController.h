//
//  XMGAddTagViewController.h
//  百思不得姐
//
//  Created by weiguang on 16/7/11.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMGAddTagViewController : UIViewController

@property (nonatomic,copy) void (^tagsBlock)(NSArray *tags);
/** 所有的标签 */
@property (nonatomic, strong) NSArray *tags;
@end
