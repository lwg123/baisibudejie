//
//  XMGTopics.h
//  百思不得姐
//
//  Created by weiguang on 16/6/6.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMGComment;

@interface XMGTopics : NSObject
/** id */
@property (nonatomic, copy) NSString *ID;
//头像
@property (nonatomic,strong) NSString *profile_image;
//昵称
@property (nonatomic,strong) NSString *name;
//创建时间
@property (nonatomic,strong) NSString *create_time;
/** 文字内容 */
@property (nonatomic, copy) NSString *text;
/** 顶的数量 */
@property (nonatomic, assign) NSInteger ding;
/** 踩的数量 */
@property (nonatomic, assign) NSInteger cai;
/** 转发的数量 */
@property (nonatomic, assign) NSInteger repost;
/** 评论的数量 */
@property (nonatomic, assign) NSInteger comment;
/** 是否为新浪加V用户 */
@property (nonatomic, assign, getter=isSina_v) BOOL sina_v;
//图片的宽度
@property (nonatomic,assign) CGFloat width;
//图片的高度
@property (nonatomic,assign) CGFloat height;
//小图片的url
@property (nonatomic,copy) NSString *small_image;
//中图片的url
@property (nonatomic,copy) NSString *middle_image;
//大图片的url
@property (nonatomic,copy) NSString *large_image;
/** 帖子的类型 */
@property (nonatomic, assign) XMGTopicType type;
/** 音频时长 */
@property (nonatomic, assign) NSInteger voicetime;
/** 视频时长 */
@property (nonatomic, assign) NSInteger videotime;
/** 播放次数 */
@property (nonatomic, assign) NSInteger playcount;
/** 播放视频的URL */
@property (nonatomic, strong) NSString *videouri;
/** 最热评论(期望这个数组中存放的是XMGComment模型) */
//@property (nonatomic, strong) NSArray *top_cmt;
/** 最热评论 (此处有bug位置放在之前会不显示图片，解析分先后)*/
@property (nonatomic, strong) XMGComment *top_cmt;


/****** 额外的辅助属性 ******/
//cell的高度
@property (nonatomic,assign,readonly) CGFloat cellHeight;
/** 图片控件的frame */
@property (nonatomic, assign, readonly) CGRect pictureF;
//图片是否太大
@property (nonatomic,assign,getter=isBigPicture) BOOL bigPicture;
/** 图片的下载进度 */
@property (nonatomic, assign) CGFloat pictureProgress;

/** 声音控件的frame */
@property (nonatomic, assign, readonly) CGRect voiceF;
/** 视频控件的frame */
@property (nonatomic, assign, readonly) CGRect videoF;
@end
