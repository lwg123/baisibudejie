//
//  NSDate+XMGExtension.m
//  百思不得姐
//
//  Created by weiguang on 16/6/8.
//  Copyright © 2016年 weiguang. All rights reserved.
//

#import "NSDate+XMGExtension.h"

@implementation NSDate (XMGExtension)

- (NSDateComponents *)deltaFrom:(NSDate *)from{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //比较时间
    NSCalendarUnit unit = NSCalendarUnitSecond | NSCalendarUnitYear | NSCalendarUnitHour |NSCalendarUnitMonth | NSCalendarUnitMinute | NSCalendarUnitDay;
    return [calendar components:unit fromDate:from toDate:self options:0];
}

- (BOOL)isThisYear{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *nowYear = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    NSDateComponents *selfYear = [calendar components:NSCalendarUnitYear fromDate:self];
    return nowYear.year == selfYear.year;
}

- (BOOL)isToday{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *nowString = [fmt stringFromDate:[NSDate date]];
    NSString *selfString = [fmt stringFromDate:self];
    return [nowString isEqualToString:selfString];
}

- (BOOL)isYesterday{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSDate *nowDate = [fmt dateFromString:[fmt stringFromDate:[NSDate date]]];
    NSDate *selfDate = [fmt dateFromString:[fmt stringFromDate:self]];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    return cmps.year == 0
    && cmps.month == 0
    && cmps.day == 1;
    
}

@end
