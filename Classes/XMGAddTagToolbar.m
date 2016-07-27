//
//  XMGAddTagToolbar.m
//  百思不得姐
//
//  Created by weiguang on 16/7/11.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import "XMGAddTagToolbar.h"
#import "XMGAddTagViewController.h"

@interface XMGAddTagToolbar()
@property (weak, nonatomic) IBOutlet UIView *topView;
/** 添加按钮 */
@property (strong, nonatomic) UIButton *addButton;
/** 存放所有的标签label */
@property (nonatomic, strong) NSMutableArray *tagLabels;

@end

@implementation XMGAddTagToolbar

- (NSMutableArray *)tagLabels{
    if (!_tagLabels) {
        _tagLabels = [NSMutableArray array];
    }
    return _tagLabels;
}

- (void)awakeFromNib{
    // 添加一个加号按钮
    UIButton *addButton = [[UIButton alloc] init];
    [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [addButton setImage:[UIImage imageNamed:@"tag_add_icon"] forState:UIControlStateNormal];
    addButton.size = addButton.currentImage.size;
    addButton.x = XMGTopicCellMargin;
    [self.topView addSubview:addButton];
    self.addButton = addButton;
    
    // 默认就拥有2个标签
    [self createTagLabels:@[@"吐槽", @"糗事"]];
}

//布局子控件的位置最好在此方法中
- (void)layoutSubviews{
    [super layoutSubviews];
    
    for (int i = 0; i<self.tagLabels.count; i++) {
        UILabel *tagLabel = self.tagLabels[i];
        //设置位置
        if (i == 0) {
            tagLabel.x = 0;
            tagLabel.y = 0;
        } else{
            UILabel *lastTagLabel = self.tagLabels[i - 1];
            // 计算当前行左边的宽度
            CGFloat leftWidth = CGRectGetMaxX(lastTagLabel.frame) + XMGTagMargin;
            // 计算当前行右边的宽度
            CGFloat rightWidth = self.topView.width - leftWidth;
            if (rightWidth >= tagLabel.width) { // 按钮显示在当前行
                tagLabel.y = lastTagLabel.y;
                tagLabel.x = leftWidth;
            } else { // 按钮显示在下一行
                tagLabel.x = 0;
                tagLabel.y = CGRectGetMaxY(lastTagLabel.frame) + XMGTagMargin;
            }
            
        }
    }
    
    // 最后一个标签
    UILabel *lastTagLabel = [self.tagLabels lastObject];
    CGFloat leftWidth = CGRectGetMaxX(lastTagLabel.frame) + XMGTagMargin;
    
    // 更新textField的frame
    if (self.topView.width - leftWidth >= self.addButton.width) {
        self.addButton.y = lastTagLabel.y;
        self.addButton.x = leftWidth;
    } else {
        self.addButton.x = 0;
        self.addButton.y = CGRectGetMaxY(lastTagLabel.frame) + XMGTagMargin;
    }
    
    //整体的高度
    CGFloat oldH = self.height;
    self.height = CGRectGetMaxY(self.addButton.frame) + 45;
    self.y -= self.height - oldH;
}

- (void)addButtonClick{
    XMGAddTagViewController *tagVC = [[XMGAddTagViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    [tagVC setTagsBlock:^(NSArray *tags) {
        [weakSelf createTagLabels:tags];
    }];
    
    tagVC.tags = [self.tagLabels valueForKeyPath:@"text"];
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = (UINavigationController *)root.presentedViewController;
    [nav pushViewController:tagVC animated:YES];
    
    // a modal 出 b
    //    [a presentViewController:b animated:YES completion:nil];
    //    a.presentedViewController -> b
    //    b.presentingViewController -> a
}

//创建标签
- (void)createTagLabels:(NSArray *)tags{
    [self.tagLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.tagLabels removeAllObjects];
    
    for (int i = 0; i<tags.count; i++) {
        UILabel *tagLabel = [[UILabel alloc] init];
        [self.tagLabels addObject:tagLabel];
        tagLabel.backgroundColor = XMGTagBg;
        tagLabel.textAlignment = NSTextAlignmentCenter;
        tagLabel.text = tags[i];
        tagLabel.font = XMGTagFont;
        // 应该要先设置文字和字体后，再进行计算
        [tagLabel sizeToFit];
        tagLabel.width += 2 * XMGTagMargin;
        tagLabel.height = XMGTagH;
        tagLabel.textColor = [UIColor whiteColor];
        [self.topView addSubview:tagLabel];
    }
    
    //重新布局子控件
    [self setNeedsLayout];
}

@end
