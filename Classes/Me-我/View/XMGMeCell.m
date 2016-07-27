//
//  XMGMeCell.m
//  百思不得姐
//
//  Created by weiguang on 16/7/4.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import "XMGMeCell.h"

@implementation XMGMeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
        self.backgroundView = bgView;
        self.textLabel.textColor = [UIColor darkGrayColor];
        self.textLabel.font = [UIFont systemFontOfSize:16];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (self.imageView.image == nil) return;
    
    self.imageView.width = 30;
    self.imageView.height = self.imageView.width;
    self.imageView.centerY = self.contentView.height/2;
    self.imageView.x = 10;
    self.textLabel.x = CGRectGetMaxX(self.imageView.frame) + 10;
}
@end
