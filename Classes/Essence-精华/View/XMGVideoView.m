//
//  XMGVideoView.m
//  百思不得姐
//
//  Created by weiguang on 16/6/21.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import "XMGVideoView.h"
#import "XMGTopics.h"
#import "UIImageView+WebCache.h"
#import "XMGShowPictureViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface XMGVideoView()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *videolengthLabel;
//视频播放器
@property(nonatomic,strong) MPMoviePlayerController *player;

@end

@implementation XMGVideoView


- (void)awakeFromNib{
    self.autoresizingMask = UIViewAutoresizingNone;
    
    //给图片添加监听器
    self.imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playVideo)];
    [self.imageView addGestureRecognizer:tapgesture];
}

- (void)playVideo{
    self.player = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:self.topic.videouri]];
    //设置播放器的大小
    [self.player.view setFrame:self.bounds];//16：9是主流媒体的 样式
    //将播放器视图添加到根视图
    [self addSubview:self.player.view];
    //播放
    [self.player play];

}

- (void)showPicture{
    XMGShowPictureViewController *VC = [[XMGShowPictureViewController alloc] init];
    VC.topic = self.topic;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:VC animated:YES completion:nil];
}

- (void)setTopic:(XMGTopics *)topic{
    _topic = topic;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image]];
    
    //播放次数
    self.playCountLabel.text = [NSString stringWithFormat:@"%zd播放",topic.playcount];
    
    // 时长
    NSInteger minute = topic.videotime / 60;
    NSInteger second = topic.videotime % 60;
    self.videolengthLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", minute, second];
}
@end
