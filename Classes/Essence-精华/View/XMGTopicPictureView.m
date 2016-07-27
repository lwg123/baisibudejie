//
//  XMGTopicPictureView.m
//  百思不得姐
//
//  Created by weiguang on 16/6/10.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import "XMGTopicPictureView.h"
#import "XMGTopics.h"
#import "UIImageView+WebCache.h"
#import "XMGShowPictureViewController.h"
#import "XMGProgressView.h"

@interface XMGTopicPictureView()
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet UIImageView *GIFView;

@property (weak, nonatomic) IBOutlet UIButton *SeeBigButton;
@property (weak, nonatomic) IBOutlet XMGProgressView *progressView;

@end

@implementation XMGTopicPictureView


- (void)awakeFromNib{
    self.autoresizingMask = UIViewAutoresizingNone;
   
    // 给图片添加监听器
    self.pictureView.userInteractionEnabled = YES;
    [self.pictureView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture)]];
}

- (void)showPicture{
    XMGShowPictureViewController *showPicture = [[XMGShowPictureViewController alloc] init];
    showPicture.topic = self.topic;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:showPicture animated:YES completion:nil];
}

- (void)setTopic:(XMGTopics *)topic{
    _topic = topic;
    
   //显示最新的进度值
    [self.progressView setProgress:topic.pictureProgress animated:NO];
    
    //设置图片
    //[self.pictureView sd_setImageWithURL:[NSURL URLWithString:topic.large_image]];
    [self.pictureView sd_setImageWithURL:[NSURL URLWithString:topic.large_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        self.progressView.hidden = NO;
        //计算进度值
        topic.pictureProgress = 1.0 * receivedSize / expectedSize;
        //显示进度值
        [self.progressView setProgress:topic.pictureProgress animated:NO];
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.progressView.hidden = YES;
        
        //如果是大图片，才需要进行绘图处理
        if (topic.isBigPicture == NO) return;
        
        //开启图形上下文
        UIGraphicsBeginImageContextWithOptions(topic.pictureF.size, YES, 0.0);
        //将下载完的image对象绘制到图形上下文
        CGFloat width = topic.pictureF.size.width;
        CGFloat height = width * image.size.height / image.size.width;
        [image drawInRect:CGRectMake(0, 0, width, height)];
        
        //获得图片
        self.pictureView.image = UIGraphicsGetImageFromCurrentImageContext();
        // 结束图形上下文
        UIGraphicsEndImageContext();
    }];
    //判断是否为gif
    NSString *extension = topic.large_image.pathExtension;
    self.GIFView.hidden = ![extension isEqualToString:@"gif"];
    
     // 判断是否显示"点击查看全图"
    if (topic.isBigPicture) {
        self.SeeBigButton.hidden = NO;
        [self.SeeBigButton addTarget:self action:@selector(showPicture) forControlEvents:UIControlEventTouchUpInside];
        //self.pictureView.contentMode = UIViewContentModeScaleAspectFit;
    } else{
        self.SeeBigButton.hidden = YES;
        //self.pictureView.contentMode = UIViewContentModeScaleToFill;
    }
}
@end
