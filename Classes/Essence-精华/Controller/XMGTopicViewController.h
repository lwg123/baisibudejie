//
//  XMGTopicViewController.h
//  百思不得姐
//
//  Created by weiguang on 16/6/9.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMGTopicViewController : UITableViewController
/** 帖子类型(交给子类去实现) */
@property (nonatomic,assign) XMGTopicType type;

@end
