//
//  XMGRecommendTagCell.m
//  百思不得姐
//
//  Created by weiguang on 16/5/26.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import "XMGRecommendTagCell.h"
#import "XMGRecomendTags.h"
#import "UIImageView+WebCache.h"

@interface XMGRecommendTagCell()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *tittleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTittleLabel;

@end

@implementation XMGRecommendTagCell

- (void)setRecommendTag:(XMGRecomendTags *)recommendTag{
    _recommendTag = recommendTag;
    
//    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:recommendTag.image_list] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    //设置圆形头像
    [self.headerImageView setHeader:recommendTag.image_list];
    self.tittleNameLabel.text = recommendTag.theme_name;
    NSString *subNumber = nil;
    if ((int)recommendTag.sub_number < 10000) {
        subNumber = [NSString stringWithFormat:@"%zd人订阅",recommendTag.sub_number];
    } else{
         subNumber = [NSString stringWithFormat:@"%.1f万人订阅",(int)recommendTag.sub_number/10000.0];
    }
    self.subTittleLabel.text = subNumber;

}

- (void)setFrame:(CGRect)frame{
    frame.origin.x = 5;
    frame.size.width -= 2 * frame.origin.x;
    frame.size.height -= 1;
    [super setFrame:frame];
}

@end
