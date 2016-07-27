//
//  XMGTopicsCell.m
//  百思不得姐
//
//  Created by weiguang on 16/6/6.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import "XMGTopicsCell.h"
#import "XMGTopics.h"
#import "UIImageView+WebCache.h"
#import "XMGTopicPictureView.h"
#import "XMGVoiceView.h"
#import "XMGVideoView.h"
#import "XMGComment.h"
#import "XMGUser.h"

@interface XMGTopicsCell()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *ding;
@property (weak, nonatomic) IBOutlet UIButton *cai;
@property (weak, nonatomic) IBOutlet UIButton *repost;
@property (weak, nonatomic) IBOutlet UIButton *comment;
@property (weak, nonatomic) IBOutlet UIImageView *SinaImageView;
//图片帖子中间的内容
@property (nonatomic,strong) XMGTopicPictureView *pictureView;
//声音帖子中间的内容
@property (nonatomic,strong) XMGVoiceView *voiceView;
//视频帖子中间的内容
@property (nonatomic,strong) XMGVideoView *videoView;
@property (weak, nonatomic) IBOutlet UILabel *topCmtContentLabel;
@property (weak, nonatomic) IBOutlet UIView *topCmtView;

@end

@implementation XMGTopicsCell

- (XMGVideoView *)videoView{
    if (!_videoView) {
        XMGVideoView *videoView = [XMGVideoView viewFromXib];
        [self.contentView addSubview:videoView];
        _videoView = videoView;
    }
    return _videoView;
}

- (XMGVoiceView *)voiceView{
    if (!_voiceView) {
        XMGVoiceView *voiceView = [XMGVoiceView viewFromXib];
        [self.contentView addSubview:voiceView];
        _voiceView = voiceView;
    }
    return _voiceView;
}

- (XMGTopicPictureView *)pictureView{
    if (!_pictureView) {
        XMGTopicPictureView *pictureView = [XMGTopicPictureView viewFromXib];
        [self.contentView addSubview:pictureView];
        _pictureView = pictureView;
    }
    return _pictureView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
    self.backgroundView = bgView;
    
//    self.headerImageView.layer.cornerRadius = self.headerImageView.width/2;
//    self.headerImageView.clipsToBounds = YES;
}


- (void)setTopic:(XMGTopics *)topic{
    _topic = topic;
    
    //新浪加V
    self.SinaImageView.hidden = !topic.isSina_v;
    
    //[self.headerImageView sd_setImageWithURL:[NSURL URLWithString:topic.profile_image] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    //设置圆形头像
    [self.headerImageView setHeader:topic.profile_image];
    
    self.nameLabel.text = topic.name;
    self.timeLabel.text = topic.create_time;
    self.contentLabel.text = topic.text;
    
    // 设置按钮文字
    [self setupButtonTitle:self.ding count:topic.ding placeholder:@"顶"];
    [self setupButtonTitle:self.cai count:topic.cai placeholder:@"踩"];
    [self setupButtonTitle:self.repost count:topic.repost placeholder:@"分享"];
    [self setupButtonTitle:self.comment count:topic.comment placeholder:@"评论"];
    
     // 根据模型类型(帖子类型)添加对应的内容到cell的中间
    if (topic.type == XMGTopicTypePicture) {
        self.pictureView.hidden = NO;
        self.pictureView.topic = topic;
        self.pictureView.frame = topic.pictureF;
        self.videoView.hidden = YES;
        self.voiceView.hidden = YES;
    } else if (topic.type == XMGTopicTypeVoice) { // 声音帖子
        self.voiceView.hidden = NO;
        self.voiceView.topic = topic;
        self.voiceView.frame = topic.voiceF;
        self.pictureView.hidden = YES;
        self.videoView.hidden = YES;
    } else if (topic.type == XMGTopicTypeVideo){
        self.videoView.hidden = NO;
        self.videoView.topic = topic;
        self.videoView.frame = topic.videoF;
        self.pictureView.hidden = YES;
        self.voiceView.hidden =  YES;
    } else{//段子
        self.videoView.hidden = YES;
        self.voiceView.hidden = YES;
        self.pictureView.hidden = YES;
    }
    
    //处理最热评论
    if (topic.top_cmt) {
        self.topCmtView.hidden = NO;
        self.topCmtContentLabel.text = [NSString stringWithFormat:@"%@ : %@",topic.top_cmt.user.username,topic.top_cmt.content];
    } else{
        self.topCmtView.hidden = YES;
    }
    
}

//设置底部按钮文字
- (void)setupButtonTitle:(UIButton *)button count:(NSInteger)count placeholder:(NSString *)placeholder{
   
    if (count > 10000) {
        placeholder = [NSString stringWithFormat:@"%.1f万", count / 10000.0];
    } else if (count > 0) {
        placeholder = [NSString stringWithFormat:@"%zd", count];
    }
    [button setTitle:placeholder forState:UIControlStateNormal];
}



- (void)setFrame:(CGRect)frame{
    frame.origin.x = XMGTopicCellMargin;
    frame.size.width -= 2*XMGTopicCellMargin;

    frame.size.height = self.topic.cellHeight - XMGTopicCellMargin;
    frame.origin.y += XMGTopicCellMargin;
    
    [super setFrame:frame];
}
- (IBAction)shareMoreBtnClick:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
   
    UIAlertAction *collection = [UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *report = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:collection];
    [alert addAction:report];
    [alert addAction:cancel];
    
    
   [[UIApplication sharedApplication].keyWindow.rootViewController  presentViewController:alert animated:YES completion:nil];

}

@end
