//
//  XMGCommentHeaderView.m
//  百思不得姐
//
//  Created by weiguang on 16/6/27.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import "XMGCommentHeaderView.h"
@interface XMGCommentHeaderView()
/** 文字标签 */
@property (nonatomic, weak) UILabel *label;
@end

@implementation XMGCommentHeaderView

+(instancetype)headerViewWithTableView:(UITableView *)tableView{
    static NSString *ID = @"header";
    XMGCommentHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) {
        header = [[XMGCommentHeaderView alloc] initWithReuseIdentifier:ID];
    }
    return header;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = XMGGlobalBg;
        
        //创建label
        UILabel *label = [[UILabel alloc] init];
        label.textColor = XMGRGBColor(67, 67, 67);
        label.width = 200;
        label.x = XMGTopicCellMargin;
        label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:label];
        self.label = label;
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    _title = [title copy];
    self.label.text = title;
}

@end
