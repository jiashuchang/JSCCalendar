//
//  NSCalendar+JSCCalendar.m
//  日历日历
//
//  Created by TianLi on 2018/4/16.
//  Copyright © 2018年 TianLi. All rights reserved.
//

#import "NSCalendar+JSCCalendar.h"

@implementation NSCalendar (JSCCalendar)

#pragma mark - 获取日
- (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return components.day;
}

#pragma mark - 获取月
- (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return components.month;
}

#pragma mark - 获取年
- (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return components.year;
}
#pragma mark - 上个月
- (NSDate *)lastMonth:(NSDate *)date {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

#pragma mark - 下个月
- (NSDate *)nextMonth:(NSDate *)date {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}
//计算日历在collectview中展示多少行思路
//思路1：int number =（ 7*6 -（这个月1号是周几+这个月的总天数））/7 判断：  如果number = 0 则是6行。如果number = 1则是5行 如果number=2或者其他则是4行
//思路2: int number = 这个月1号是周几+这个月的总天数
//        if (number>28) {
//            if (number>35) {
//                则是6行
//            }else{
//                则是5行
//            }
//        }else{
//            则是4行
//        }
#pragma mark - 计算日历在collectview中展示多少行
- (NSInteger)dataCollectViewRowcount:(NSDate *)date{
    //思路1：int number =（ 7*6 -（这个月1号是周几+这个月的总天数））/7 判断：  如果number = 0 则是6行。如果number = 1则是5行 如果number=2或者其他则是4行
//    NSInteger number = (7*6 - ([self firstWeekdayInThisMonth:date] + [self totaldaysInMonth:date]))/7;
//    NSInteger rowcount;
//    switch (number) {
//        case 0:
//            rowcount = 6;
//            break;
//        case 1:
//            rowcount = 5;
//            break;
//        case 2:
//            rowcount = 4;
//            break;
//        default:
//            rowcount = 4;
//            break;
//    }
//    return rowcount;
    
    //思路2: int number = 这个月1号是周几+这个月的总天数
    //        if (number>28) {
    //            if (number>35) {
    //                则是6行
    //            }else{
    //                则是5行
    //            }
    //        }else{
    //            则是4行
    //        }
    
    NSInteger number = [self firstWeekdayInThisMonth:date] + [self totaldaysInMonth:date];
    if (number > 28) {
        if (number >35 ) {
            return 6;
        }else{
            return 5;
        }
    }else{
        return 4;
    }
}
#pragma mark - 获得当前月份第一天星期几
- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //设置每周的第一天从周几开始,默认为1,从周日开始
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    //若设置从周日开始算起则需要减一,若从周一开始算起则不需要减
    return firstWeekday - 1;
}
#pragma mark - 获取当前月共有多少天

- (NSInteger)totaldaysInMonth:(NSDate *)date{
    NSRange daysInLastMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInLastMonth.length;
}
#pragma mark - 返回今天日期在日历UI中的位置下标
-(NSInteger)dateInCalendarTodaySubscript:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return components.day + [self firstWeekdayInThisMonth:date] - 1;
}
#pragma mark - 返回上月本月和下月三个月个日历数组
- (NSArray *)threedateArray:(NSDate *)date{
    
    NSMutableArray *mutableArray1 = [NSMutableArray array];
    NSMutableArray *mutableArray2 = [NSMutableArray array];
    NSMutableArray *mutableArray3 = [NSMutableArray array];
    
    NSDate *lastdate = [self lastMonth:date];
    NSDate *nextdate = [self nextMonth:date];
    
    for (int i = 0; i < [self totaldaysInMonth:lastdate]; i++) {
        NSString *str = [NSString stringWithFormat:@"%d",i+1];
        [mutableArray1 addObject:str];
    }
    for (int i = 0; i < [self totaldaysInMonth:date]; i++) {
        NSString *str = [NSString stringWithFormat:@"%d",i+1];
        [mutableArray2 addObject:str];
    }
    for (int i = 0; i < [self totaldaysInMonth:nextdate]; i++) {
        NSString *str = [NSString stringWithFormat:@"%d",i+1];
        [mutableArray3 addObject:str];
    }
    NSArray *array = [NSArray arrayWithObjects:mutableArray1, mutableArray2, mutableArray3, nil];
    return array;
}
@end
