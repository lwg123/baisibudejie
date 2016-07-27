//
//  XMGRecommendCategoryCell.m
//  百思不得姐
//
//  Created by weiguang on 16/5/24.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import "XMGRecommendCategoryCell.h"
#import "XMGRecommendCategory.h"

@interface XMGRecommendCategoryCell()
@property (weak, nonatomic) IBOutlet UIView *selectedIndicator;


@end

@implementation XMGRecommendCategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = XMGRGBColor(244, 244, 244);
    self.selectedIndicator.backgroundColor = XMGRGBColor(219, 21, 26);
}

- (void)setCatagory:(XMGRecommendCategory *)catagory{
    _catagory = catagory;
    self.textLabel.text = catagory.name;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //重新调整内部textLabel的frame
    self.textLabel.y = 2;
    self.textLabel.height = self.contentView.height - 2 * self.textLabel.y;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.selectedIndicator.hidden = !selected;
    self.textLabel.textColor = selected? self.selectedIndicator.backgroundColor : XMGRGBColor(78, 78, 78);
}

@end
