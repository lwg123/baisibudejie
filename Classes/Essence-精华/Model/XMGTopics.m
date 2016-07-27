//
//  XMGTopics.m
//  百思不得姐
//
//  Created by weiguang on 16/6/6.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import "XMGTopics.h"
#import "MJExtension.h"
#import "XMGComment.h"
#import "XMGUser.h"

@interface XMGTopics()
{
    CGFloat _cellHeight;
}
@end

@implementation XMGTopics

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"small_image" : @"image0",
             @"large_image" : @"image1",
             @"middle_image" : @"image2",
             @"ID" : @"id",
             @"top_cmt" : @"top_cmt[0]"
             };
}

//+ (NSDictionary *)objectClassInArray{
//    return @{@"top_cmt" : @"XMGComment"};
//}

/**
 今年
 今天
 1分钟内
 刚刚
 1小时内
 xx分钟前
 其他
 xx小时前
 昨天
 昨天 18:56:34
 其他
 06-23 19:56:23
 
 非今年
 2014-05-08 18:45:30
 */

- (NSString *)create_time{
    //日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 设置日期格式(y:年,M:月,d:日,H:时,m:分,s:秒)
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    //帖子的创建时间
    NSDate *create = [fmt dateFromString:_create_time];
    
    if (create.isThisYear) {//今年
        if (create.isToday) {//今天
            NSDateComponents *cmps = [[NSDate date] deltaFrom:create];
            if (cmps.hour>=1) {
                return [NSString stringWithFormat:@"%zd小时前",cmps.hour];
            } else if (cmps.minute>=1){
                return [NSString stringWithFormat:@"%zd分钟前",cmps.minute];
            } else{
                return @"刚刚";
            }
        } else if(create.isYesterday){//昨天
            fmt.dateFormat = @"昨天 HH:mm:ss";
            return [fmt stringFromDate:create];
        } else { // 其他
            fmt.dateFormat = @"MM-dd HH:mm:ss";
            return [fmt stringFromDate:create];
        }

    } else{//非今年
        return _create_time;
    }
}

- (CGFloat)cellHeight{
    if (!_cellHeight) {
        //文字的最大尺寸
        CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 4*XMGTopicCellMargin, MAXFLOAT);
        //文字的高度
        CGFloat textH = [self.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
        //文字部分cell的高度
        CGFloat cellH = XMGTopicCellTextY + textH + XMGTopicCellMargin;
        _cellHeight = cellH;
        
        //根据段子的类型来计算cell的高度
        if (self.type == XMGTopicTypePicture) {//图片帖子
            //图片显示出来的宽度
            CGFloat pictureW = maxSize.width;
            //显示出来的高度
            CGFloat pictureH = pictureW *self.height / self.width;
            if (pictureH >= XMGTopicCellPictureMaxH) { //图片高度过长
                pictureH = XMGTopicCellPictureBreakH;
                self.bigPicture = YES; //大图
            }
            
            //计算图片控件的frame
            CGFloat pictureX = XMGTopicCellMargin;
            CGFloat pictureY = XMGTopicCellTextY + textH + XMGTopicCellMargin;
            _pictureF = CGRectMake(pictureX, pictureY, pictureW, pictureH);
            
            _cellHeight += pictureH + XMGTopicCellMargin;
        } else if (self.type == XMGTopicTypeVoice){//声音
            //图片显示出来的宽度
            CGFloat voiceW = maxSize.width;
            //显示出来的高度
            CGFloat voiceH = voiceW *self.height / self.width;
            
            //计算图片控件的frame
            CGFloat voiceX = XMGTopicCellMargin;
            CGFloat voiceY = XMGTopicCellTextY + textH + XMGTopicCellMargin;
            _voiceF = CGRectMake(voiceX, voiceY, voiceW, voiceH);
            
            _cellHeight += voiceH + XMGTopicCellMargin;
            
        } else if (self.type == XMGTopicTypeVideo){ //视频
            //图片显示出来的宽度
            CGFloat videoW = maxSize.width;
            //显示出来的高度
            CGFloat videoH = videoW *self.height / self.width;
            
            //计算图片控件的frame
            CGFloat videoX = XMGTopicCellMargin;
            CGFloat videoY = XMGTopicCellTextY + textH + XMGTopicCellMargin;
            _videoF = CGRectMake(videoX, videoY, videoW, videoH);
            
            _cellHeight += videoH + XMGTopicCellMargin;
        }
        
        //如果有最热评论
       
        if (self.top_cmt) {
            NSString *content = [NSString stringWithFormat:@"%@ : %@",self.top_cmt.user.username,self.top_cmt.content];
            CGFloat contentH = [content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size.height;
            _cellHeight += XMGTopicCellTopCmtTitleH + contentH + XMGTopicCellMargin;
        }
        // 底部工具条的高度
        _cellHeight += XMGTopicCellBottomBarH + XMGTopicCellMargin;
    }
    
   
    
    return _cellHeight;
}
@end
