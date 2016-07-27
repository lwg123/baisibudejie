//
//  XMGEssenceViewController.m
//  百思不得姐
//
//  Created by weiguang on 16/5/23.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import "XMGEssenceViewController.h"
#import "XMGRecommendTagsViewController.h"
#import "XMGTopicViewController.h"
#import "XMGTopWindow.h"

@interface XMGEssenceViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIView *indicatorView;
@property (nonatomic,strong) UIButton *selectedButton;
/** 顶部的所有标签 */
@property (nonatomic, strong) UIView *titlesView;

/** 底部的所有内容 */
@property (nonatomic, strong) UIScrollView *contentView;
@end

@implementation XMGEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    [self setupChildVC];
    [self setupTitlesView];
    [self setupContentView];
    // 添加一个window, 点击这个window, 可以让屏幕上的scrollView滚到最顶部
    [XMGTopWindow show];
}

/**
 * 初始化子控制器
 */
- (void)setupChildVC{
    
    XMGTopicViewController *all = [[XMGTopicViewController alloc] init];
    all.title = @"全部";
    all.type = XMGTopicTypeAll;
    [self addChildViewController:all];
    
    XMGTopicViewController *video = [[XMGTopicViewController alloc] init];
    video.title = @"视频";
    video.type = XMGTopicTypeVideo;
    [self addChildViewController:video];
    
    XMGTopicViewController *picture = [[XMGTopicViewController alloc] init];
    picture.title = @"图片";
    picture.type = XMGTopicTypePicture;
    [self addChildViewController:picture];
    
    XMGTopicViewController *word = [[XMGTopicViewController alloc] init];
    word.title = @"段子";
    word.type = XMGTopicTypeWord;
    [self addChildViewController:word];
    
    XMGTopicViewController *voice = [[XMGTopicViewController alloc] init];
    voice.title = @"声音";
    voice.type = XMGTopicTypeVoice;
    [self addChildViewController:voice];

}

- (void)setupTitlesView{
    UIView *titleView = [[UIView alloc] init];
    titleView.width = self.view.width;
    titleView.height = XMGTitilesViewH;
    titleView.y = XMGTitilesViewY;
    
    titleView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];//设置背景颜色的透明度
    [self.view addSubview:titleView];
    self.titlesView = titleView;
    
    // 底部的红色指示器
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = [UIColor redColor];
    indicatorView.height = 2;
    indicatorView.y = titleView.height - indicatorView.height;
    self.indicatorView = indicatorView;
    
    
    //创建button
    NSInteger count = self.childViewControllers.count;
    CGFloat width = titleView.width/count;
    CGFloat buttonY = 0;
    CGFloat buttonWidth = width;
    CGFloat buttonHight = titleView.height;
    for (int i = 0; i<count; i++) {
        CGFloat buttonX = i *width;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonX, buttonY, buttonWidth, buttonHight);
        button.tag = i;
        [button setTitle:self.childViewControllers[i].title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:button];
        
        //默认点击第一个按钮
        if (i == 0) {
            button.enabled = NO;
            self.selectedButton = button;
            
            // 让按钮内部的label根据文字内容来计算尺寸
            [button.titleLabel sizeToFit];
            self.indicatorView.width = button.titleLabel.width;
            self.indicatorView.centerX = button.centerX;
            
        }
    }
    [titleView addSubview:self.indicatorView];
}

- (void)setupContentView{
    //不要自动调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.frame = self.view.bounds;
    contentView.delegate = self;
    contentView.pagingEnabled = YES;
    
    [self.view insertSubview:contentView atIndex:0];
    //[self.view addSubview:contentView];
    contentView.contentSize = CGSizeMake(self.view.width * self.childViewControllers.count, 0);
    self.contentView = contentView;
    // 添加第一个控制器的view
    [self scrollViewDidEndScrollingAnimation:contentView];
    
}

- (void)setupNav{
    //设置导航栏标题
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    //利用封装的UIBarButtonItem创建新的item
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" highImage:@"MainTagSubIconClick" target:self action:@selector(tagClick)];
    self.view.backgroundColor = XMGGlobalBg;
}

- (void)buttonTap:(UIButton*)button{
    //修改按钮状态
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton = button;

    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.width = button.titleLabel.width;
        self.indicatorView.centerX = button.centerX;
    }];
    
    //滚动
    CGPoint offset = self.contentView.contentOffset;
    offset.x = button.tag * self.contentView.width;
    [self.contentView setContentOffset:offset animated:YES];
}
- (void)tagClick
{
    XMGRecommendTagsViewController * VC = [[XMGRecommendTagsViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    //当前索引
    NSInteger index = scrollView.contentOffset.x/scrollView.width;
    
    //取出子控制器
    UITableViewController *vc = self.childViewControllers[index];
    vc.view.x = scrollView.contentOffset.x;
    vc.view.y = 0; // 设置控制器view的y值为0(默认是20)
    vc.view.height = scrollView.height; // 设置控制器view的height值为整个屏幕的高度(默认是比屏幕高度少个20)
    
    [scrollView addSubview:vc.view];

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    // 点击按钮
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
  
    //此处index与self.titlesView.subviews的顺序有关，应注意子控件的添加顺序
//    for (int i = 0; i < self.titlesView.subviews.count; i++) {
//        NSLog(@"第%d个元素：%@",i,NSStringFromClass([self.titlesView.subviews[i] class]));
//    }
    
    [self buttonTap:self.titlesView.subviews[index]];
}

@end
