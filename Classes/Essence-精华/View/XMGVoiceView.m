//
//  XMGVoiceView.m
//  百思不得姐
//
//  Created by weiguang on 16/6/21.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import "XMGVoiceView.h"
#import "XMGTopics.h"
#import "UIImageView+WebCache.h"
#import "XMGShowPictureViewController.h"

@interface XMGVoiceView()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *playcountLabel;

@property (weak, nonatomic) IBOutlet UILabel *voicelengthLabel;

@end

@implementation XMGVoiceView


- (void)awakeFromNib{
    self.autoresizingMask = UIViewAutoresizingNone;
    self.imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture)];
    [self.imageView addGestureRecognizer:tapGest];
   
}

- (void)showPicture{
    XMGShowPictureViewController *showPicture = [[XMGShowPictureViewController alloc] init];
    showPicture.topic = self.topic;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:showPicture animated:YES completion:nil];
}

- (void)setTopic:(XMGTopics *)topic{
    _topic = topic;
    
    //图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image]];
    
    self.playcountLabel.text = [NSString stringWithFormat:@"%zd播放",topic.playcount];
    
    //时长
    NSInteger minute = topic.voicetime/60;
    NSInteger second = topic.voicetime%60;
    self.voicelengthLabel.text = [NSString stringWithFormat:@"%02zd:02%zd",minute,second];
   
}

@end
