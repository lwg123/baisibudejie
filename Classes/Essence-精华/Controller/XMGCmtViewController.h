//
//  XMGCmtViewController.h
//  百思不得姐
//
//  Created by weiguang on 16/6/23.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMGTopics;

@interface XMGCmtViewController : UIViewController
/** 帖子模型 */
@property (nonatomic, strong) XMGTopics *topic;
@end
