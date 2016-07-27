//
//  XMGRecommendUser.h
//  百思不得姐
//
//  Created by weiguang on 16/5/24.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMGRecommendUser : NSObject
@property (nonatomic,copy) NSString *header;
//粉丝
@property (nonatomic,assign) NSInteger fans_count;
//昵称
@property (nonatomic,strong) NSString *screen_name;

@end
