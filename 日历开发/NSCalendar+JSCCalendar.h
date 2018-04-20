//
//  NSCalendar+JSCCalendar.h
//  日历日历
//
//  Created by TianLi on 2018/4/16.
//  Copyright © 2018年 TianLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCalendar (JSCCalendar)
#pragma mark - 获取日
- (NSInteger)day:(NSDate *)date;
#pragma mark - 获取月
- (NSInteger)month:(NSDate *)date;
#pragma mark - 获取年
- (NSInteger)year:(NSDate *)date;
#pragma mark - 上个月
- (NSDate *)lastMonth:(NSDate *)date;
#pragma mark - 下个月
- (NSDate *)nextMonth:(NSDate *)date;
#pragma mark - 获取当月第一天周几
- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date;
#pragma mark - 获取当前月有多少天
- (NSInteger)totaldaysInMonth:(NSDate *)date;
#pragma mark - 返回今天日期在日历UI中的位置下标
- (NSInteger)dateInCalendarTodaySubscript:(NSDate *)date;
#pragma mark - 计算日历在collectview中展示多少行
- (NSInteger)dataCollectViewRowcount:(NSDate *)date;
#pragma mark - 返回上月本月和下月三个月个日历数组
- (NSArray *)threedateArray:(NSDate *)date;

@end
