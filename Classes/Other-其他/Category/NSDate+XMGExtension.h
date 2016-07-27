//
//  NSDate+XMGExtension.h
//  百思不得姐
//
//  Created by weiguang on 16/6/7.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate(XMGExtension)
//比较from和self的时间差
- (NSDateComponents *)deltaFrom:(NSDate *)from;

/**
 * 是否为今年
 */
- (BOOL)isThisYear;

/**
 * 是否为今天
 */
- (BOOL)isToday;

/**
 * 是否为昨天
 */
- (BOOL)isYesterday;

@end
