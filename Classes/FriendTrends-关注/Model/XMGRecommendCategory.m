//
//  XMGRecommendCategory.m
//  百思不得姐
//
//  Created by weiguang on 16/5/24.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import "XMGRecommendCategory.h"

@implementation XMGRecommendCategory
- (NSMutableArray *)users{
    if (_users == nil) {
        _users = [NSMutableArray array];
    }
    return _users;
}


@end
