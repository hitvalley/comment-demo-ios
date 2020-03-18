//
//  HomeTopicDetailController+comment.m
//  JoinComments
//
//  Created by gaoqingtao on 2020/3/17.
//  Copyright © 2020 Desktop. All rights reserved.
//

#import "HomeTopicDetailController+comment.h"

#import <UIKit/UIKit.h>

@implementation HomeTopicDetailController (comment)

//秒级
- (NSString *)getSecondClassTimeStamp {
    // iOS默认生成的时间戳是10位，秒级
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *timeStamp = [NSString stringWithFormat:@"%.f",time];
    return timeStamp;
}
//毫秒级
- (NSString *)getMillisecondTimeStamp {
    // 设置日期格式
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss.SSS"];
    
    NSString *dateStr =  [formatter stringFromDate:[NSDate date]];
    NSDate *date = [formatter dateFromString:dateStr];
    
    NSTimeInterval time = [date timeIntervalSince1970]*1000;
    NSString *timeStamp = [NSString stringWithFormat:@"%.f",time];
    return timeStamp;
}

+(NSString *)getNowTimeTimestamp3{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // 设置想要的格式，hh与HH的区别:分别表示12小时制,24小时制
    //设置时区,这一点对时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    return timeSp;
}
+ (NSString *)getNowTimeStamp {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // 设置想要的格式，hh与HH的区别:分别表示12小时制,24小时制
    //设置时区,这一点对时间的处理很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *dateNow = [NSDate date];
    NSString *timeStamp = [NSString stringWithFormat:@"%ld", (long)[dateNow timeIntervalSince1970]];
    return timeStamp;
}

@end
