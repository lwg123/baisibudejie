//
//  XMGRecommendUserCell.m
//  百思不得姐
//
//  Created by weiguang on 16/5/24.
//  Copyright © 2016年 weiguang. All rights reserved.
//


#import "XMGRecommendUserCell.h"
#import "XMGRecommendUser.h"
#import "UIImageView+WebCache.h"

@interface XMGRecommendUserCell()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;

@end

@implementation XMGRecommendUserCell

- (void)setUser:(XMGRecommendUser *)user{
    _user = user;
    self.screenNameLabel.text = user.screen_name;
    
    NSString *fansCount = nil;
    if (user.fans_count<10000) {
        fansCount = [NSString stringWithFormat:@"%zd人关注",user.fans_count];
    } else{//大于等于10000
    
        fansCount = [NSString stringWithFormat:@"%.1f万人关注",user.fans_count/10000.0];
    }
    self.fansCountLabel.text = fansCount;
//    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:user.header] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    
    [self.headerImageView setHeader:user.header];//设置圆形头像
}


@end
