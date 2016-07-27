//
//  XMGComment.h
//  百思不得姐
//
//  Created by weiguang on 16/6/23.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XMGUser;

@interface XMGComment : NSObject
/** id */
@property (nonatomic, copy) NSString *ID;
/** 音频文件的时长 */
@property (nonatomic, assign) NSInteger voicetime;
/** 音频文件的路径 */
@property (nonatomic, copy) NSString *voiceuri;
//评论内容
@property (nonatomic,strong) NSString *content;
/** 被点赞的数量 */
@property (nonatomic, assign) NSInteger like_count;
//用户
@property (nonatomic,strong) XMGUser *user;
@end
