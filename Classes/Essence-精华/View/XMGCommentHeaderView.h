//
//  XMGCommentHeaderView.h
//  百思不得姐
//
//  Created by weiguang on 16/6/27.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMGCommentHeaderView : UITableViewHeaderFooterView

/** 文字数据 */
@property (nonatomic, copy) NSString *title;

+(instancetype)headerViewWithTableView:(UITableView *)tableView;
@end
